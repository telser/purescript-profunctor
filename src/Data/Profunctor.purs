module Data.Profunctor where

import Prelude

-- | A `Profunctor` is a `Functor` from the pair category `(Type^op, Type)`
-- | to `Type`.
-- |
-- | In other words, a `Profunctor` is a type constructor of two type
-- | arguments, which is contravariant in its first argument and covariant
-- | in its second argument.
-- |
-- | The `dimap` function can be used to map functions over both arguments
-- | simultaneously.
-- |
-- | A straightforward example of a profunctor is the function arrow `(->)`.
-- |
-- | Laws:
-- |
-- | - Identity: `dimap id id = id`
-- | - Composition: `dimap f1 g1 <<< dimap f2 g2 = dimap (f1 >>> f2) (g1 <<< g2)`
class Profunctor p where
  dimap :: forall a b c d. (a -> b) -> (c -> d) -> p b c -> p a d

-- | Map a function over the (contravariant) first type argument only.
lmap :: forall a b c p. (Profunctor p) => (a -> b) -> p b c -> p a c
lmap a2b = dimap a2b id

-- | Map a function over the (covariant) second type argument only.
rmap :: forall a b c p. (Profunctor p) => (b -> c) -> p a b -> p a c
rmap b2c = dimap id b2c

-- | Lift a pure function into any `Profunctor` which is also a `Category`.
arr :: forall a b p. (Category p, Profunctor p) => (a -> b) -> p a b
arr f = rmap f id

instance profunctorFn :: Profunctor (->) where
  dimap a2b c2d b2c = a2b >>> b2c >>> c2d
