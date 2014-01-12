Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaALSqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:46:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaALSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:44:42 -0500
Date: Sun, 12 Jan 2014 10:43:16 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2e4f5382d12a441b5cccfdde00308df15c2ce300@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, mingo@kernel.org,
        torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        peterz@infradead.org, tony.luck@intel.com, fweisbec@gmail.com,
        linux@arm.linux.org.uk, heiko.carstens@de.ibm.com, oleg@redhat.com,
        VICTORK@il.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, geert@linux-m68k.org, mikey@neuling.org
Reply-To: mingo@kernel.org, mathieu.desnoyers@polymtl.ca,
        torvalds@linux-foundation.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, tony.luck@intel.com, fweisbec@gmail.com,
        linux@arm.linux.org.uk, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        VICTORK@il.ibm.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        geert@linux-m68k.org, benh@kernel.crashing.org, mikey@neuling.org
In-Reply-To: <20131217092435.GC21999@twins.programming.kicks-ass.net>
References: <20131217092435.GC21999@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/doc: Rename LOCK/UNLOCK to ACQUIRE/
 RELEASE
Git-Commit-ID: 2e4f5382d12a441b5cccfdde00308df15c2ce300
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:43:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e4f5382d12a441b5cccfdde00308df15c2ce300
Gitweb:     http://git.kernel.org/tip/2e4f5382d12a441b5cccfdde00308df15c2ce300
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 6 Nov 2013 14:57:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:37:13 +0100

locking/doc: Rename LOCK/UNLOCK to ACQUIRE/RELEASE

The LOCK and UNLOCK barriers as described in our barrier document are
generally known as ACQUIRE and RELEASE barriers in other literature.

Since we plan to introduce the acquire and release nomenclature in
generic kernel primitives we should amend the document to avoid
confusion as to what an acquire/release means.

Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20131217092435.GC21999@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/memory-barriers.txt | 237 +++++++++++++++++++-------------------
 1 file changed, 121 insertions(+), 116 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index cb753c8..102dc19 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -381,39 +381,44 @@ Memory barriers come in four basic varieties:
 
 And a couple of implicit varieties:
 
- (5) LOCK operations.
+ (5) ACQUIRE operations.
 
      This acts as a one-way permeable barrier.  It guarantees that all memory
-     operations after the LOCK operation will appear to happen after the LOCK
-     operation with respect to the other components of the system.
+     operations after the ACQUIRE operation will appear to happen after the
+     ACQUIRE operation with respect to the other components of the system.
+     ACQUIRE operations include LOCK operations and smp_load_acquire()
+     operations.
 
-     Memory operations that occur before a LOCK operation may appear to happen
-     after it completes.
+     Memory operations that occur before an ACQUIRE operation may appear to
+     happen after it completes.
 
-     A LOCK operation should almost always be paired with an UNLOCK operation.
+     An ACQUIRE operation should almost always be paired with a RELEASE
+     operation.
 
 
- (6) UNLOCK operations.
+ (6) RELEASE operations.
 
      This also acts as a one-way permeable barrier.  It guarantees that all
-     memory operations before the UNLOCK operation will appear to happen before
-     the UNLOCK operation with respect to the other components of the system.
+     memory operations before the RELEASE operation will appear to happen
+     before the RELEASE operation with respect to the other components of the
+     system. RELEASE operations include UNLOCK operations and
+     smp_store_release() operations.
 
-     Memory operations that occur after an UNLOCK operation may appear to
+     Memory operations that occur after a RELEASE operation may appear to
      happen before it completes.
 
-     The use of LOCK and UNLOCK operations generally precludes the need for
-     other sorts of memory barrier (but note the exceptions mentioned in the
-     subsection "MMIO write barrier").  In addition, an UNLOCK+LOCK pair
-     is -not- guaranteed to act as a full memory barrier.  However,
-     after a LOCK on a given lock variable, all memory accesses preceding any
-     prior UNLOCK on that same variable are guaranteed to be visible.
-     In other words, within a given lock variable's critical section,
-     all accesses of all previous critical sections for that lock variable
-     are guaranteed to have completed.
+     The use of ACQUIRE and RELEASE operations generally precludes the need
+     for other sorts of memory barrier (but note the exceptions mentioned in
+     the subsection "MMIO write barrier").  In addition, a RELEASE+ACQUIRE
+     pair is -not- guaranteed to act as a full memory barrier.  However, after
+     an ACQUIRE on a given variable, all memory accesses preceding any prior
+     RELEASE on that same variable are guaranteed to be visible.  In other
+     words, within a given variable's critical section, all accesses of all
+     previous critical sections for that variable are guaranteed to have
+     completed.
 
-     This means that LOCK acts as a minimal "acquire" operation and
-     UNLOCK acts as a minimal "release" operation.
+     This means that ACQUIRE acts as a minimal "acquire" operation and
+     RELEASE acts as a minimal "release" operation.
 
 
 Memory barriers are only required where there's a possibility of interaction
@@ -1585,7 +1590,7 @@ There are some more advanced barrier functions:
 	clear_bit( ... );
 
      This prevents memory operations before the clear leaking to after it.  See
-     the subsection on "Locking Functions" with reference to UNLOCK operation
+     the subsection on "Locking Functions" with reference to RELEASE operation
      implications.
 
      See Documentation/atomic_ops.txt for more information.  See the "Atomic
@@ -1619,8 +1624,8 @@ provide more substantial guarantees, but these may not be relied upon outside
 of arch specific code.
 
 
-LOCKING FUNCTIONS
------------------
+ACQUIRING FUNCTIONS
+-------------------
 
 The Linux kernel has a number of locking constructs:
 
@@ -1631,106 +1636,106 @@ The Linux kernel has a number of locking constructs:
  (*) R/W semaphores
  (*) RCU
 
-In all cases there are variants on "LOCK" operations and "UNLOCK" operations
+In all cases there are variants on "ACQUIRE" operations and "RELEASE" operations
 for each construct.  These operations all imply certain barriers:
 
- (1) LOCK operation implication:
+ (1) ACQUIRE operation implication:
 
-     Memory operations issued after the LOCK will be completed after the LOCK
-     operation has completed.
+     Memory operations issued after the ACQUIRE will be completed after the
+     ACQUIRE operation has completed.
 
-     Memory operations issued before the LOCK may be completed after the
-     LOCK operation has completed.  An smp_mb__before_spinlock(), combined
-     with a following LOCK, orders prior loads against subsequent stores
-     and stores and prior stores against subsequent stores.  Note that
-     this is weaker than smp_mb()!  The smp_mb__before_spinlock()
-     primitive is free on many architectures.
+     Memory operations issued before the ACQUIRE may be completed after the
+     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
+     with a following ACQUIRE, orders prior loads against subsequent stores and
+     stores and prior stores against subsequent stores.  Note that this is
+     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
+     many architectures.
 
- (2) UNLOCK operation implication:
+ (2) RELEASE operation implication:
 
-     Memory operations issued before the UNLOCK will be completed before the
-     UNLOCK operation has completed.
+     Memory operations issued before the RELEASE will be completed before the
+     RELEASE operation has completed.
 
-     Memory operations issued after the UNLOCK may be completed before the
-     UNLOCK operation has completed.
+     Memory operations issued after the RELEASE may be completed before the
+     RELEASE operation has completed.
 
- (3) LOCK vs LOCK implication:
+ (3) ACQUIRE vs ACQUIRE implication:
 
-     All LOCK operations issued before another LOCK operation will be completed
-     before that LOCK operation.
+     All ACQUIRE operations issued before another ACQUIRE operation will be
+     completed before that ACQUIRE operation.
 
- (4) LOCK vs UNLOCK implication:
+ (4) ACQUIRE vs RELEASE implication:
 
-     All LOCK operations issued before an UNLOCK operation will be completed
-     before the UNLOCK operation.
+     All ACQUIRE operations issued before a RELEASE operation will be
+     completed before the RELEASE operation.
 
- (5) Failed conditional LOCK implication:
+ (5) Failed conditional ACQUIRE implication:
 
-     Certain variants of the LOCK operation may fail, either due to being
-     unable to get the lock immediately, or due to receiving an unblocked
+     Certain locking variants of the ACQUIRE operation may fail, either due to
+     being unable to get the lock immediately, or due to receiving an unblocked
      signal whilst asleep waiting for the lock to become available.  Failed
      locks do not imply any sort of barrier.
 
-[!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
-    barriers is that the effects of instructions outside of a critical section
-    may seep into the inside of the critical section.
+[!] Note: one of the consequences of lock ACQUIREs and RELEASEs being only
+one-way barriers is that the effects of instructions outside of a critical
+section may seep into the inside of the critical section.
 
-A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
-because it is possible for an access preceding the LOCK to happen after the
-LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
-two accesses can themselves then cross:
+An ACQUIRE followed by a RELEASE may not be assumed to be full memory barrier
+because it is possible for an access preceding the ACQUIRE to happen after the
+ACQUIRE, and an access following the RELEASE to happen before the RELEASE, and
+the two accesses can themselves then cross:
 
 	*A = a;
-	LOCK M
-	UNLOCK M
+	ACQUIRE M
+	RELEASE M
 	*B = b;
 
 may occur as:
 
-	LOCK M, STORE *B, STORE *A, UNLOCK M
+	ACQUIRE M, STORE *B, STORE *A, RELEASE M
 
-This same reordering can of course occur if the LOCK and UNLOCK are
-to the same lock variable, but only from the perspective of another
-CPU not holding that lock.
+This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
+to the same lock variable, but only from the perspective of another CPU not
+holding that lock.
 
-In short, an UNLOCK followed by a LOCK may -not- be assumed to be a full
-memory barrier because it is possible for a preceding UNLOCK to pass a
-later LOCK from the viewpoint of the CPU, but not from the viewpoint
+In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
+memory barrier because it is possible for a preceding RELEASE to pass a
+later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
 of the compiler.  Note that deadlocks cannot be introduced by this
-interchange because if such a deadlock threatened, the UNLOCK would
+interchange because if such a deadlock threatened, the RELEASE would
 simply complete.
 
-If it is necessary for an UNLOCK-LOCK pair to produce a full barrier,
-the LOCK can be followed by an smp_mb__after_unlock_lock() invocation.
-This will produce a full barrier if either (a) the UNLOCK and the LOCK
-are executed by the same CPU or task, or (b) the UNLOCK and LOCK act
-on the same lock variable.  The smp_mb__after_unlock_lock() primitive
-is free on many architectures.  Without smp_mb__after_unlock_lock(),
-the critical sections corresponding to the UNLOCK and the LOCK can cross:
+If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
+ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
+will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
+executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
+same variable.  The smp_mb__after_unlock_lock() primitive is free on many
+architectures.  Without smp_mb__after_unlock_lock(), the critical sections
+corresponding to the RELEASE and the ACQUIRE can cross:
 
 	*A = a;
-	UNLOCK M
-	LOCK N
+	RELEASE M
+	ACQUIRE N
 	*B = b;
 
 could occur as:
 
-	LOCK N, STORE *B, STORE *A, UNLOCK M
+	ACQUIRE N, STORE *B, STORE *A, RELEASE M
 
 With smp_mb__after_unlock_lock(), they cannot, so that:
 
 	*A = a;
-	UNLOCK M
-	LOCK N
+	RELEASE M
+	ACQUIRE N
 	smp_mb__after_unlock_lock();
 	*B = b;
 
 will always occur as either of the following:
 
-	STORE *A, UNLOCK, LOCK, STORE *B
-	STORE *A, LOCK, UNLOCK, STORE *B
+	STORE *A, RELEASE, ACQUIRE, STORE *B
+	STORE *A, ACQUIRE, RELEASE, STORE *B
 
-If the UNLOCK and LOCK were instead both operating on the same lock
+If the RELEASE and ACQUIRE were instead both operating on the same lock
 variable, only the first of these two alternatives can occur.
 
 Locks and semaphores may not provide any guarantee of ordering on UP compiled
@@ -1745,33 +1750,33 @@ As an example, consider the following:
 
 	*A = a;
 	*B = b;
-	LOCK
+	ACQUIRE
 	*C = c;
 	*D = d;
-	UNLOCK
+	RELEASE
 	*E = e;
 	*F = f;
 
 The following sequence of events is acceptable:
 
-	LOCK, {*F,*A}, *E, {*C,*D}, *B, UNLOCK
+	ACQUIRE, {*F,*A}, *E, {*C,*D}, *B, RELEASE
 
 	[+] Note that {*F,*A} indicates a combined access.
 
 But none of the following are:
 
-	{*F,*A}, *B,	LOCK, *C, *D,	UNLOCK, *E
-	*A, *B, *C,	LOCK, *D,	UNLOCK, *E, *F
-	*A, *B,		LOCK, *C,	UNLOCK, *D, *E, *F
-	*B,		LOCK, *C, *D,	UNLOCK, {*F,*A}, *E
+	{*F,*A}, *B,	ACQUIRE, *C, *D,	RELEASE, *E
+	*A, *B, *C,	ACQUIRE, *D,		RELEASE, *E, *F
+	*A, *B,		ACQUIRE, *C,		RELEASE, *D, *E, *F
+	*B,		ACQUIRE, *C, *D,	RELEASE, {*F,*A}, *E
 
 
 
 INTERRUPT DISABLING FUNCTIONS
 -----------------------------
 
-Functions that disable interrupts (LOCK equivalent) and enable interrupts
-(UNLOCK equivalent) will act as compiler barriers only.  So if memory or I/O
+Functions that disable interrupts (ACQUIRE equivalent) and enable interrupts
+(RELEASE equivalent) will act as compiler barriers only.  So if memory or I/O
 barriers are required in such a situation, they must be provided from some
 other means.
 
@@ -1910,17 +1915,17 @@ Other functions that imply barriers:
  (*) schedule() and similar imply full memory barriers.
 
 
-=================================
-INTER-CPU LOCKING BARRIER EFFECTS
-=================================
+===================================
+INTER-CPU ACQUIRING BARRIER EFFECTS
+===================================
 
 On SMP systems locking primitives give a more substantial form of barrier: one
 that does affect memory access ordering on other CPUs, within the context of
 conflict on any particular lock.
 
 
-LOCKS VS MEMORY ACCESSES
-------------------------
+ACQUIRES VS MEMORY ACCESSES
+---------------------------
 
 Consider the following: the system has a pair of spinlocks (M) and (Q), and
 three CPUs; then should the following sequence of events occur:
@@ -1928,24 +1933,24 @@ three CPUs; then should the following sequence of events occur:
 	CPU 1				CPU 2
 	===============================	===============================
 	ACCESS_ONCE(*A) = a;		ACCESS_ONCE(*E) = e;
-	LOCK M				LOCK Q
+	ACQUIRE M			ACQUIRE Q
 	ACCESS_ONCE(*B) = b;		ACCESS_ONCE(*F) = f;
 	ACCESS_ONCE(*C) = c;		ACCESS_ONCE(*G) = g;
-	UNLOCK M			UNLOCK Q
+	RELEASE M			RELEASE Q
 	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*H) = h;
 
 Then there is no guarantee as to what order CPU 3 will see the accesses to *A
 through *H occur in, other than the constraints imposed by the separate locks
 on the separate CPUs. It might, for example, see:
 
-	*E, LOCK M, LOCK Q, *G, *C, *F, *A, *B, UNLOCK Q, *D, *H, UNLOCK M
+	*E, ACQUIRE M, ACQUIRE Q, *G, *C, *F, *A, *B, RELEASE Q, *D, *H, RELEASE M
 
 But it won't see any of:
 
-	*B, *C or *D preceding LOCK M
-	*A, *B or *C following UNLOCK M
-	*F, *G or *H preceding LOCK Q
-	*E, *F or *G following UNLOCK Q
+	*B, *C or *D preceding ACQUIRE M
+	*A, *B or *C following RELEASE M
+	*F, *G or *H preceding ACQUIRE Q
+	*E, *F or *G following RELEASE Q
 
 
 However, if the following occurs:
@@ -1953,29 +1958,29 @@ However, if the following occurs:
 	CPU 1				CPU 2
 	===============================	===============================
 	ACCESS_ONCE(*A) = a;
-	LOCK M		     [1]
+	ACQUIRE M		     [1]
 	ACCESS_ONCE(*B) = b;
 	ACCESS_ONCE(*C) = c;
-	UNLOCK M	     [1]
+	RELEASE M	     [1]
 	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*E) = e;
-					LOCK M		     [2]
+					ACQUIRE M		     [2]
 					smp_mb__after_unlock_lock();
 					ACCESS_ONCE(*F) = f;
 					ACCESS_ONCE(*G) = g;
-					UNLOCK M	     [2]
+					RELEASE M	     [2]
 					ACCESS_ONCE(*H) = h;
 
 CPU 3 might see:
 
-	*E, LOCK M [1], *C, *B, *A, UNLOCK M [1],
-		LOCK M [2], *H, *F, *G, UNLOCK M [2], *D
+	*E, ACQUIRE M [1], *C, *B, *A, RELEASE M [1],
+		ACQUIRE M [2], *H, *F, *G, RELEASE M [2], *D
 
 But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 
-	*B, *C, *D, *F, *G or *H preceding LOCK M [1]
-	*A, *B or *C following UNLOCK M [1]
-	*F, *G or *H preceding LOCK M [2]
-	*A, *B, *C, *E, *F or *G following UNLOCK M [2]
+	*B, *C, *D, *F, *G or *H preceding ACQUIRE M [1]
+	*A, *B or *C following RELEASE M [1]
+	*F, *G or *H preceding ACQUIRE M [2]
+	*A, *B, *C, *E, *F or *G following RELEASE M [2]
 
 Note that the smp_mb__after_unlock_lock() is critically important
 here: Without it CPU 3 might see some of the above orderings.
@@ -1983,8 +1988,8 @@ Without smp_mb__after_unlock_lock(), the accesses are not guaranteed
 to be seen in order unless CPU 3 holds lock M.
 
 
-LOCKS VS I/O ACCESSES
----------------------
+ACQUIRES VS I/O ACCESSES
+------------------------
 
 Under certain circumstances (especially involving NUMA), I/O accesses within
 two spinlocked sections on two different CPUs may be seen as interleaved by the
@@ -2202,13 +2207,13 @@ explicit lock operations, described later).  These include:
 	/* when succeeds (returns 1) */
 	atomic_add_unless();		atomic_long_add_unless();
 
-These are used for such things as implementing LOCK-class and UNLOCK-class
+These are used for such things as implementing ACQUIRE-class and RELEASE-class
 operations and adjusting reference counters towards object destruction, and as
 such the implicit memory barrier effects are necessary.
 
 
 The following operations are potential problems as they do _not_ imply memory
-barriers, but might be used for implementing such things as UNLOCK-class
+barriers, but might be used for implementing such things as RELEASE-class
 operations:
 
 	atomic_set();
@@ -2250,7 +2255,7 @@ The following operations are special locking primitives:
 	clear_bit_unlock();
 	__clear_bit_unlock();
 
-These implement LOCK-class and UNLOCK-class operations. These should be used in
+These implement ACQUIRE-class and RELEASE-class operations. These should be used in
 preference to other operations when implementing locking primitives, because
 their implementations can be optimised on many architectures.
 
