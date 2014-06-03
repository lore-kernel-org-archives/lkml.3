Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaFCLfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:35:19 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41334 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFCLfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:35:13 -0400
Date: Tue, 3 Jun 2014 13:35:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.16
Message-ID: <20140603113505.GA23308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   # HEAD: e14505a8d50882ff3bdd4b791b14d90a0881fa4d Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The main RCU changes in this cycle were:

 - RCU Torture-test changes.

 - Variable-name renaming cleanup.

 - Update RCU documentation.

 - Miscellaneous fixes.

 - Patch to suppress RCU stall warnings while sysrq
   requests are being processed.

 Thanks,

	Ingo

------------------>
Andreea-Cristina Bernat (3):
      rcu: Add event tracing to dyntick_save_progress_counter().
      rcu: Consolidate kfree_call_rcu() to use rcu_state pointer
      rcu: Merge rcu_sched_force_quiescent_state() with rcu_force_quiescent_state()

Christoph Lameter (1):
      rcu: Replace __this_cpu_ptr() uses with raw_cpu_ptr()

Eric Dumazet (1):
      softirq: A single rcu_bh_qs() call per softirq set is enough

Himangi Saraogi (2):
      rcu: Protect uses of ->jiffies_stall with ACCESS_ONCE()
      rcu: Replace NR_CPUS with nr_cpu_ids

Iulia Manda (4):
      rcu: Remove unused rcu_data structure field
      rcu: Protect uses of jiffies_stall field with ACCESS_ONCE()
      rcu: Remove "extern" from function declaration in include/linux/rcupdate.h
      torture: Notice if an all-zero cpumask is passed inside a critical section

Liu Ping Fan (1):
      rcu: Fix incorrect notes for code

Paul E. McKenney (49):
      documentation: Update sysfs path for rcu_cpu_stall_suppress
      documentation: Record rcu_dereference() value mishandling
      documentation: Update API documentation
      rcu: Protect ->gp_flags accesses with ACCESS_ONCE()
      rcu: Print negatives for stall-warning counter wraparound
      rcu: Update cpu_needs_another_gp() for futures from non-NOCB CPUs
      rcu: Make callers awaken grace-period kthread
      rcu: Document RCU_INIT_POINTER()'s lack of ordering guarantees
      rcu: Bind RCU grace-period kthreads if NO_HZ_FULL
      rcu: Make large and small sysidle systems use same state machine
      rcutorture: Add forward-progress checking for writer
      torture: Remove obsolete builddir options
      torture: Add batch headers "--dryrun sched"
      torture: Make parse-rcutorture.sh less RCU-specific
      torture: Rename RCU_INITRD to TORTURE_INITRD
      torture: Intensify locking test
      torture: Allow variations of "defconfig" to be specified
      torture: Rename RCU_KMAKE_ARG to TORTURE_KMAKE_ARG
      torture: Rename RCU_BOOTARGS to TORTURE_BOOTARGS
      torture: Rename RCU_BUILDONLY to TORTURE_BUILDONLY
      torture: Rename RCU_QEMU_INTERACTIVE to TORTURE_QEMU_INTERACTIVE
      torture: Rename RCU_QEMU_MAC to TORTURE_QEMU_MAC
      torture: Rename RCU_QEMU_ARG to TORTURE_QEMU_ARG
      torture: Rename RCU_QEMU_CMD to TORTURE_QEMU_CMD
      torture: Make config-fragment filtering RCU-independent
      torture: Make "--dryrun script" output self-sufficient
      torture: Make "--dryrun script" use same environment as normal run
      rcutorture: Print negatives for SRCU counter wraparound
      torture: Include "Stopping" string to torture_kthread_stopping()
      torture: Report diagnostics from qemu
      torture: Increase stutter-end intensity
      torture: Permit multi-word qemu and boot arguments
      torture: Choose bzImage location based on architecture
      torture: Add tracing-enabled variant of TREE02
      torture: Dump ftrace buffer when the RCU grace period stalls
      rcutorture: Export RCU grace-period kthread wait state to rcutorture
      percpu: Fix raw_cpu_inc_return()
      sched,rcu: Make cond_resched() report RCU quiescent states
      rcutorture: Make rcu_torture_reader() use cond_resched()
      torture: Better summary diagnostics for build failures
      rcutorture: Check for rcu_torture_fqs creation errors
      torture: Use elapsed time to detect hangs
      rcutorture: Test RCU-sched primitives in TREE_PREEMPT_RCU kernels
      rcutorture:  Add tests for get_state_synchronize_rcu()
      rcutorture: Explicitly test synchronous grace-period primitives
      rcutorture: Note diffs from git commits
      rcutorture: Run rcu_torture_writer at normal priority
      locktorture: Remove reference to nonexistent Kconfig parameter
      torture: Check for multiple concurrent torture tests

Pranith Kumar (3):
      rcu: Remove duplicate resched_cpu() declaration
      torture: Remove __init from torture_init_begin/end
      torture: Remove unused definition

Rashika Kheria (1):
      rcutorture: Mark function as static in kernel/rcu/torture.c

Rik van Riel (1):
      rcu: Provide API to suppress stall warnings while sysrc runs

Thomas Gleixner (1):
      rcutorture: Add missing destroy_timer_on_stack()

Uma Sharma (1):
      rcu: Variable name changed in tree_plugin.h and used in tree.c


 Documentation/RCU/00-INDEX                         |   2 +
 Documentation/RCU/checklist.txt                    |  12 +-
 Documentation/RCU/rcu_dereference.txt              | 371 +++++++++++++++++++++
 Documentation/RCU/stallwarn.txt                    |   2 +-
 Documentation/RCU/whatisRCU.txt                    |  55 ++-
 include/linux/percpu.h                             |   2 +-
 include/linux/rcupdate.h                           |  72 +++-
 include/linux/rcutiny.h                            |   4 +
 include/linux/rcutree.h                            |   1 +
 include/linux/torture.h                            |   8 +-
 kernel/locking/locktorture.c                       |  10 +-
 kernel/rcu/rcutorture.c                            | 217 +++++++++---
 kernel/rcu/tiny_plugin.h                           |   8 +-
 kernel/rcu/tree.c                                  | 309 ++++++++++++-----
 kernel/rcu/tree.h                                  |  11 +-
 kernel/rcu/tree_plugin.h                           | 136 ++------
 kernel/rcu/update.c                                |  30 ++
 kernel/sched/core.c                                |   7 +-
 kernel/softirq.c                                   |   4 +-
 kernel/torture.c                                   |  40 ++-
 .../testing/selftests/rcutorture/bin/configinit.sh |   2 +-
 .../testing/selftests/rcutorture/bin/functions.sh  |  48 ++-
 .../testing/selftests/rcutorture/bin/kvm-build.sh  |   6 +-
 .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck.sh        |  24 +-
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |  47 ++-
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 142 ++++----
 .../bin/{parse-rcutorture.sh => parse-torture.sh}  |  22 +-
 .../selftests/rcutorture/configs/rcu/TREE02-T      |  25 ++
 .../selftests/rcutorture/configs/rcu/TREE08.boot   |   1 +
 31 files changed, 1210 insertions(+), 412 deletions(-)
 create mode 100644 Documentation/RCU/rcu_dereference.txt
 rename tools/testing/selftests/rcutorture/bin/{parse-rcutorture.sh => parse-torture.sh} (79%)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index fa57139..f773a26 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -12,6 +12,8 @@ lockdep-splat.txt
 	- RCU Lockdep splats explained.
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
+rcu_dereference.txt
+	- Proper care and feeding of return values from rcu_dereference()
 rcubarrier.txt
 	- RCU and Unloadable Modules
 rculist_nulls.txt
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 9d10d1d..8779471 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -114,12 +114,16 @@ over a rather long period of time, but improvements are always welcome!
 			http://www.openvms.compaq.com/wizard/wiz_2637.html
 
 		The rcu_dereference() primitive is also an excellent
-		documentation aid, letting the person reading the code
-		know exactly which pointers are protected by RCU.
+		documentation aid, letting the person reading the
+		code know exactly which pointers are protected by RCU.
 		Please note that compilers can also reorder code, and
 		they are becoming increasingly aggressive about doing
-		just that.  The rcu_dereference() primitive therefore
-		also prevents destructive compiler optimizations.
+		just that.  The rcu_dereference() primitive therefore also
+		prevents destructive compiler optimizations.  However,
+		with a bit of devious creativity, it is possible to
+		mishandle the return value from rcu_dereference().
+		Please see rcu_dereference.txt in this directory for
+		more information.
 
 		The rcu_dereference() primitive is used by the
 		various "_rcu()" list-traversal primitives, such
diff --git a/Documentation/RCU/rcu_dereference.txt b/Documentation/RCU/rcu_dereference.txt
new file mode 100644
index 0000000..ceb05da
--- /dev/null
+++ b/Documentation/RCU/rcu_dereference.txt
@@ -0,0 +1,371 @@
+PROPER CARE AND FEEDING OF RETURN VALUES FROM rcu_dereference()
+
+Most of the time, you can use values from rcu_dereference() or one of
+the similar primitives without worries.  Dereferencing (prefix "*"),
+field selection ("->"), assignment ("="), address-of ("&"), addition and
+subtraction of constants, and casts all work quite naturally and safely.
+
+It is nevertheless possible to get into trouble with other operations.
+Follow these rules to keep your RCU code working properly:
+
+o	You must use one of the rcu_dereference() family of primitives
+	to load an RCU-protected pointer, otherwise CONFIG_PROVE_RCU
+	will complain.  Worse yet, your code can see random memory-corruption
+	bugs due to games that compilers and DEC Alpha can play.
+	Without one of the rcu_dereference() primitives, compilers
+	can reload the value, and won't your code have fun with two
+	different values for a single pointer!  Without rcu_dereference(),
+	DEC Alpha can load a pointer, dereference that pointer, and
+	return data preceding initialization that preceded the store of
+	the pointer.
+
+	In addition, the volatile cast in rcu_dereference() prevents the
+	compiler from deducing the resulting pointer value.  Please see
+	the section entitled "EXAMPLE WHERE THE COMPILER KNOWS TOO MUCH"
+	for an example where the compiler can in fact deduce the exact
+	value of the pointer, and thus cause misordering.
+
+o	Do not use single-element RCU-protected arrays.  The compiler
+	is within its right to assume that the value of an index into
+	such an array must necessarily evaluate to zero.  The compiler
+	could then substitute the constant zero for the computation, so
+	that the array index no longer depended on the value returned
+	by rcu_dereference().  If the array index no longer depends
+	on rcu_dereference(), then both the compiler and the CPU
+	are within their rights to order the array access before the
+	rcu_dereference(), which can cause the array access to return
+	garbage.
+
+o	Avoid cancellation when using the "+" and "-" infix arithmetic
+	operators.  For example, for a given variable "x", avoid
+	"(x-x)".  There are similar arithmetic pitfalls from other
+	arithmetic operatiors, such as "(x*0)", "(x/(x+1))" or "(x%1)".
+	The compiler is within its rights to substitute zero for all of
+	these expressions, so that subsequent accesses no longer depend
+	on the rcu_dereference(), again possibly resulting in bugs due
+	to misordering.
+
+	Of course, if "p" is a pointer from rcu_dereference(), and "a"
+	and "b" are integers that happen to be equal, the expression
+	"p+a-b" is safe because its value still necessarily depends on
+	the rcu_dereference(), thus maintaining proper ordering.
+
+o	Avoid all-zero operands to the bitwise "&" operator, and
+	similarly avoid all-ones operands to the bitwise "|" operator.
+	If the compiler is able to deduce the value of such operands,
+	it is within its rights to substitute the corresponding constant
+	for the bitwise operation.  Once again, this causes subsequent
+	accesses to no longer depend on the rcu_dereference(), causing
+	bugs due to misordering.
+
+	Please note that single-bit operands to bitwise "&" can also
+	be dangerous.  At this point, the compiler knows that the
+	resulting value can only take on one of two possible values.
+	Therefore, a very small amount of additional information will
+	allow the compiler to deduce the exact value, which again can
+	result in misordering.
+
+o	If you are using RCU to protect JITed functions, so that the
+	"()" function-invocation operator is applied to a value obtained
+	(directly or indirectly) from rcu_dereference(), you may need to
+	interact directly with the hardware to flush instruction caches.
+	This issue arises on some systems when a newly JITed function is
+	using the same memory that was used by an earlier JITed function.
+
+o	Do not use the results from the boolean "&&" and "||" when
+	dereferencing.	For example, the following (rather improbable)
+	code is buggy:
+
+		int a[2];
+		int index;
+		int force_zero_index = 1;
+
+		...
+
+		r1 = rcu_dereference(i1)
+		r2 = a[r1 && force_zero_index];  /* BUGGY!!! */
+
+	The reason this is buggy is that "&&" and "||" are often compiled
+	using branches.  While weak-memory machines such as ARM or PowerPC
+	do order stores after such branches, they can speculate loads,
+	which can result in misordering bugs.
+
+o	Do not use the results from relational operators ("==", "!=",
+	">", ">=", "<", or "<=") when dereferencing.  For example,
+	the following (quite strange) code is buggy:
+
+		int a[2];
+		int index;
+		int flip_index = 0;
+
+		...
+
+		r1 = rcu_dereference(i1)
+		r2 = a[r1 != flip_index];  /* BUGGY!!! */
+
+	As before, the reason this is buggy is that relational operators
+	are often compiled using branches.  And as before, although
+	weak-memory machines such as ARM or PowerPC do order stores
+	after such branches, but can speculate loads, which can again
+	result in misordering bugs.
+
+o	Be very careful about comparing pointers obtained from
+	rcu_dereference() against non-NULL values.  As Linus Torvalds
+	explained, if the two pointers are equal, the compiler could
+	substitute the pointer you are comparing against for the pointer
+	obtained from rcu_dereference().  For example:
+
+		p = rcu_dereference(gp);
+		if (p == &default_struct)
+			do_default(p->a);
+
+	Because the compiler now knows that the value of "p" is exactly
+	the address of the variable "default_struct", it is free to
+	transform this code into the following:
+
+		p = rcu_dereference(gp);
+		if (p == &default_struct)
+			do_default(default_struct.a);
+
+	On ARM and Power hardware, the load from "default_struct.a"
+	can now be speculated, such that it might happen before the
+	rcu_dereference().  This could result in bugs due to misordering.
+
+	However, comparisons are OK in the following cases:
+
+	o	The comparison was against the NULL pointer.  If the
+		compiler knows that the pointer is NULL, you had better
+		not be dereferencing it anyway.  If the comparison is
+		non-equal, the compiler is none the wiser.  Therefore,
+		it is safe to compare pointers from rcu_dereference()
+		against NULL pointers.
+
+	o	The pointer is never dereferenced after being compared.
+		Since there are no subsequent dereferences, the compiler
+		cannot use anything it learned from the comparison
+		to reorder the non-existent subsequent dereferences.
+		This sort of comparison occurs frequently when scanning
+		RCU-protected circular linked lists.
+
+	o	The comparison is against a pointer that references memory
+		that was initialized "a long time ago."  The reason
+		this is safe is that even if misordering occurs, the
+		misordering will not affect the accesses that follow
+		the comparison.  So exactly how long ago is "a long
+		time ago"?  Here are some possibilities:
+
+		o	Compile time.
+
+		o	Boot time.
+
+		o	Module-init time for module code.
+
+		o	Prior to kthread creation for kthread code.
+
+		o	During some prior acquisition of the lock that
+			we now hold.
+
+		o	Before mod_timer() time for a timer handler.
+
+		There are many other possibilities involving the Linux
+		kernel's wide array of primitives that cause code to
+		be invoked at a later time.
+
+	o	The pointer being compared against also came from
+		rcu_dereference().  In this case, both pointers depend
+		on one rcu_dereference() or another, so you get proper
+		ordering either way.
+
+		That said, this situation can make certain RCU usage
+		bugs more likely to happen.  Which can be a good thing,
+		at least if they happen during testing.  An example
+		of such an RCU usage bug is shown in the section titled
+		"EXAMPLE OF AMPLIFIED RCU-USAGE BUG".
+
+	o	All of the accesses following the comparison are stores,
+		so that a control dependency preserves the needed ordering.
+		That said, it is easy to get control dependencies wrong.
+		Please see the "CONTROL DEPENDENCIES" section of
+		Documentation/memory-barriers.txt for more details.
+
+	o	The pointers are not equal -and- the compiler does
+		not have enough information to deduce the value of the
+		pointer.  Note that the volatile cast in rcu_dereference()
+		will normally prevent the compiler from knowing too much.
+
+o	Disable any value-speculation optimizations that your compiler
+	might provide, especially if you are making use of feedback-based
+	optimizations that take data collected from prior runs.  Such
+	value-speculation optimizations reorder operations by design.
+
+	There is one exception to this rule:  Value-speculation
+	optimizations that leverage the branch-prediction hardware are
+	safe on strongly ordered systems (such as x86), but not on weakly
+	ordered systems (such as ARM or Power).  Choose your compiler
+	command-line options wisely!
+
+
+EXAMPLE OF AMPLIFIED RCU-USAGE BUG
+
+Because updaters can run concurrently with RCU readers, RCU readers can
+see stale and/or inconsistent values.  If RCU readers need fresh or
+consistent values, which they sometimes do, they need to take proper
+precautions.  To see this, consider the following code fragment:
+
+	struct foo {
+		int a;
+		int b;
+		int c;
+	};
+	struct foo *gp1;
+	struct foo *gp2;
+
+	void updater(void)
+	{
+		struct foo *p;
+
+		p = kmalloc(...);
+		if (p == NULL)
+			deal_with_it();
+		p->a = 42;  /* Each field in its own cache line. */
+		p->b = 43;
+		p->c = 44;
+		rcu_assign_pointer(gp1, p);
+		p->b = 143;
+		p->c = 144;
+		rcu_assign_pointer(gp2, p);
+	}
+
+	void reader(void)
+	{
+		struct foo *p;
+		struct foo *q;
+		int r1, r2;
+
+		p = rcu_dereference(gp2);
+		if (p == NULL)
+			return;
+		r1 = p->b;  /* Guaranteed to get 143. */
+		q = rcu_dereference(gp1);  /* Guaranteed non-NULL. */
+		if (p == q) {
+			/* The compiler decides that q->c is same as p->c. */
+			r2 = p->c; /* Could get 44 on weakly order system. */
+		}
+		do_something_with(r1, r2);
+	}
+
+You might be surprised that the outcome (r1 == 143 && r2 == 44) is possible,
+but you should not be.  After all, the updater might have been invoked
+a second time between the time reader() loaded into "r1" and the time
+that it loaded into "r2".  The fact that this same result can occur due
+to some reordering from the compiler and CPUs is beside the point.
+
+But suppose that the reader needs a consistent view?
+
+Then one approach is to use locking, for example, as follows:
+
+	struct foo {
+		int a;
+		int b;
+		int c;
+		spinlock_t lock;
+	};
+	struct foo *gp1;
+	struct foo *gp2;
+
+	void updater(void)
+	{
+		struct foo *p;
+
+		p = kmalloc(...);
+		if (p == NULL)
+			deal_with_it();
+		spin_lock(&p->lock);
+		p->a = 42;  /* Each field in its own cache line. */
+		p->b = 43;
+		p->c = 44;
+		spin_unlock(&p->lock);
+		rcu_assign_pointer(gp1, p);
+		spin_lock(&p->lock);
+		p->b = 143;
+		p->c = 144;
+		spin_unlock(&p->lock);
+		rcu_assign_pointer(gp2, p);
+	}
+
+	void reader(void)
+	{
+		struct foo *p;
+		struct foo *q;
+		int r1, r2;
+
+		p = rcu_dereference(gp2);
+		if (p == NULL)
+			return;
+		spin_lock(&p->lock);
+		r1 = p->b;  /* Guaranteed to get 143. */
+		q = rcu_dereference(gp1);  /* Guaranteed non-NULL. */
+		if (p == q) {
+			/* The compiler decides that q->c is same as p->c. */
+			r2 = p->c; /* Locking guarantees r2 == 144. */
+		}
+		spin_unlock(&p->lock);
+		do_something_with(r1, r2);
+	}
+
+As always, use the right tool for the job!
+
+
+EXAMPLE WHERE THE COMPILER KNOWS TOO MUCH
+
+If a pointer obtained from rcu_dereference() compares not-equal to some
+other pointer, the compiler normally has no clue what the value of the
+first pointer might be.  This lack of knowledge prevents the compiler
+from carrying out optimizations that otherwise might destroy the ordering
+guarantees that RCU depends on.  And the volatile cast in rcu_dereference()
+should prevent the compiler from guessing the value.
+
+But without rcu_dereference(), the compiler knows more than you might
+expect.  Consider the following code fragment:
+
+	struct foo {
+		int a;
+		int b;
+	};
+	static struct foo variable1;
+	static struct foo variable2;
+	static struct foo *gp = &variable1;
+
+	void updater(void)
+	{
+		initialize_foo(&variable2);
+		rcu_assign_pointer(gp, &variable2);
+		/*
+		 * The above is the only store to gp in this translation unit,
+		 * and the address of gp is not exported in any way.
+		 */
+	}
+
+	int reader(void)
+	{
+		struct foo *p;
+
+		p = gp;
+		barrier();
+		if (p == &variable1)
+			return p->a; /* Must be variable1.a. */
+		else
+			return p->b; /* Must be variable2.b. */
+	}
+
+Because the compiler can see all stores to "gp", it knows that the only
+possible values of "gp" are "variable1" on the one hand and "variable2"
+on the other.  The comparison in reader() therefore tells the compiler
+the exact value of "p" even in the not-equals case.  This allows the
+compiler to make the return values independent of the load from "gp",
+in turn destroying the ordering between this load and the loads of the
+return values.  This can result in "p->b" returning pre-initialization
+garbage values.
+
+In short, rcu_dereference() is -not- optional when you are going to
+dereference the resulting pointer.
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 6f3a005..68fe3ad 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -24,7 +24,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	timing of the next warning for the current stall.
 
 	Stall-warning messages may be enabled and disabled completely via
-	/sys/module/rcutree/parameters/rcu_cpu_stall_suppress.
+	/sys/module/rcupdate/parameters/rcu_cpu_stall_suppress.
 
 CONFIG_RCU_CPU_STALL_VERBOSE
 
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 0f0fb7c..49b8551 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -326,11 +326,11 @@ used as follows:
 a.	synchronize_rcu()	rcu_read_lock() / rcu_read_unlock()
 	call_rcu()		rcu_dereference()
 
-b.	call_rcu_bh()		rcu_read_lock_bh() / rcu_read_unlock_bh()
-				rcu_dereference_bh()
+b.	synchronize_rcu_bh()	rcu_read_lock_bh() / rcu_read_unlock_bh()
+	call_rcu_bh()		rcu_dereference_bh()
 
 c.	synchronize_sched()	rcu_read_lock_sched() / rcu_read_unlock_sched()
-				preempt_disable() / preempt_enable()
+	call_rcu_sched()	preempt_disable() / preempt_enable()
 				local_irq_save() / local_irq_restore()
 				hardirq enter / hardirq exit
 				NMI enter / NMI exit
@@ -794,10 +794,22 @@ in docbook.  Here is the list, by category.
 
 RCU list traversal:
 
+	list_entry_rcu
+	list_first_entry_rcu
+	list_next_rcu
 	list_for_each_entry_rcu
+	list_for_each_entry_continue_rcu
+	hlist_first_rcu
+	hlist_next_rcu
+	hlist_pprev_rcu
 	hlist_for_each_entry_rcu
+	hlist_for_each_entry_rcu_bh
+	hlist_for_each_entry_continue_rcu
+	hlist_for_each_entry_continue_rcu_bh
+	hlist_nulls_first_rcu
 	hlist_nulls_for_each_entry_rcu
-	list_for_each_entry_continue_rcu
+	hlist_bl_first_rcu
+	hlist_bl_for_each_entry_rcu
 
 RCU pointer/list update:
 
@@ -806,28 +818,38 @@ RCU pointer/list update:
 	list_add_tail_rcu
 	list_del_rcu
 	list_replace_rcu
-	hlist_del_rcu
 	hlist_add_after_rcu
 	hlist_add_before_rcu
 	hlist_add_head_rcu
+	hlist_del_rcu
+	hlist_del_init_rcu
 	hlist_replace_rcu
 	list_splice_init_rcu()
+	hlist_nulls_del_init_rcu
+	hlist_nulls_del_rcu
+	hlist_nulls_add_head_rcu
+	hlist_bl_add_head_rcu
+	hlist_bl_del_init_rcu
+	hlist_bl_del_rcu
+	hlist_bl_set_first_rcu
 
 RCU:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock		synchronize_net		rcu_barrier
 	rcu_read_unlock		synchronize_rcu
 	rcu_dereference		synchronize_rcu_expedited
-				call_rcu
-				kfree_rcu
-
+	rcu_read_lock_held	call_rcu
+	rcu_dereference_check	kfree_rcu
+	rcu_dereference_protected
 
 bh:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
 	rcu_read_unlock_bh	synchronize_rcu_bh
 	rcu_dereference_bh	synchronize_rcu_bh_expedited
-
+	rcu_dereference_bh_check
+	rcu_dereference_bh_protected
+	rcu_read_lock_bh_held
 
 sched:	Critical sections	Grace period		Barrier
 
@@ -835,7 +857,12 @@ sched:	Critical sections	Grace period		Barrier
 	rcu_read_unlock_sched	call_rcu_sched
 	[preempt_disable]	synchronize_sched_expedited
 	[and friends]
+	rcu_read_lock_sched_notrace
+	rcu_read_unlock_sched_notrace
 	rcu_dereference_sched
+	rcu_dereference_sched_check
+	rcu_dereference_sched_protected
+	rcu_read_lock_sched_held
 
 
 SRCU:	Critical sections	Grace period		Barrier
@@ -843,6 +870,8 @@ SRCU:	Critical sections	Grace period		Barrier
 	srcu_read_lock		synchronize_srcu	srcu_barrier
 	srcu_read_unlock	call_srcu
 	srcu_dereference	synchronize_srcu_expedited
+	srcu_dereference_check
+	srcu_read_lock_held
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
@@ -850,9 +879,13 @@ SRCU:	Initialization/cleanup
 
 All:  lockdep-checked RCU-protected pointer access
 
-	rcu_dereference_check
-	rcu_dereference_protected
+	rcu_access_index
 	rcu_access_pointer
+	rcu_dereference_index_check
+	rcu_dereference_raw
+	rcu_lockdep_assert
+	rcu_sleep_check
+	RCU_NONIDLE
 
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e7a0b95..495c654 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -639,7 +639,7 @@ do {									\
 #  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
 # define raw_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(raw_add_return_, pcp, val)
+	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
 #endif
 
 #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..5a75d19 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -44,6 +44,7 @@
 #include <linux/debugobjects.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/percpu.h>
 #include <asm/barrier.h>
 
 extern int rcu_expedited; /* for sysctl */
@@ -51,7 +52,17 @@ extern int rcu_expedited; /* for sysctl */
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+enum rcutorture_type {
+	RCU_FLAVOR,
+	RCU_BH_FLAVOR,
+	RCU_SCHED_FLAVOR,
+	SRCU_FLAVOR,
+	INVALID_RCU_FLAVOR
+};
+
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
+			    unsigned long *gpnum, unsigned long *completed);
 void rcutorture_record_test_transition(void);
 void rcutorture_record_progress(unsigned long vernum);
 void do_trace_rcu_torture_read(const char *rcutorturename,
@@ -60,6 +71,15 @@ void do_trace_rcu_torture_read(const char *rcutorturename,
 			       unsigned long c_old,
 			       unsigned long c);
 #else
+static inline void rcutorture_get_gp_data(enum rcutorture_type test_type,
+					  int *flags,
+					  unsigned long *gpnum,
+					  unsigned long *completed)
+{
+	*flags = 0;
+	*gpnum = 0;
+	*completed = 0;
+}
 static inline void rcutorture_record_test_transition(void)
 {
 }
@@ -228,6 +248,18 @@ void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
 
+#ifdef CONFIG_RCU_STALL_COMMON
+void rcu_sysrq_start(void);
+void rcu_sysrq_end(void);
+#else /* #ifdef CONFIG_RCU_STALL_COMMON */
+static inline void rcu_sysrq_start(void)
+{
+}
+static inline void rcu_sysrq_end(void)
+{
+}
+#endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
+
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
 void rcu_user_exit(void);
@@ -268,6 +300,41 @@ bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
 
 /*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
+DECLARE_PER_CPU(int, rcu_cond_resched_count);
+void rcu_resched(void);
+
+/*
+ * Is it time to report RCU quiescent states?
+ *
+ * Note unsynchronized access to rcu_cond_resched_count.  Yes, we might
+ * increment some random CPU's count, and possibly also load the result from
+ * yet another CPU's count.  We might even clobber some other CPU's attempt
+ * to zero its counter.  This is all OK because the goal is not precision,
+ * but rather reasonable amortization of rcu_note_context_switch() overhead
+ * and extremely high probability of avoiding RCU CPU stall warnings.
+ * Note that this function has to be preempted in just the wrong place,
+ * many thousands of times in a row, for anything bad to happen.
+ */
+static inline bool rcu_should_resched(void)
+{
+	return raw_cpu_inc_return(rcu_cond_resched_count) >=
+	       RCU_COND_RESCHED_LIM;
+}
+
+/*
+ * Report quiscent states to RCU if it is time to do so.
+ */
+static inline void rcu_cond_resched(void)
+{
+	if (unlikely(rcu_should_resched()))
+		rcu_resched();
+}
+
+/*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
  */
@@ -328,7 +395,7 @@ extern struct lockdep_map rcu_lock_map;
 extern struct lockdep_map rcu_bh_lock_map;
 extern struct lockdep_map rcu_sched_lock_map;
 extern struct lockdep_map rcu_callback_map;
-extern int debug_lockdep_rcu_enabled(void);
+int debug_lockdep_rcu_enabled(void);
 
 /**
  * rcu_read_lock_held() - might we be in RCU read-side critical section?
@@ -949,6 +1016,9 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * pointers, but you must use rcu_assign_pointer() to initialize the
  * external-to-structure pointer -after- you have completely initialized
  * the reader-accessible portions of the linked structure.
+ *
+ * Note that unlike rcu_assign_pointer(), RCU_INIT_POINTER() provides no
+ * ordering guarantees for either the CPU or the compiler.
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 425c659..d40a6a4 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -119,6 +119,10 @@ static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
+static inline void show_rcu_gp_kthreads(void)
+{
+}
+
 static inline void rcu_cpu_stall_reset(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a59ca05..3e2f5d4 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -84,6 +84,7 @@ extern unsigned long rcutorture_vernum;
 long rcu_batches_completed(void);
 long rcu_batches_completed_bh(void);
 long rcu_batches_completed_sched(void);
+void show_rcu_gp_kthreads(void);
 
 void rcu_force_quiescent_state(void);
 void rcu_bh_force_quiescent_state(void);
diff --git a/include/linux/torture.h b/include/linux/torture.h
index b2e2b46..5ca58fc 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -49,12 +49,6 @@
 #define VERBOSE_TOROUT_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! %s\n", torture_type, s); } while (0)
 
-/* Definitions for a non-string torture-test module parameter. */
-#define torture_parm(type, name, init, msg) \
-	static type name = init; \
-	module_param(name, type, 0444); \
-	MODULE_PARM_DESC(name, msg);
-
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
 char *torture_onoff_stats(char *page);
@@ -81,7 +75,7 @@ void stutter_wait(const char *title);
 int torture_stutter_init(int s);
 
 /* Initialization and cleanup. */
-void torture_init_begin(char *ttype, bool v, int *runnable);
+bool torture_init_begin(char *ttype, bool v, int *runnable);
 void torture_init_end(void);
 bool torture_cleanup(void);
 bool torture_must_stop(void);
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index f26b1a1..dbafeac 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -82,14 +82,14 @@ struct lock_writer_stress_stats {
 };
 static struct lock_writer_stress_stats *lwsa;
 
-#if defined(MODULE) || defined(CONFIG_LOCK_TORTURE_TEST_RUNNABLE)
+#if defined(MODULE)
 #define LOCKTORTURE_RUNNABLE_INIT 1
 #else
 #define LOCKTORTURE_RUNNABLE_INIT 0
 #endif
 int locktorture_runnable = LOCKTORTURE_RUNNABLE_INIT;
 module_param(locktorture_runnable, int, 0444);
-MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at boot");
+MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at module init");
 
 /* Forward reference. */
 static void lock_torture_cleanup(void);
@@ -219,7 +219,8 @@ static int lock_torture_writer(void *arg)
 	set_user_nice(current, 19);
 
 	do {
-		schedule_timeout_uninterruptible(1);
+		if ((torture_random(&rand) & 0xfffff) == 0)
+			schedule_timeout_uninterruptible(1);
 		cur_ops->writelock();
 		if (WARN_ON_ONCE(lock_is_write_held))
 			lwsp->n_write_lock_fail++;
@@ -354,7 +355,8 @@ static int __init lock_torture_init(void)
 		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
 	};
 
-	torture_init_begin(torture_type, verbose, &locktorture_runnable);
+	if (!torture_init_begin(torture_type, verbose, &locktorture_runnable))
+		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index bd30bc6..7fa34f8 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -58,9 +58,11 @@ torture_param(int, fqs_duration, 0,
 	      "Duration of fqs bursts (us), 0 to disable");
 torture_param(int, fqs_holdoff, 0, "Holdoff time within fqs bursts (us)");
 torture_param(int, fqs_stutter, 3, "Wait time between fqs bursts (s)");
+torture_param(bool, gp_cond, false, "Use conditional/async GP wait primitives");
 torture_param(bool, gp_exp, false, "Use expedited GP wait primitives");
 torture_param(bool, gp_normal, false,
 	     "Use normal (non-expedited) GP wait primitives");
+torture_param(bool, gp_sync, false, "Use synchronous GP wait primitives");
 torture_param(int, irqreader, 1, "Allow RCU readers from irq handlers");
 torture_param(int, n_barrier_cbs, 0,
 	     "# of callbacks/kthreads for barrier testing");
@@ -138,6 +140,18 @@ static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
 
+static int rcu_torture_writer_state;
+#define RTWS_FIXED_DELAY	0
+#define RTWS_DELAY		1
+#define RTWS_REPLACE		2
+#define RTWS_DEF_FREE		3
+#define RTWS_EXP_SYNC		4
+#define RTWS_COND_GET		5
+#define RTWS_COND_SYNC		6
+#define RTWS_SYNC		7
+#define RTWS_STUTTER		8
+#define RTWS_STOPPING		9
+
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
 #else
@@ -214,6 +228,7 @@ rcu_torture_free(struct rcu_torture *p)
  */
 
 struct rcu_torture_ops {
+	int ttype;
 	void (*init)(void);
 	int (*readlock)(void);
 	void (*read_delay)(struct torture_random_state *rrsp);
@@ -222,6 +237,8 @@ struct rcu_torture_ops {
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*exp_sync)(void);
+	unsigned long (*get_state)(void);
+	void (*cond_sync)(unsigned long oldstate);
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
@@ -273,10 +290,48 @@ static int rcu_torture_completed(void)
 	return rcu_batches_completed();
 }
 
+/*
+ * Update callback in the pipe.  This should be invoked after a grace period.
+ */
+static bool
+rcu_torture_pipe_update_one(struct rcu_torture *rp)
+{
+	int i;
+
+	i = rp->rtort_pipe_count;
+	if (i > RCU_TORTURE_PIPE_LEN)
+		i = RCU_TORTURE_PIPE_LEN;
+	atomic_inc(&rcu_torture_wcount[i]);
+	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
+		rp->rtort_mbtest = 0;
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Update all callbacks in the pipe.  Suitable for synchronous grace-period
+ * primitives.
+ */
+static void
+rcu_torture_pipe_update(struct rcu_torture *old_rp)
+{
+	struct rcu_torture *rp;
+	struct rcu_torture *rp1;
+
+	if (old_rp)
+		list_add(&old_rp->rtort_free, &rcu_torture_removed);
+	list_for_each_entry_safe(rp, rp1, &rcu_torture_removed, rtort_free) {
+		if (rcu_torture_pipe_update_one(rp)) {
+			list_del(&rp->rtort_free);
+			rcu_torture_free(rp);
+		}
+	}
+}
+
 static void
 rcu_torture_cb(struct rcu_head *p)
 {
-	int i;
 	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
 	if (torture_must_stop_irq()) {
@@ -284,16 +339,10 @@ rcu_torture_cb(struct rcu_head *p)
 		/* The next initialization will pick up the pieces. */
 		return;
 	}
-	i = rp->rtort_pipe_count;
-	if (i > RCU_TORTURE_PIPE_LEN)
-		i = RCU_TORTURE_PIPE_LEN;
-	atomic_inc(&rcu_torture_wcount[i]);
-	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
-		rp->rtort_mbtest = 0;
+	if (rcu_torture_pipe_update_one(rp))
 		rcu_torture_free(rp);
-	} else {
+	else
 		cur_ops->deferred_free(rp);
-	}
 }
 
 static int rcu_no_completed(void)
@@ -312,6 +361,7 @@ static void rcu_sync_torture_init(void)
 }
 
 static struct rcu_torture_ops rcu_ops = {
+	.ttype		= RCU_FLAVOR,
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
@@ -320,6 +370,8 @@ static struct rcu_torture_ops rcu_ops = {
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.exp_sync	= synchronize_rcu_expedited,
+	.get_state	= get_state_synchronize_rcu,
+	.cond_sync	= cond_synchronize_rcu,
 	.call		= call_rcu,
 	.cb_barrier	= rcu_barrier,
 	.fqs		= rcu_force_quiescent_state,
@@ -355,6 +407,7 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
+	.ttype		= RCU_BH_FLAVOR,
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
@@ -397,6 +450,7 @@ call_rcu_busted(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 
 static struct rcu_torture_ops rcu_busted_ops = {
+	.ttype		= INVALID_RCU_FLAVOR,
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
@@ -479,9 +533,11 @@ static void srcu_torture_stats(char *page)
 	page += sprintf(page, "%s%s per-CPU(idx=%d):",
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
-		page += sprintf(page, " %d(%lu,%lu)", cpu,
-			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
-			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
+		long c0, c1;
+
+		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
+		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
+		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
 	}
 	sprintf(page, "\n");
 }
@@ -492,6 +548,7 @@ static void srcu_torture_synchronize_expedited(void)
 }
 
 static struct rcu_torture_ops srcu_ops = {
+	.ttype		= SRCU_FLAVOR,
 	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
@@ -527,6 +584,7 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops sched_ops = {
+	.ttype		= RCU_SCHED_FLAVOR,
 	.init		= rcu_sync_torture_init,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
@@ -688,23 +746,59 @@ rcu_torture_fqs(void *arg)
 static int
 rcu_torture_writer(void *arg)
 {
-	bool exp;
+	unsigned long gp_snap;
+	bool gp_cond1 = gp_cond, gp_exp1 = gp_exp, gp_normal1 = gp_normal;
+	bool gp_sync1 = gp_sync;
 	int i;
 	struct rcu_torture *rp;
-	struct rcu_torture *rp1;
 	struct rcu_torture *old_rp;
 	static DEFINE_TORTURE_RANDOM(rand);
+	int synctype[] = { RTWS_DEF_FREE, RTWS_EXP_SYNC,
+			   RTWS_COND_GET, RTWS_SYNC };
+	int nsynctypes = 0;
 
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
-	set_user_nice(current, MAX_NICE);
+
+	/* Initialize synctype[] array.  If none set, take default. */
+	if (!gp_cond1 && !gp_exp1 && !gp_normal1 && !gp_sync)
+		gp_cond1 = gp_exp1 = gp_normal1 = gp_sync1 = true;
+	if (gp_cond1 && cur_ops->get_state && cur_ops->cond_sync)
+		synctype[nsynctypes++] = RTWS_COND_GET;
+	else if (gp_cond && (!cur_ops->get_state || !cur_ops->cond_sync))
+		pr_alert("rcu_torture_writer: gp_cond without primitives.\n");
+	if (gp_exp1 && cur_ops->exp_sync)
+		synctype[nsynctypes++] = RTWS_EXP_SYNC;
+	else if (gp_exp && !cur_ops->exp_sync)
+		pr_alert("rcu_torture_writer: gp_exp without primitives.\n");
+	if (gp_normal1 && cur_ops->deferred_free)
+		synctype[nsynctypes++] = RTWS_DEF_FREE;
+	else if (gp_normal && !cur_ops->deferred_free)
+		pr_alert("rcu_torture_writer: gp_normal without primitives.\n");
+	if (gp_sync1 && cur_ops->sync)
+		synctype[nsynctypes++] = RTWS_SYNC;
+	else if (gp_sync && !cur_ops->sync)
+		pr_alert("rcu_torture_writer: gp_sync without primitives.\n");
+	if (WARN_ONCE(nsynctypes == 0,
+		      "rcu_torture_writer: No update-side primitives.\n")) {
+		/*
+		 * No updates primitives, so don't try updating.
+		 * The resulting test won't be testing much, hence the
+		 * above WARN_ONCE().
+		 */
+		rcu_torture_writer_state = RTWS_STOPPING;
+		torture_kthread_stopping("rcu_torture_writer");
+	}
 
 	do {
+		rcu_torture_writer_state = RTWS_FIXED_DELAY;
 		schedule_timeout_uninterruptible(1);
 		rp = rcu_torture_alloc();
 		if (rp == NULL)
 			continue;
 		rp->rtort_pipe_count = 0;
+		rcu_torture_writer_state = RTWS_DELAY;
 		udelay(torture_random(&rand) & 0x3ff);
+		rcu_torture_writer_state = RTWS_REPLACE;
 		old_rp = rcu_dereference_check(rcu_torture_current,
 					       current == writer_task);
 		rp->rtort_mbtest = 1;
@@ -716,35 +810,42 @@ rcu_torture_writer(void *arg)
 				i = RCU_TORTURE_PIPE_LEN;
 			atomic_inc(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
-			if (gp_normal == gp_exp)
-				exp = !!(torture_random(&rand) & 0x80);
-			else
-				exp = gp_exp;
-			if (!exp) {
+			switch (synctype[torture_random(&rand) % nsynctypes]) {
+			case RTWS_DEF_FREE:
+				rcu_torture_writer_state = RTWS_DEF_FREE;
 				cur_ops->deferred_free(old_rp);
-			} else {
+				break;
+			case RTWS_EXP_SYNC:
+				rcu_torture_writer_state = RTWS_EXP_SYNC;
 				cur_ops->exp_sync();
-				list_add(&old_rp->rtort_free,
-					 &rcu_torture_removed);
-				list_for_each_entry_safe(rp, rp1,
-							 &rcu_torture_removed,
-							 rtort_free) {
-					i = rp->rtort_pipe_count;
-					if (i > RCU_TORTURE_PIPE_LEN)
-						i = RCU_TORTURE_PIPE_LEN;
-					atomic_inc(&rcu_torture_wcount[i]);
-					if (++rp->rtort_pipe_count >=
-					    RCU_TORTURE_PIPE_LEN) {
-						rp->rtort_mbtest = 0;
-						list_del(&rp->rtort_free);
-						rcu_torture_free(rp);
-					}
-				 }
+				rcu_torture_pipe_update(old_rp);
+				break;
+			case RTWS_COND_GET:
+				rcu_torture_writer_state = RTWS_COND_GET;
+				gp_snap = cur_ops->get_state();
+				i = torture_random(&rand) % 16;
+				if (i != 0)
+					schedule_timeout_interruptible(i);
+				udelay(torture_random(&rand) % 1000);
+				rcu_torture_writer_state = RTWS_COND_SYNC;
+				cur_ops->cond_sync(gp_snap);
+				rcu_torture_pipe_update(old_rp);
+				break;
+			case RTWS_SYNC:
+				rcu_torture_writer_state = RTWS_SYNC;
+				cur_ops->sync();
+				rcu_torture_pipe_update(old_rp);
+				break;
+			default:
+				WARN_ON_ONCE(1);
+				break;
 			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
+		rcu_torture_writer_state = RTWS_STUTTER;
 		stutter_wait("rcu_torture_writer");
 	} while (!torture_must_stop());
+	rcu_torture_writer_state = RTWS_STOPPING;
 	torture_kthread_stopping("rcu_torture_writer");
 	return 0;
 }
@@ -784,7 +885,7 @@ rcu_torture_fakewriter(void *arg)
 	return 0;
 }
 
-void rcutorture_trace_dump(void)
+static void rcutorture_trace_dump(void)
 {
 	static atomic_t beenhere = ATOMIC_INIT(0);
 
@@ -918,11 +1019,13 @@ rcu_torture_reader(void *arg)
 		__this_cpu_inc(rcu_torture_batch[completed]);
 		preempt_enable();
 		cur_ops->readunlock(idx);
-		schedule();
+		cond_resched();
 		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
-	if (irqreader && cur_ops->irq_capable)
+	if (irqreader && cur_ops->irq_capable) {
 		del_timer_sync(&t);
+		destroy_timer_on_stack(&t);
+	}
 	torture_kthread_stopping("rcu_torture_reader");
 	return 0;
 }
@@ -937,6 +1040,7 @@ rcu_torture_printk(char *page)
 	int i;
 	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
 	long batchsummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
+	static unsigned long rtcv_snap = ULONG_MAX;
 
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
@@ -997,6 +1101,22 @@ rcu_torture_printk(char *page)
 	page += sprintf(page, "\n");
 	if (cur_ops->stats)
 		cur_ops->stats(page);
+	if (rtcv_snap == rcu_torture_current_version &&
+	    rcu_torture_current != NULL) {
+		int __maybe_unused flags;
+		unsigned long __maybe_unused gpnum;
+		unsigned long __maybe_unused completed;
+
+		rcutorture_get_gp_data(cur_ops->ttype,
+				       &flags, &gpnum, &completed);
+		page += sprintf(page,
+				"??? Writer stall state %d g%lu c%lu f%#x\n",
+				rcu_torture_writer_state,
+				gpnum, completed, flags);
+		show_rcu_gp_kthreads();
+		rcutorture_trace_dump();
+	}
+	rtcv_snap = rcu_torture_current_version;
 }
 
 /*
@@ -1146,7 +1266,7 @@ static int __init rcu_torture_stall_init(void)
 }
 
 /* Callback function for RCU barrier testing. */
-void rcu_torture_barrier_cbf(struct rcu_head *rcu)
+static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 {
 	atomic_inc(&barrier_cbs_invoked);
 }
@@ -1416,7 +1536,8 @@ rcu_torture_init(void)
 		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
 	};
 
-	torture_init_begin(torture_type, verbose, &rcutorture_runnable);
+	if (!torture_init_begin(torture_type, verbose, &rcutorture_runnable))
+		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
@@ -1441,10 +1562,13 @@ rcu_torture_init(void)
 	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
-	if (nreaders >= 0)
+	if (nreaders >= 0) {
 		nrealreaders = nreaders;
-	else
-		nrealreaders = 2 * num_online_cpus();
+	} else {
+		nrealreaders = num_online_cpus() - 1;
+		if (nrealreaders <= 0)
+			nrealreaders = 1;
+	}
 	rcu_torture_print_module_parms(cur_ops, "Start of test");
 
 	/* Set up the freelist. */
@@ -1533,7 +1657,8 @@ rcu_torture_init(void)
 		fqs_duration = 0;
 	if (fqs_duration) {
 		/* Create the fqs thread */
-		torture_create_kthread(rcu_torture_fqs, NULL, fqs_task);
+		firsterr = torture_create_kthread(rcu_torture_fqs, NULL,
+						  fqs_task);
 		if (firsterr)
 			goto unwind;
 	}
diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
index 4315285..858c565 100644
--- a/kernel/rcu/tiny_plugin.h
+++ b/kernel/rcu/tiny_plugin.h
@@ -144,7 +144,7 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 		return;
 	rcp->ticks_this_gp++;
 	j = jiffies;
-	js = rcp->jiffies_stall;
+	js = ACCESS_ONCE(rcp->jiffies_stall);
 	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
 		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
 		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
@@ -152,17 +152,17 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 		dump_stack();
 	}
 	if (*rcp->curtail && ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies +
+		ACCESS_ONCE(rcp->jiffies_stall) = jiffies +
 			3 * rcu_jiffies_till_stall_check() + 3;
 	else if (ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+		ACCESS_ONCE(rcp->jiffies_stall) = jiffies + rcu_jiffies_till_stall_check();
 }
 
 static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
 {
 	rcp->ticks_this_gp = 0;
 	rcp->gp_start = jiffies;
-	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+	ACCESS_ONCE(rcp->jiffies_stall) = jiffies + rcu_jiffies_till_stall_check();
 }
 
 static void check_cpu_stalls(void)
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..3e3f13e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -101,7 +101,7 @@ DEFINE_PER_CPU(struct rcu_data, sname##_data)
 RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
 
-static struct rcu_state *rcu_state;
+static struct rcu_state *rcu_state_p;
 LIST_HEAD(rcu_struct_flavors);
 
 /* Increase (but not decrease) the CONFIG_RCU_FANOUT_LEAF at boot time. */
@@ -243,7 +243,7 @@ static ulong jiffies_till_next_fqs = ULONG_MAX;
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
 
-static void rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
+static bool rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 				  struct rcu_data *rdp);
 static void force_qs_rnp(struct rcu_state *rsp,
 			 int (*f)(struct rcu_data *rsp, bool *isidle,
@@ -271,6 +271,15 @@ long rcu_batches_completed_bh(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
 
 /*
+ * Force a quiescent state.
+ */
+void rcu_force_quiescent_state(void)
+{
+	force_quiescent_state(rcu_state_p);
+}
+EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
+
+/*
  * Force a quiescent state for RCU BH.
  */
 void rcu_bh_force_quiescent_state(void)
@@ -280,6 +289,21 @@ void rcu_bh_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
 /*
+ * Show the state of the grace-period kthreads.
+ */
+void show_rcu_gp_kthreads(void)
+{
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp) {
+		pr_info("%s: wait state: %d ->state: %#lx\n",
+			rsp->name, rsp->gp_state, rsp->gp_kthread->state);
+		/* sched_show_task(rsp->gp_kthread); */
+	}
+}
+EXPORT_SYMBOL_GPL(show_rcu_gp_kthreads);
+
+/*
  * Record the number of times rcutorture tests have been initiated and
  * terminated.  This information allows the debugfs tracing stats to be
  * correlated to the rcutorture messages, even when the rcutorture module
@@ -294,6 +318,39 @@ void rcutorture_record_test_transition(void)
 EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
 
 /*
+ * Send along grace-period-related data for rcutorture diagnostics.
+ */
+void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
+			    unsigned long *gpnum, unsigned long *completed)
+{
+	struct rcu_state *rsp = NULL;
+
+	switch (test_type) {
+	case RCU_FLAVOR:
+		rsp = rcu_state_p;
+		break;
+	case RCU_BH_FLAVOR:
+		rsp = &rcu_bh_state;
+		break;
+	case RCU_SCHED_FLAVOR:
+		rsp = &rcu_sched_state;
+		break;
+	default:
+		break;
+	}
+	if (rsp != NULL) {
+		*flags = ACCESS_ONCE(rsp->gp_flags);
+		*gpnum = ACCESS_ONCE(rsp->gpnum);
+		*completed = ACCESS_ONCE(rsp->completed);
+		return;
+	}
+	*flags = 0;
+	*gpnum = 0;
+	*completed = 0;
+}
+EXPORT_SYMBOL_GPL(rcutorture_get_gp_data);
+
+/*
  * Record the number of writer passes through the current rcutorture test.
  * This is also used to correlate debugfs tracing stats with the rcutorture
  * messages.
@@ -324,6 +381,28 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 }
 
 /*
+ * Return the root node of the specified rcu_state structure.
+ */
+static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
+{
+	return &rsp->node[0];
+}
+
+/*
+ * Is there any need for future grace periods?
+ * Interrupts must be disabled.  If the caller does not hold the root
+ * rnp_node structure's ->lock, the results are advisory only.
+ */
+static int rcu_future_needs_gp(struct rcu_state *rsp)
+{
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	int idx = (ACCESS_ONCE(rnp->completed) + 1) & 0x1;
+	int *fp = &rnp->need_future_gp[idx];
+
+	return ACCESS_ONCE(*fp);
+}
+
+/*
  * Does the current CPU require a not-yet-started grace period?
  * The caller must have disabled interrupts to prevent races with
  * normal callback registry.
@@ -335,7 +414,7 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_gp_in_progress(rsp))
 		return 0;  /* No, a grace period is already in progress. */
-	if (rcu_nocb_needs_gp(rsp))
+	if (rcu_future_needs_gp(rsp))
 		return 1;  /* Yes, a no-CBs CPU needs one. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL])
 		return 0;  /* No, this is a no-CBs (or offline) CPU. */
@@ -350,14 +429,6 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Return the root node of the specified rcu_state structure.
- */
-static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
-{
-	return &rsp->node[0];
-}
-
-/*
  * rcu_eqs_enter_common - current CPU is moving towards extended quiescent state
  *
  * If the new value of the ->dynticks_nesting counter now is zero,
@@ -758,7 +829,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
 	rcu_sysidle_check_cpu(rdp, isidle, maxj);
-	return (rdp->dynticks_snap & 0x1) == 0;
+	if ((rdp->dynticks_snap & 0x1) == 0) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
+		return 1;
+	} else {
+		return 0;
+	}
 }
 
 /*
@@ -834,7 +910,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 * we will beat on the first one until it gets unstuck, then move
 	 * to the next.  Only do this for the primary flavor of RCU.
 	 */
-	if (rdp->rsp == rcu_state &&
+	if (rdp->rsp == rcu_state_p &&
 	    ULONG_CMP_GE(jiffies, rdp->rsp->jiffies_resched)) {
 		rdp->rsp->jiffies_resched += 5;
 		resched_cpu(rdp->cpu);
@@ -851,7 +927,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	rsp->gp_start = j;
 	smp_wmb(); /* Record start time before stall time. */
 	j1 = rcu_jiffies_till_stall_check();
-	rsp->jiffies_stall = j + j1;
+	ACCESS_ONCE(rsp->jiffies_stall) = j + j1;
 	rsp->jiffies_resched = j + j1 / 2;
 }
 
@@ -890,12 +966,12 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	/* Only let one CPU complain about others per time interval. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	delta = jiffies - rsp->jiffies_stall;
+	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
 	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
+	ACCESS_ONCE(rsp->jiffies_stall) = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -932,9 +1008,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_end();
 	for_each_possible_cpu(cpu)
 		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
-	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu, q=%lu)\n",
+	pr_cont("(detected by %d, t=%ld jiffies, g=%ld, c=%ld, q=%lu)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
-	       rsp->gpnum, rsp->completed, totqlen);
+	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (ndetected == 0)
 		pr_err("INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
@@ -947,12 +1023,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
-/*
- * This function really isn't for public consumption, but RCU is special in
- * that context switches can allow the state machine to make progress.
- */
-extern void resched_cpu(int cpu);
-
 static void print_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -971,14 +1041,15 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_end();
 	for_each_possible_cpu(cpu)
 		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
-	pr_cont(" (t=%lu jiffies g=%lu c=%lu q=%lu)\n",
-		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed, totqlen);
+	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
+		jiffies - rsp->gp_start,
+		(long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
-		rsp->jiffies_stall = jiffies +
+	if (ULONG_CMP_GE(jiffies, ACCESS_ONCE(rsp->jiffies_stall)))
+		ACCESS_ONCE(rsp->jiffies_stall) = jiffies +
 				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
@@ -1062,7 +1133,7 @@ void rcu_cpu_stall_reset(void)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		rsp->jiffies_stall = jiffies + ULONG_MAX / 2;
+		ACCESS_ONCE(rsp->jiffies_stall) = jiffies + ULONG_MAX / 2;
 }
 
 /*
@@ -1123,15 +1194,18 @@ static void trace_rcu_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 /*
  * Start some future grace period, as needed to handle newly arrived
  * callbacks.  The required future grace periods are recorded in each
- * rcu_node structure's ->need_future_gp field.
+ * rcu_node structure's ->need_future_gp field.  Returns true if there
+ * is reason to awaken the grace-period kthread.
  *
  * The caller must hold the specified rcu_node structure's ->lock.
  */
-static unsigned long __maybe_unused
-rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
+static bool __maybe_unused
+rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
+		    unsigned long *c_out)
 {
 	unsigned long c;
 	int i;
+	bool ret = false;
 	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
 
 	/*
@@ -1142,7 +1216,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	trace_rcu_future_gp(rnp, rdp, c, TPS("Startleaf"));
 	if (rnp->need_future_gp[c & 0x1]) {
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartleaf"));
-		return c;
+		goto out;
 	}
 
 	/*
@@ -1156,7 +1230,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
 		rnp->need_future_gp[c & 0x1]++;
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
-		return c;
+		goto out;
 	}
 
 	/*
@@ -1197,12 +1271,15 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleafroot"));
 	} else {
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
-		rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
+		ret = rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
 	}
 unlock_out:
 	if (rnp != rnp_root)
 		raw_spin_unlock(&rnp_root->lock);
-	return c;
+out:
+	if (c_out != NULL)
+		*c_out = c;
+	return ret;
 }
 
 /*
@@ -1226,25 +1303,43 @@ static int rcu_future_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 }
 
 /*
+ * Awaken the grace-period kthread for the specified flavor of RCU.
+ * Don't do a self-awaken, and don't bother awakening when there is
+ * nothing for the grace-period kthread to do (as in several CPUs
+ * raced to awaken, and we lost), and finally don't try to awaken
+ * a kthread that has not yet been created.
+ */
+static void rcu_gp_kthread_wake(struct rcu_state *rsp)
+{
+	if (current == rsp->gp_kthread ||
+	    !ACCESS_ONCE(rsp->gp_flags) ||
+	    !rsp->gp_kthread)
+		return;
+	wake_up(&rsp->gp_wq);
+}
+
+/*
  * If there is room, assign a ->completed number to any callbacks on
  * this CPU that have not already been assigned.  Also accelerate any
  * callbacks that were previously assigned a ->completed number that has
  * since proven to be too conservative, which can happen if callbacks get
  * assigned a ->completed number while RCU is idle, but with reference to
  * a non-root rcu_node structure.  This function is idempotent, so it does
- * not hurt to call it repeatedly.
+ * not hurt to call it repeatedly.  Returns an flag saying that we should
+ * awaken the RCU grace-period kthread.
  *
  * The caller must hold rnp->lock with interrupts disabled.
  */
-static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
+static bool rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 			       struct rcu_data *rdp)
 {
 	unsigned long c;
 	int i;
+	bool ret;
 
 	/* If the CPU has no callbacks, nothing to do. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL] || !*rdp->nxttail[RCU_DONE_TAIL])
-		return;
+		return false;
 
 	/*
 	 * Starting from the sublist containing the callbacks most
@@ -1273,7 +1368,7 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 	 * be grouped into.
 	 */
 	if (++i >= RCU_NEXT_TAIL)
-		return;
+		return false;
 
 	/*
 	 * Assign all subsequent callbacks' ->completed number to the next
@@ -1285,13 +1380,14 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->nxtcompleted[i] = c;
 	}
 	/* Record any needed additional grace periods. */
-	rcu_start_future_gp(rnp, rdp);
+	ret = rcu_start_future_gp(rnp, rdp, NULL);
 
 	/* Trace depending on how much we were able to accelerate. */
 	if (!*rdp->nxttail[RCU_WAIT_TAIL])
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("AccWaitCB"));
 	else
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("AccReadyCB"));
+	return ret;
 }
 
 /*
@@ -1300,17 +1396,18 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
  * assign ->completed numbers to any callbacks in the RCU_NEXT_TAIL
  * sublist.  This function is idempotent, so it does not hurt to
  * invoke it repeatedly.  As long as it is not invoked -too- often...
+ * Returns true if the RCU grace-period kthread needs to be awakened.
  *
  * The caller must hold rnp->lock with interrupts disabled.
  */
-static void rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
+static bool rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 			    struct rcu_data *rdp)
 {
 	int i, j;
 
 	/* If the CPU has no callbacks, nothing to do. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL] || !*rdp->nxttail[RCU_DONE_TAIL])
-		return;
+		return false;
 
 	/*
 	 * Find all callbacks whose ->completed numbers indicate that they
@@ -1334,26 +1431,30 @@ static void rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 	}
 
 	/* Classify any remaining callbacks. */
-	rcu_accelerate_cbs(rsp, rnp, rdp);
+	return rcu_accelerate_cbs(rsp, rnp, rdp);
 }
 
 /*
  * Update CPU-local rcu_data state to record the beginnings and ends of
  * grace periods.  The caller must hold the ->lock of the leaf rcu_node
  * structure corresponding to the current CPU, and must have irqs disabled.
+ * Returns true if the grace-period kthread needs to be awakened.
  */
-static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+static bool __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp,
+			      struct rcu_data *rdp)
 {
+	bool ret;
+
 	/* Handle the ends of any preceding grace periods first. */
 	if (rdp->completed == rnp->completed) {
 
 		/* No grace period end, so just accelerate recent callbacks. */
-		rcu_accelerate_cbs(rsp, rnp, rdp);
+		ret = rcu_accelerate_cbs(rsp, rnp, rdp);
 
 	} else {
 
 		/* Advance callbacks. */
-		rcu_advance_cbs(rsp, rnp, rdp);
+		ret = rcu_advance_cbs(rsp, rnp, rdp);
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
@@ -1372,11 +1473,13 @@ static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struc
 		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
 		zero_cpu_stall_ticks(rdp);
 	}
+	return ret;
 }
 
 static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
+	bool needwake;
 	struct rcu_node *rnp;
 
 	local_irq_save(flags);
@@ -1388,8 +1491,10 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 		return;
 	}
 	smp_mb__after_unlock_lock();
-	__note_gp_changes(rsp, rnp, rdp);
+	needwake = __note_gp_changes(rsp, rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (needwake)
+		rcu_gp_kthread_wake(rsp);
 }
 
 /*
@@ -1403,12 +1508,12 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
-	if (rsp->gp_flags == 0) {
+	if (!ACCESS_ONCE(rsp->gp_flags)) {
 		/* Spurious wakeup, tell caller to go back to sleep.  */
 		raw_spin_unlock_irq(&rnp->lock);
 		return 0;
 	}
-	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
+	ACCESS_ONCE(rsp->gp_flags) = 0; /* Clear all flags: New grace period. */
 
 	if (WARN_ON_ONCE(rcu_gp_in_progress(rsp))) {
 		/*
@@ -1453,7 +1558,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		WARN_ON_ONCE(rnp->completed != rsp->completed);
 		ACCESS_ONCE(rnp->completed) = rsp->completed;
 		if (rnp == rdp->mynode)
-			__note_gp_changes(rsp, rnp, rdp);
+			(void)__note_gp_changes(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
 		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
 					    rnp->level, rnp->grplo,
@@ -1501,7 +1606,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
 		smp_mb__after_unlock_lock();
-		rsp->gp_flags &= ~RCU_GP_FLAG_FQS;
+		ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
 	return fqs_state;
@@ -1513,6 +1618,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 static void rcu_gp_cleanup(struct rcu_state *rsp)
 {
 	unsigned long gp_duration;
+	bool needgp = false;
 	int nocb = 0;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
@@ -1548,7 +1654,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
-			__note_gp_changes(rsp, rnp, rdp);
+			needgp = __note_gp_changes(rsp, rnp, rdp) || needgp;
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
@@ -1564,9 +1670,10 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	trace_rcu_grace_period(rsp->name, rsp->completed, TPS("end"));
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
-	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
-	if (cpu_needs_another_gp(rsp, rdp)) {
-		rsp->gp_flags = RCU_GP_FLAG_INIT;
+	/* Advance CBs to reduce false positives below. */
+	needgp = rcu_advance_cbs(rsp, rnp, rdp) || needgp;
+	if (needgp || cpu_needs_another_gp(rsp, rdp)) {
+		ACCESS_ONCE(rsp->gp_flags) = RCU_GP_FLAG_INIT;
 		trace_rcu_grace_period(rsp->name,
 				       ACCESS_ONCE(rsp->gpnum),
 				       TPS("newreq"));
@@ -1593,6 +1700,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("reqwait"));
+			rsp->gp_state = RCU_GP_WAIT_GPS;
 			wait_event_interruptible(rsp->gp_wq,
 						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
@@ -1620,6 +1728,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("fqswait"));
+			rsp->gp_state = RCU_GP_WAIT_FQS;
 			ret = wait_event_interruptible_timeout(rsp->gp_wq,
 					((gf = ACCESS_ONCE(rsp->gp_flags)) &
 					 RCU_GP_FLAG_FQS) ||
@@ -1665,14 +1774,6 @@ static int __noreturn rcu_gp_kthread(void *arg)
 	}
 }
 
-static void rsp_wakeup(struct irq_work *work)
-{
-	struct rcu_state *rsp = container_of(work, struct rcu_state, wakeup_work);
-
-	/* Wake up rcu_gp_kthread() to start the grace period. */
-	wake_up(&rsp->gp_wq);
-}
-
 /*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
@@ -1681,8 +1782,10 @@ static void rsp_wakeup(struct irq_work *work)
  * Note that it is legal for a dying CPU (which is marked as offline) to
  * invoke this function.  This can happen when the dying CPU reports its
  * quiescent state.
+ *
+ * Returns true if the grace-period kthread must be awakened.
  */
-static void
+static bool
 rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 		      struct rcu_data *rdp)
 {
@@ -1693,20 +1796,18 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 		 * or a grace period is already in progress.
 		 * Either way, don't start a new grace period.
 		 */
-		return;
+		return false;
 	}
-	rsp->gp_flags = RCU_GP_FLAG_INIT;
+	ACCESS_ONCE(rsp->gp_flags) = RCU_GP_FLAG_INIT;
 	trace_rcu_grace_period(rsp->name, ACCESS_ONCE(rsp->gpnum),
 			       TPS("newreq"));
 
 	/*
 	 * We can't do wakeups while holding the rnp->lock, as that
 	 * could cause possible deadlocks with the rq->lock. Defer
-	 * the wakeup to interrupt context.  And don't bother waking
-	 * up the running kthread.
+	 * the wakeup to our caller.
 	 */
-	if (current != rsp->gp_kthread)
-		irq_work_queue(&rsp->wakeup_work);
+	return true;
 }
 
 /*
@@ -1715,12 +1816,14 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
  * is invoked indirectly from rcu_advance_cbs(), which would result in
  * endless recursion -- or would do so if it wasn't for the self-deadlock
  * that is encountered beforehand.
+ *
+ * Returns true if the grace-period kthread needs to be awakened.
  */
-static void
-rcu_start_gp(struct rcu_state *rsp)
+static bool rcu_start_gp(struct rcu_state *rsp)
 {
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	bool ret = false;
 
 	/*
 	 * If there is no grace period in progress right now, any
@@ -1730,8 +1833,9 @@ rcu_start_gp(struct rcu_state *rsp)
 	 * resulting in pointless grace periods.  So, advance callbacks
 	 * then start the grace period!
 	 */
-	rcu_advance_cbs(rsp, rnp, rdp);
-	rcu_start_gp_advanced(rsp, rnp, rdp);
+	ret = rcu_advance_cbs(rsp, rnp, rdp) || ret;
+	ret = rcu_start_gp_advanced(rsp, rnp, rdp) || ret;
+	return ret;
 }
 
 /*
@@ -1820,6 +1924,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	unsigned long mask;
+	bool needwake;
 	struct rcu_node *rnp;
 
 	rnp = rdp->mynode;
@@ -1848,9 +1953,11 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 		 * This GP can't end until cpu checks in, so all of our
 		 * callbacks can be processed during the next GP.
 		 */
-		rcu_accelerate_cbs(rsp, rnp, rdp);
+		needwake = rcu_accelerate_cbs(rsp, rnp, rdp);
 
 		rcu_report_qs_rnp(mask, rsp, rnp, flags); /* rlses rnp->lock */
+		if (needwake)
+			rcu_gp_kthread_wake(rsp);
 	}
 }
 
@@ -1951,7 +2058,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp, unsigned long flags)
 {
 	int i;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	/* No-CBs CPUs are handled specially. */
 	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp, flags))
@@ -2320,7 +2427,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
-	rsp->gp_flags |= RCU_GP_FLAG_FQS;
+	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
@@ -2334,7 +2441,8 @@ static void
 __rcu_process_callbacks(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	bool needwake;
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
@@ -2345,8 +2453,10 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	local_irq_save(flags);
 	if (cpu_needs_another_gp(rsp, rdp)) {
 		raw_spin_lock(&rcu_get_root(rsp)->lock); /* irqs disabled. */
-		rcu_start_gp(rsp);
+		needwake = rcu_start_gp(rsp);
 		raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
+		if (needwake)
+			rcu_gp_kthread_wake(rsp);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -2404,6 +2514,8 @@ static void invoke_rcu_core(void)
 static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			    struct rcu_head *head, unsigned long flags)
 {
+	bool needwake;
+
 	/*
 	 * If called from an extended quiescent state, invoke the RCU
 	 * core in order to force a re-evaluation of RCU's idleness.
@@ -2433,8 +2545,10 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 
 			raw_spin_lock(&rnp_root->lock);
 			smp_mb__after_unlock_lock();
-			rcu_start_gp(rsp);
+			needwake = rcu_start_gp(rsp);
 			raw_spin_unlock(&rnp_root->lock);
+			if (needwake)
+				rcu_gp_kthread_wake(rsp);
 		} else {
 			/* Give the grace period a kick. */
 			rdp->blimit = LONG_MAX;
@@ -2537,6 +2651,20 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
 /*
+ * Queue an RCU callback for lazy invocation after a grace period.
+ * This will likely be later named something like "call_rcu_lazy()",
+ * but this change will require some way of tagging the lazy RCU
+ * callbacks in the list of pending callbacks. Until then, this
+ * function may only be called from __kfree_rcu().
+ */
+void kfree_call_rcu(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, rcu_state_p, -1, 1);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu);
+
+/*
  * Because a context switch is a grace period for RCU-sched and RCU-bh,
  * any blocking grace-period wait automatically implies a grace period
  * if there is only one CPU online at any point time during execution
@@ -2659,7 +2787,7 @@ unsigned long get_state_synchronize_rcu(void)
 	 * time-consuming work between get_state_synchronize_rcu()
 	 * and cond_synchronize_rcu().
 	 */
-	return smp_load_acquire(&rcu_state->gpnum);
+	return smp_load_acquire(&rcu_state_p->gpnum);
 }
 EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);
 
@@ -2685,7 +2813,7 @@ void cond_synchronize_rcu(unsigned long oldstate)
 	 * Ensure that this load happens before any RCU-destructive
 	 * actions the caller might carry out after we return.
 	 */
-	newstate = smp_load_acquire(&rcu_state->completed);
+	newstate = smp_load_acquire(&rcu_state_p->completed);
 	if (ULONG_CMP_GE(oldstate, newstate))
 		synchronize_rcu();
 }
@@ -2988,7 +3116,7 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
 static void rcu_barrier_func(void *type)
 {
 	struct rcu_state *rsp = type;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
 	atomic_inc(&rsp->barrier_cpu_count);
@@ -3160,7 +3288,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
  * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void
-rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -3173,7 +3301,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->beenonline = 1;	 /* We have now been online. */
-	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
@@ -3217,8 +3344,7 @@ static void rcu_prepare_cpu(int cpu)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		rcu_init_percpu_data(cpu, rsp,
-				     strcmp(rsp->name, "rcu_preempt") == 0);
+		rcu_init_percpu_data(cpu, rsp);
 }
 
 /*
@@ -3228,7 +3354,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
 
@@ -3402,8 +3528,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			rnp->qsmaskinit = 0;
 			rnp->grplo = j * cpustride;
 			rnp->grphi = (j + 1) * cpustride - 1;
-			if (rnp->grphi >= NR_CPUS)
-				rnp->grphi = NR_CPUS - 1;
+			if (rnp->grphi >= nr_cpu_ids)
+				rnp->grphi = nr_cpu_ids - 1;
 			if (i == 0) {
 				rnp->grpnum = 0;
 				rnp->grpmask = 0;
@@ -3422,7 +3548,6 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 	rsp->rda = rda;
 	init_waitqueue_head(&rsp->gp_wq);
-	init_irq_work(&rsp->wakeup_work, rsp_wakeup);
 	rnp = rsp->level[rcu_num_lvls - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 75dc3c3..bf2c1e6 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -252,7 +252,6 @@ struct rcu_data {
 	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
-	bool		preemptible;	/* Preemptible RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 #ifdef CONFIG_RCU_CPU_STALL_INFO
@@ -406,7 +405,8 @@ struct rcu_state {
 	unsigned long completed;		/* # of last completed gp. */
 	struct task_struct *gp_kthread;		/* Task for grace periods. */
 	wait_queue_head_t gp_wq;		/* Where GP task waits. */
-	int gp_flags;				/* Commands for GP task. */
+	short gp_flags;				/* Commands for GP task. */
+	short gp_state;				/* GP kthread sleep state. */
 
 	/* End of fields guarded by root rcu_node's lock. */
 
@@ -462,13 +462,17 @@ struct rcu_state {
 	const char *name;			/* Name of structure. */
 	char abbr;				/* Abbreviated name. */
 	struct list_head flavors;		/* List of RCU flavors. */
-	struct irq_work wakeup_work;		/* Postponed wakeups */
 };
 
 /* Values for rcu_state structure's gp_flags field. */
 #define RCU_GP_FLAG_INIT 0x1	/* Need grace-period initialization. */
 #define RCU_GP_FLAG_FQS  0x2	/* Need grace-period quiescent-state forcing. */
 
+/* Values for rcu_state structure's gp_flags field. */
+#define RCU_GP_WAIT_INIT 0	/* Initial state. */
+#define RCU_GP_WAIT_GPS  1	/* Wait for grace-period start. */
+#define RCU_GP_WAIT_FQS  2	/* Wait for force-quiescent-state time. */
+
 extern struct list_head rcu_struct_flavors;
 
 /* Sequence through rcu_state structures for each RCU flavor. */
@@ -547,7 +551,6 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
-static int rcu_nocb_needs_gp(struct rcu_state *rsp);
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 962d1d5..29977ae 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -116,7 +116,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
-static struct rcu_state *rcu_state = &rcu_preempt_state;
+static struct rcu_state *rcu_state_p = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
@@ -149,15 +149,6 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
- * Force a quiescent state for preemptible RCU.
- */
-void rcu_force_quiescent_state(void)
-{
-	force_quiescent_state(&rcu_preempt_state);
-}
-EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
-
-/*
  * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
@@ -688,20 +679,6 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
-/*
- * Queue an RCU callback for lazy invocation after a grace period.
- * This will likely be later named something like "call_rcu_lazy()",
- * but this change will require some way of tagging the lazy RCU
- * callbacks in the list of pending callbacks.  Until then, this
- * function may only be called from __kfree_rcu().
- */
-void kfree_call_rcu(struct rcu_head *head,
-		    void (*func)(struct rcu_head *rcu))
-{
-	__call_rcu(head, func, &rcu_preempt_state, -1, 1);
-}
-EXPORT_SYMBOL_GPL(kfree_call_rcu);
-
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -970,7 +947,7 @@ void exit_rcu(void)
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-static struct rcu_state *rcu_state = &rcu_sched_state;
+static struct rcu_state *rcu_state_p = &rcu_sched_state;
 
 /*
  * Tell them what RCU they are running.
@@ -991,16 +968,6 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
- * Force a quiescent state for RCU, which, because there is no preemptible
- * RCU, becomes the same as rcu-sched.
- */
-void rcu_force_quiescent_state(void)
-{
-	rcu_sched_force_quiescent_state();
-}
-EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
-
-/*
  * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
@@ -1080,22 +1047,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 }
 
 /*
- * Queue an RCU callback for lazy invocation after a grace period.
- * This will likely be later named something like "call_rcu_lazy()",
- * but this change will require some way of tagging the lazy RCU
- * callbacks in the list of pending callbacks.  Until then, this
- * function may only be called from __kfree_rcu().
- *
- * Because there is no preemptible RCU, we use RCU-sched instead.
- */
-void kfree_call_rcu(struct rcu_head *head,
-		    void (*func)(struct rcu_head *rcu))
-{
-	__call_rcu(head, func, &rcu_sched_state, -1, 1);
-}
-EXPORT_SYMBOL_GPL(kfree_call_rcu);
-
-/*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptible RCU does not exist, map to rcu-sched.
  */
@@ -1517,11 +1468,11 @@ static int __init rcu_spawn_kthreads(void)
 	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
-	rnp = rcu_get_root(rcu_state);
-	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
+	rnp = rcu_get_root(rcu_state_p);
+	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state, rnp)
-			(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
+		rcu_for_each_leaf_node(rcu_state_p, rnp)
+			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
 	return 0;
 }
@@ -1529,12 +1480,12 @@ early_initcall(rcu_spawn_kthreads);
 
 static void rcu_prepare_kthreads(int cpu)
 {
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
 	if (rcu_scheduler_fully_active)
-		(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
+		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -1744,6 +1695,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
 static void rcu_prepare_for_idle(int cpu)
 {
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
+	bool needwake;
 	struct rcu_data *rdp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	struct rcu_node *rnp;
@@ -1792,8 +1744,10 @@ static void rcu_prepare_for_idle(int cpu)
 		rnp = rdp->mynode;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 		smp_mb__after_unlock_lock();
-		rcu_accelerate_cbs(rsp, rnp, rdp);
+		needwake = rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		if (needwake)
+			rcu_gp_kthread_wake(rsp);
 	}
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 }
@@ -1855,7 +1809,7 @@ static void rcu_oom_notify_cpu(void *unused)
 	struct rcu_data *rdp;
 
 	for_each_rcu_flavor(rsp) {
-		rdp = __this_cpu_ptr(rsp->rda);
+		rdp = raw_cpu_ptr(rsp->rda);
 		if (rdp->qlen_lazy != 0) {
 			atomic_inc(&oom_callback_count);
 			rsp->call(&rdp->oom_head, rcu_oom_callback);
@@ -1997,7 +1951,7 @@ static void increment_cpu_stall_ticks(void)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
+		raw_cpu_inc(rsp->rda->ticks_this_gp);
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
@@ -2068,19 +2022,6 @@ static int __init parse_rcu_nocb_poll(char *arg)
 early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
 
 /*
- * Do any no-CBs CPUs need another grace period?
- *
- * Interrupts must be disabled.  If the caller does not hold the root
- * rnp_node structure's ->lock, the results are advisory only.
- */
-static int rcu_nocb_needs_gp(struct rcu_state *rsp)
-{
-	struct rcu_node *rnp = rcu_get_root(rsp);
-
-	return rnp->need_future_gp[(ACCESS_ONCE(rnp->completed) + 1) & 0x1];
-}
-
-/*
  * Wake up any no-CBs CPUs' kthreads that were waiting on the just-ended
  * grace period.
  */
@@ -2109,7 +2050,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 }
 
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-/* Is the specified CPU a no-CPUs CPU? */
+/* Is the specified CPU a no-CBs CPU? */
 bool rcu_is_nocb_cpu(int cpu)
 {
 	if (have_rcu_nocb_mask)
@@ -2243,12 +2184,15 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	unsigned long c;
 	bool d;
 	unsigned long flags;
+	bool needwake;
 	struct rcu_node *rnp = rdp->mynode;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();
-	c = rcu_start_future_gp(rnp, rdp);
+	needwake = rcu_start_future_gp(rnp, rdp, &c);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (needwake)
+		rcu_gp_kthread_wake(rdp->rsp);
 
 	/*
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
@@ -2402,11 +2346,6 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 
-static int rcu_nocb_needs_gp(struct rcu_state *rsp)
-{
-	return 0;
-}
-
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
 }
@@ -2657,20 +2596,6 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 }
 
 /*
- * Bind the grace-period kthread for the sysidle flavor of RCU to the
- * timekeeping CPU.
- */
-static void rcu_bind_gp_kthread(void)
-{
-	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
-
-	if (cpu < 0 || cpu >= nr_cpu_ids)
-		return;
-	if (raw_smp_processor_id() != cpu)
-		set_cpus_allowed_ptr(current, cpumask_of(cpu));
-}
-
-/*
  * Return a delay in jiffies based on the number of CPUs, rcu_node
  * leaf fanout, and jiffies tick rate.  The idea is to allow larger
  * systems more time to transition to full-idle state in order to
@@ -2734,7 +2659,8 @@ static void rcu_sysidle(unsigned long j)
 static void rcu_sysidle_cancel(void)
 {
 	smp_mb();
-	ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
+	if (full_sysidle_state > RCU_SYSIDLE_SHORT)
+		ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
 }
 
 /*
@@ -2880,10 +2806,6 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 	return false;
 }
 
-static void rcu_bind_gp_kthread(void)
-{
-}
-
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj)
 {
@@ -2914,3 +2836,19 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 	return 0;
 }
+
+/*
+ * Bind the grace-period kthread for the sysidle flavor of RCU to the
+ * timekeeping CPU.
+ */
+static void rcu_bind_gp_kthread(void)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+
+	if (cpu < 0 || cpu >= nr_cpu_ids)
+		return;
+	if (raw_smp_processor_id() != cpu)
+		set_cpus_allowed_ptr(current, cpumask_of(cpu));
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+}
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4c0a9b0..a2aeb4d 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -320,6 +320,18 @@ int rcu_jiffies_till_stall_check(void)
 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
 }
 
+void rcu_sysrq_start(void)
+{
+	if (!rcu_cpu_stall_suppress)
+		rcu_cpu_stall_suppress = 2;
+}
+
+void rcu_sysrq_end(void)
+{
+	if (rcu_cpu_stall_suppress == 2)
+		rcu_cpu_stall_suppress = 0;
+}
+
 static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 {
 	rcu_cpu_stall_suppress = 1;
@@ -338,3 +350,21 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
+/*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+DEFINE_PER_CPU(int, rcu_cond_resched_count);
+
+/*
+ * Report a set of RCU quiescent states, for use by cond_resched()
+ * and friends.  Out of line due to being called infrequently.
+ */
+void rcu_resched(void)
+{
+	preempt_disable();
+	__this_cpu_write(rcu_cond_resched_count, 0);
+	rcu_note_context_switch(smp_processor_id());
+	preempt_enable();
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d9d8ece..64f71f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4051,6 +4051,7 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
+	rcu_cond_resched();
 	if (should_resched()) {
 		__cond_resched();
 		return 1;
@@ -4069,15 +4070,18 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int __cond_resched_lock(spinlock_t *lock)
 {
+	bool need_rcu_resched = rcu_should_resched();
 	int resched = should_resched();
 	int ret = 0;
 
 	lockdep_assert_held(lock);
 
-	if (spin_needbreak(lock) || resched) {
+	if (spin_needbreak(lock) || resched || need_rcu_resched) {
 		spin_unlock(lock);
 		if (resched)
 			__cond_resched();
+		else if (unlikely(need_rcu_resched))
+			rcu_resched();
 		else
 			cpu_relax();
 		ret = 1;
@@ -4091,6 +4095,7 @@ int __sched __cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
+	rcu_cond_resched();  /* BH disabled OK, just recording QSes. */
 	if (should_resched()) {
 		local_bh_enable();
 		__cond_resched();
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 92f24f5..5918d22 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -232,7 +232,6 @@ asmlinkage __visible void __do_softirq(void)
 	bool in_hardirq;
 	__u32 pending;
 	int softirq_bit;
-	int cpu;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -247,7 +246,6 @@ asmlinkage __visible void __do_softirq(void)
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_OFFSET);
 	in_hardirq = lockdep_softirq_start();
 
-	cpu = smp_processor_id();
 restart:
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
@@ -276,11 +274,11 @@ restart:
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
 		}
-		rcu_bh_qs(cpu);
 		h++;
 		pending >>= softirq_bit;
 	}
 
+	rcu_bh_qs(smp_processor_id());
 	local_irq_disable();
 
 	pending = local_softirq_pending();
diff --git a/kernel/torture.c b/kernel/torture.c
index acc9afc..40bb511 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -335,13 +335,8 @@ static void torture_shuffle_tasks(void)
 	shuffle_idle_cpu = cpumask_next(shuffle_idle_cpu, shuffle_tmp_mask);
 	if (shuffle_idle_cpu >= nr_cpu_ids)
 		shuffle_idle_cpu = -1;
-	if (shuffle_idle_cpu != -1) {
+	else
 		cpumask_clear_cpu(shuffle_idle_cpu, shuffle_tmp_mask);
-		if (cpumask_empty(shuffle_tmp_mask)) {
-			put_online_cpus();
-			return;
-		}
-	}
 
 	mutex_lock(&shuffle_task_mutex);
 	list_for_each_entry(stp, &shuffle_task_list, st_l)
@@ -533,7 +528,11 @@ void stutter_wait(const char *title)
 	while (ACCESS_ONCE(stutter_pause_test) ||
 	       (torture_runnable && !ACCESS_ONCE(*torture_runnable))) {
 		if (stutter_pause_test)
-			schedule_timeout_interruptible(1);
+			if (ACCESS_ONCE(stutter_pause_test) == 1)
+				schedule_timeout_interruptible(1);
+			else
+				while (ACCESS_ONCE(stutter_pause_test))
+					cond_resched();
 		else
 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
 		torture_shutdown_absorb(title);
@@ -550,7 +549,11 @@ static int torture_stutter(void *arg)
 	VERBOSE_TOROUT_STRING("torture_stutter task started");
 	do {
 		if (!torture_must_stop()) {
-			schedule_timeout_interruptible(stutter);
+			if (stutter > 1) {
+				schedule_timeout_interruptible(stutter - 1);
+				ACCESS_ONCE(stutter_pause_test) = 2;
+			}
+			schedule_timeout_interruptible(1);
 			ACCESS_ONCE(stutter_pause_test) = 1;
 		}
 		if (!torture_must_stop())
@@ -596,21 +599,27 @@ static void torture_stutter_cleanup(void)
  * The runnable parameter points to a flag that controls whether or not
  * the test is currently runnable.  If there is no such flag, pass in NULL.
  */
-void __init torture_init_begin(char *ttype, bool v, int *runnable)
+bool torture_init_begin(char *ttype, bool v, int *runnable)
 {
 	mutex_lock(&fullstop_mutex);
+	if (torture_type != NULL) {
+		pr_alert("torture_init_begin: refusing %s init: %s running",
+			 ttype, torture_type);
+		mutex_unlock(&fullstop_mutex);
+		return false;
+	}
 	torture_type = ttype;
 	verbose = v;
 	torture_runnable = runnable;
 	fullstop = FULLSTOP_DONTSTOP;
-
+	return true;
 }
 EXPORT_SYMBOL_GPL(torture_init_begin);
 
 /*
  * Tell the torture module that initialization is complete.
  */
-void __init torture_init_end(void)
+void torture_init_end(void)
 {
 	mutex_unlock(&fullstop_mutex);
 	register_reboot_notifier(&torture_shutdown_nb);
@@ -642,6 +651,9 @@ bool torture_cleanup(void)
 	torture_shuffle_cleanup();
 	torture_stutter_cleanup();
 	torture_onoff_cleanup();
+	mutex_lock(&fullstop_mutex);
+	torture_type = NULL;
+	mutex_unlock(&fullstop_mutex);
 	return false;
 }
 EXPORT_SYMBOL_GPL(torture_cleanup);
@@ -674,8 +686,10 @@ EXPORT_SYMBOL_GPL(torture_must_stop_irq);
  */
 void torture_kthread_stopping(char *title)
 {
-	if (verbose)
-		VERBOSE_TOROUT_STRING(title);
+	char buf[128];
+
+	snprintf(buf, sizeof(buf), "Stopping %s", title);
+	VERBOSE_TOROUT_STRING(buf);
 	while (!kthread_should_stop()) {
 		torture_shutdown_absorb(title);
 		schedule_timeout_uninterruptible(1);
diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
index a1be6e6..9c3f3d3 100755
--- a/tools/testing/selftests/rcutorture/bin/configinit.sh
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -62,7 +62,7 @@ grep '^grep' < $T/u.sh > $T/upd.sh
 echo "cat - $c" >> $T/upd.sh
 make mrproper
 make $buildloc distclean > $builddir/Make.distclean 2>&1
-make $buildloc defconfig > $builddir/Make.defconfig.out 2>&1
+make $buildloc $TORTURE_DEFCONFIG > $builddir/Make.defconfig.out 2>&1
 mv $builddir/.config $builddir/.config.sav
 sh $T/upd.sh < $builddir/.config.sav > $builddir/.config
 cp $builddir/.config $builddir/.config.new
diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 9b17e81..d01b865 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -76,15 +76,39 @@ configfrag_hotplug_cpu () {
 	grep -q '^CONFIG_HOTPLUG_CPU=y$' "$1"
 }
 
+# identify_boot_image qemu-cmd
+#
+# Returns the relative path to the kernel build image.  This will be
+# arch/<arch>/boot/bzImage unless overridden with the TORTURE_BOOT_IMAGE
+# environment variable.
+identify_boot_image () {
+	if test -n "$TORTURE_BOOT_IMAGE"
+	then
+		echo $TORTURE_BOOT_IMAGE
+	else
+		case "$1" in
+		qemu-system-x86_64|qemu-system-i386)
+			echo arch/x86/boot/bzImage
+			;;
+		qemu-system-ppc64)
+			echo arch/powerpc/boot/bzImage
+			;;
+		*)
+			echo ""
+			;;
+		esac
+	fi
+}
+
 # identify_qemu builddir
 #
 # Returns our best guess as to which qemu command is appropriate for
-# the kernel at hand.  Override with the RCU_QEMU_CMD environment variable.
+# the kernel at hand.  Override with the TORTURE_QEMU_CMD environment variable.
 identify_qemu () {
 	local u="`file "$1"`"
-	if test -n "$RCU_QEMU_CMD"
+	if test -n "$TORTURE_QEMU_CMD"
 	then
-		echo $RCU_QEMU_CMD
+		echo $TORTURE_QEMU_CMD
 	elif echo $u | grep -q x86-64
 	then
 		echo qemu-system-x86_64
@@ -98,7 +122,7 @@ identify_qemu () {
 		echo Cannot figure out what qemu command to use! 1>&2
 		echo file $1 output: $u
 		# Usually this will be one of /usr/bin/qemu-system-*
-		# Use RCU_QEMU_CMD environment variable or appropriate
+		# Use TORTURE_QEMU_CMD environment variable or appropriate
 		# argument to top-level script.
 		exit 1
 	fi
@@ -107,14 +131,14 @@ identify_qemu () {
 # identify_qemu_append qemu-cmd
 #
 # Output arguments for the qemu "-append" string based on CPU type
-# and the RCU_QEMU_INTERACTIVE environment variable.
+# and the TORTURE_QEMU_INTERACTIVE environment variable.
 identify_qemu_append () {
 	case "$1" in
 	qemu-system-x86_64|qemu-system-i386)
 		echo noapic selinux=0 initcall_debug debug
 		;;
 	esac
-	if test -n "$RCU_QEMU_INTERACTIVE"
+	if test -n "$TORTURE_QEMU_INTERACTIVE"
 	then
 		echo root=/dev/sda
 	else
@@ -124,8 +148,8 @@ identify_qemu_append () {
 
 # identify_qemu_args qemu-cmd serial-file
 #
-# Output arguments for qemu arguments based on the RCU_QEMU_MAC
-# and RCU_QEMU_INTERACTIVE environment variables.
+# Output arguments for qemu arguments based on the TORTURE_QEMU_MAC
+# and TORTURE_QEMU_INTERACTIVE environment variables.
 identify_qemu_args () {
 	case "$1" in
 	qemu-system-x86_64|qemu-system-i386)
@@ -133,17 +157,17 @@ identify_qemu_args () {
 	qemu-system-ppc64)
 		echo -enable-kvm -M pseries -cpu POWER7 -nodefaults
 		echo -device spapr-vscsi
-		if test -n "$RCU_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
+		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$TORTURE_QEMU_MAC"
 		then
-			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
+			echo -device spapr-vlan,netdev=net0,mac=$TORTURE_QEMU_MAC
 			echo -netdev bridge,br=br0,id=net0
-		elif test -n "$RCU_QEMU_INTERACTIVE"
+		elif test -n "$TORTURE_QEMU_INTERACTIVE"
 		then
 			echo -net nic -net user
 		fi
 		;;
 	esac
-	if test -n "$RCU_QEMU_INTERACTIVE"
+	if test -n "$TORTURE_QEMU_INTERACTIVE"
 	then
 		echo -monitor stdio -serial pty -S
 	else
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index 197901e..7c1e56b 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -45,9 +45,9 @@ T=/tmp/test-linux.sh.$$
 trap 'rm -rf $T' 0
 mkdir $T
 
-cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
+grep -v 'CONFIG_[A-Z]*_TORTURE_TEST' < ${config_template} > $T/config
 cat << ___EOF___ >> $T/config
-CONFIG_INITRAMFS_SOURCE="$RCU_INITRD"
+CONFIG_INITRAMFS_SOURCE="$TORTURE_INITRD"
 CONFIG_VIRTIO_PCI=y
 CONFIG_VIRTIO_CONSOLE=y
 ___EOF___
@@ -60,7 +60,7 @@ then
 	exit 2
 fi
 ncpus=`cpus2use.sh`
-make O=$builddir -j$ncpus $RCU_KMAKE_ARG > $builddir/Make.out 2>&1
+make O=$builddir -j$ncpus $TORTURE_KMAKE_ARG > $builddir/Make.out 2>&1
 retval=$?
 if test $retval -ne 0 || grep "rcu[^/]*": < $builddir/Make.out | egrep -q "Stop|Error|error:|warning:" || egrep -q "Stop|Error|error:" < $builddir/Make.out
 then
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
index 829186e..7f1ff1a 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -35,7 +35,7 @@ configfile=`echo $i | sed -e 's/^.*\///'`
 ncs=`grep "Writes:  Total:" $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* Total: //' -e 's/ .*$//'`
 if test -z "$ncs"
 then
-	echo $configfile
+	echo "$configfile -------"
 else
 	title="$configfile ------- $ncs acquisitions/releases"
 	dur=`sed -e 's/^.* locktorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
index d75b1dc5..307c4b9 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -35,7 +35,7 @@ configfile=`echo $i | sed -e 's/^.*\///'`
 ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
 if test -z "$ngps"
 then
-	echo $configfile
+	echo "$configfile -------"
 else
 	title="$configfile ------- $ngps grace periods"
 	dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index a44daaa..ee1f6ca 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -25,6 +25,7 @@
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
 PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
+. tools/testing/selftests/rcutorture/bin/functions.sh
 for rd in "$@"
 do
 	firsttime=1
@@ -39,13 +40,24 @@ do
 		fi
 		TORTURE_SUITE="`cat $i/../TORTURE_SUITE`"
 		kvm-recheck-${TORTURE_SUITE}.sh $i
-		configcheck.sh $i/.config $i/ConfigFragment
-		parse-build.sh $i/Make.out $configfile
-		parse-rcutorture.sh $i/console.log $configfile
-		parse-console.sh $i/console.log $configfile
-		if test -r $i/Warnings
+		if test -f "$i/console.log"
 		then
-			cat $i/Warnings
+			configcheck.sh $i/.config $i/ConfigFragment
+			parse-build.sh $i/Make.out $configfile
+			parse-torture.sh $i/console.log $configfile
+			parse-console.sh $i/console.log $configfile
+			if test -r $i/Warnings
+			then
+				cat $i/Warnings
+			fi
+		else
+			if test -f "$i/qemu-cmd"
+			then
+				print_bug qemu failed
+			else
+				print_bug Build failed
+			fi
+			echo "   $i"
 		fi
 	done
 done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 94b28bb..27e544e 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -94,9 +94,17 @@ fi
 # CONFIG_YENTA=n
 if kvm-build.sh $config_template $builddir $T
 then
+	QEMU="`identify_qemu $builddir/vmlinux`"
+	BOOT_IMAGE="`identify_boot_image $QEMU`"
 	cp $builddir/Make*.out $resdir
 	cp $builddir/.config $resdir
-	cp $builddir/arch/x86/boot/bzImage $resdir
+	if test -n "$BOOT_IMAGE"
+	then
+		cp $builddir/$BOOT_IMAGE $resdir
+	else
+		echo No identifiable boot image, not running KVM, see $resdir.
+		echo Do the torture scripts know about your architecture?
+	fi
 	parse-build.sh $resdir/Make.out $title
 	if test -f $builddir.wait
 	then
@@ -104,6 +112,7 @@ then
 	fi
 else
 	cp $builddir/Make*.out $resdir
+	cp $builddir/.config $resdir || :
 	echo Build failed, not running KVM, see $resdir.
 	if test -f $builddir.wait
 	then
@@ -124,9 +133,6 @@ cd $KVM
 kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
 echo ' ---' `date`: Starting kernel
 
-# Determine the appropriate flavor of qemu command.
-QEMU="`identify_qemu $builddir/vmlinux`"
-
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
@@ -151,27 +157,38 @@ boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 # Generate kernel-version-specific boot parameters
 boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
-echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
-if test -n "$RCU_BUILDONLY"
+echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+if test -n "$TORTURE_BUILDONLY"
 then
 	echo Build-only run specified, boot/test omitted.
 	exit 0
 fi
-$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args" &
+( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
-for ((i=0;i<$seconds;i++))
+while :
 do
+	kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
 	if kill -0 $qemu_pid > /dev/null 2>&1
 	then
+		if test $kruntime -ge $seconds
+		then
+			break;
+		fi
 		sleep 1
 	else
 		commandcompleted=1
-		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
 		if test $kruntime -lt $seconds
 		then
 			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
+			grep "^(qemu) qemu:" $resdir/kvm-test-1-run.sh.out >> $resdir/Warnings 2>&1
+			killpid="`sed -n "s/^(qemu) qemu: terminating on signal [0-9]* from pid \([0-9]*\).*$/\1/p" $resdir/Warnings`"
+			if test -n "$killpid"
+			then
+				echo "ps -fp $killpid" >> $resdir/Warnings 2>&1
+				ps -fp $killpid >> $resdir/Warnings 2>&1
+			fi
 		else
 			echo ' ---' `date`: Kernel done
 		fi
@@ -181,23 +198,25 @@ done
 if test $commandcompleted -eq 0
 then
 	echo Grace period for qemu job at pid $qemu_pid
-	for ((i=0;i<=$grace;i++))
+	while :
 	do
+		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
 		if kill -0 $qemu_pid > /dev/null 2>&1
 		then
-			sleep 1
+			:
 		else
 			break
 		fi
-		if test $i -eq $grace
+		if test $kruntime -ge $((seconds + grace))
 		then
-			kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }'`
 			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
 			kill -KILL $qemu_pid
+			break
 		fi
+		sleep 1
 	done
 fi
 
 cp $builddir/console.log $resdir
-parse-${TORTURE_SUITE}torture.sh $resdir/console.log $title
+parse-torture.sh $resdir/console.log $title
 parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 5a78cbf..40285c5 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -38,9 +38,10 @@ dur=30
 dryrun=""
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
-builddir="${KVM}/b1"
-RCU_INITRD="$KVM/initrd"; export RCU_INITRD
-RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
+TORTURE_DEFCONFIG=defconfig
+TORTURE_BOOT_IMAGE=""
+TORTURE_INITRD="$KVM/initrd"; export TORTURE_INITRD
+TORTURE_KMAKE_ARG=""
 TORTURE_SUITE=rcu
 resdir=""
 configs=""
@@ -53,11 +54,12 @@ kversion=""
 usage () {
 	echo "Usage: $scriptname optional arguments:"
 	echo "       --bootargs kernel-boot-arguments"
-	echo "       --builddir absolute-pathname"
+	echo "       --bootimage relative-path-to-kernel-boot-image"
 	echo "       --buildonly"
 	echo "       --configs \"config-file list\""
 	echo "       --cpus N"
 	echo "       --datestamp string"
+	echo "       --defconfig string"
 	echo "       --dryrun sched|script"
 	echo "       --duration minutes"
 	echo "       --interactive"
@@ -67,7 +69,6 @@ usage () {
 	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
 	echo "       --qemu-cmd qemu-system-..."
-	echo "       --relbuilddir relative-pathname"
 	echo "       --results absolute-pathname"
 	echo "       --torture rcu"
 	exit 1
@@ -78,17 +79,16 @@ do
 	case "$1" in
 	--bootargs)
 		checkarg --bootargs "(list of kernel boot arguments)" "$#" "$2" '.*' '^--'
-		RCU_BOOTARGS="$2"
+		TORTURE_BOOTARGS="$2"
 		shift
 		;;
-	--builddir)
-		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' '^error'
-		builddir=$2
-		gotbuilddir=1
+	--bootimage)
+		checkarg --bootimage "(relative path to kernel boot image)" "$#" "$2" '[a-zA-Z0-9][a-zA-Z0-9_]*' '^--'
+		TORTURE_BOOT_IMAGE="$2"
 		shift
 		;;
 	--buildonly)
-		RCU_BUILDONLY=1; export RCU_BUILDONLY
+		TORTURE_BUILDONLY=1
 		;;
 	--configs)
 		checkarg --configs "(list of config files)" "$#" "$2" '^[^/]*$' '^--'
@@ -105,6 +105,11 @@ do
 		ds=$2
 		shift
 		;;
+	--defconfig)
+		checkarg --defconfig "defconfigtype" "$#" "$2" '^[^/][^/]*$' '^--'
+		TORTURE_DEFCONFIG=$2
+		shift
+		;;
 	--dryrun)
 		checkarg --dryrun "sched|script" $# "$2" 'sched\|script' '^--'
 		dryrun=$2
@@ -116,11 +121,11 @@ do
 		shift
 		;;
 	--interactive)
-		RCU_QEMU_INTERACTIVE=1; export RCU_QEMU_INTERACTIVE
+		TORTURE_QEMU_INTERACTIVE=1; export TORTURE_QEMU_INTERACTIVE
 		;;
 	--kmake-arg)
 		checkarg --kmake-arg "(kernel make arguments)" $# "$2" '.*' '^error$'
-		RCU_KMAKE_ARG="$2"; export RCU_KMAKE_ARG
+		TORTURE_KMAKE_ARG="$2"
 		shift
 		;;
 	--kversion)
@@ -130,27 +135,20 @@ do
 		;;
 	--mac)
 		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
-		RCU_QEMU_MAC=$2; export RCU_QEMU_MAC
+		TORTURE_QEMU_MAC=$2
 		shift
 		;;
 	--no-initrd)
-		RCU_INITRD=""; export RCU_INITRD
+		TORTURE_INITRD=""; export TORTURE_INITRD
 		;;
 	--qemu-args)
 		checkarg --qemu-args "-qemu args" $# "$2" '^-' '^error'
-		RCU_QEMU_ARG="$2"
+		TORTURE_QEMU_ARG="$2"
 		shift
 		;;
 	--qemu-cmd)
 		checkarg --qemu-cmd "(qemu-system-...)" $# "$2" 'qemu-system-' '^--'
-		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
-		shift
-		;;
-	--relbuilddir)
-		checkarg --relbuilddir "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
-		relbuilddir=$2
-		gotrelbuilddir=1
-		builddir=${KVM}/${relbuilddir}
+		TORTURE_QEMU_CMD="$2"
 		shift
 		;;
 	--results)
@@ -184,30 +182,6 @@ then
 	resdir=$KVM/res
 fi
 
-if test "$dryrun" = ""
-then
-	if ! test -e $resdir
-	then
-		mkdir -p "$resdir" || :
-	fi
-	mkdir $resdir/$ds
-
-	# Be noisy only if running the script.
-	echo Results directory: $resdir/$ds
-	echo $scriptname $args
-
-	touch $resdir/$ds/log
-	echo $scriptname $args >> $resdir/$ds/log
-	echo ${TORTURE_SUITE} > $resdir/$ds/TORTURE_SUITE
-
-	pwd > $resdir/$ds/testid.txt
-	if test -d .git
-	then
-		git status >> $resdir/$ds/testid.txt
-		git rev-parse HEAD >> $resdir/$ds/testid.txt
-	fi
-fi
-
 # Create a file of test-name/#cpus pairs, sorted by decreasing #cpus.
 touch $T/cfgcpu
 for CF in $configs
@@ -274,7 +248,39 @@ END {
 
 # Generate a script to execute the tests in appropriate batches.
 cat << ___EOF___ > $T/script
+CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
+KVM="$KVM"; export KVM
+KVPATH="$KVPATH"; export KVPATH
+PATH="$PATH"; export PATH
+TORTURE_BOOT_IMAGE="$TORTURE_BOOT_IMAGE"; export TORTURE_BOOT_IMAGE
+TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
+TORTURE_DEFCONFIG="$TORTURE_DEFCONFIG"; export TORTURE_DEFCONFIG
+TORTURE_INITRD="$TORTURE_INITRD"; export TORTURE_INITRD
+TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG"; export TORTURE_KMAKE_ARG
+TORTURE_QEMU_CMD="$TORTURE_QEMU_CMD"; export TORTURE_QEMU_CMD
+TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE"; export TORTURE_QEMU_INTERACTIVE
+TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC"; export TORTURE_QEMU_MAC
 TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
+if ! test -e $resdir
+then
+	mkdir -p "$resdir" || :
+fi
+mkdir $resdir/$ds
+echo Results directory: $resdir/$ds
+echo $scriptname $args
+touch $resdir/$ds/log
+echo $scriptname $args >> $resdir/$ds/log
+echo ${TORTURE_SUITE} > $resdir/$ds/TORTURE_SUITE
+pwd > $resdir/$ds/testid.txt
+if test -d .git
+then
+	git status >> $resdir/$ds/testid.txt
+	git rev-parse HEAD >> $resdir/$ds/testid.txt
+	if ! git diff HEAD > $T/git-diff 2>&1
+	then
+		cp $T/git-diff $resdir/$ds
+	fi
+fi
 ___EOF___
 awk < $T/cfgcpu.pack \
 	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
@@ -282,8 +288,8 @@ awk < $T/cfgcpu.pack \
 	-v ncpus=$cpus \
 	-v rd=$resdir/$ds/ \
 	-v dur=$dur \
-	-v RCU_QEMU_ARG=$RCU_QEMU_ARG \
-	-v RCU_BOOTARGS=$RCU_BOOTARGS \
+	-v TORTURE_QEMU_ARG="$TORTURE_QEMU_ARG" \
+	-v TORTURE_BOOTARGS="$TORTURE_BOOTARGS" \
 'BEGIN {
 	i = 0;
 }
@@ -320,7 +326,7 @@ function dump(first, pastlast)
 		print "touch " builddir ".wait";
 		print "mkdir " builddir " > /dev/null 2>&1 || :";
 		print "mkdir " rd cfr[jn] " || :";
-		print "kvm-test-1-run.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " rd cfr[jn]  "/kvm-test-1-run.sh.out 2>&1 &"
+		print "kvm-test-1-run.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" TORTURE_QEMU_ARG "\" \"" TORTURE_BOOTARGS "\" > " rd cfr[jn]  "/kvm-test-1-run.sh.out 2>&1 &"
 		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date`";
 		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date` >> " rd "/log";
 		print "while test -f " builddir ".wait"
@@ -374,28 +380,26 @@ END {
 		dump(first, i);
 }' >> $T/script
 
+cat << ___EOF___ >> $T/script
+echo
+echo
+echo " --- `date` Test summary:"
+echo Results directory: $resdir/$ds
+if test -z "$TORTURE_BUILDONLY"
+then
+	kvm-recheck.sh $resdir/$ds
+fi
+___EOF___
+
 if test "$dryrun" = script
 then
-	# Dump out the script, but define the environment variables that
-	# it needs to run standalone.
-	echo CONFIGFRAG="$CONFIGFRAG; export CONFIGFRAG"
-	echo KVM="$KVM; export KVM"
-	echo KVPATH="$KVPATH; export KVPATH"
-	echo PATH="$PATH; export PATH"
-	echo RCU_BUILDONLY="$RCU_BUILDONLY; export RCU_BUILDONLY"
-	echo RCU_INITRD="$RCU_INITRD; export RCU_INITRD"
-	echo RCU_KMAKE_ARG="$RCU_KMAKE_ARG; export RCU_KMAKE_ARG"
-	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
-	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
-	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
-	echo "mkdir -p "$resdir" || :"
-	echo "mkdir $resdir/$ds"
 	cat $T/script
 	exit 0
 elif test "$dryrun" = sched
 then
 	# Extract the test run schedule from the script.
-	egrep 'start batch|Starting build\.' $T/script |
+	egrep 'Start batch|Starting build\.' $T/script |
+		grep -v ">>" |
 		sed -e 's/:.*$//' -e 's/^echo //'
 	exit 0
 else
@@ -404,9 +408,3 @@ else
 fi
 
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
-
-echo
-echo
-echo " --- `date` Test summary:"
-echo Results directory: $resdir/$ds
-kvm-recheck.sh $resdir/$ds
diff --git a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
similarity index 79%
rename from tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
rename to tools/testing/selftests/rcutorture/bin/parse-torture.sh
index dd0a275..3455560 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
@@ -1,14 +1,14 @@
 #!/bin/sh
 #
-# Check the console output from an rcutorture run for goodness.
+# Check the console output from a torture run for goodness.
 # The "file" is a pathname on the local system, and "title" is
 # a text string for error-message purposes.
 #
-# The file must contain rcutorture output, but can be interspersed
-# with other dmesg text.
+# The file must contain torture output, but can be interspersed
+# with other dmesg text, as in console-log output.
 #
 # Usage:
-#	sh parse-rcutorture.sh file title
+#	sh parse-torture.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
@@ -28,7 +28,7 @@
 #
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
-T=/tmp/parse-rcutorture.sh.$$
+T=/tmp/parse-torture.sh.$$
 file="$1"
 title="$2"
 
@@ -36,13 +36,13 @@ trap 'rm -f $T.seq' 0
 
 . functions.sh
 
-# check for presence of rcutorture.txt file
+# check for presence of torture output file.
 
 if test -f "$file" -a -r "$file"
 then
 	:
 else
-	echo $title unreadable rcutorture.txt file: $file
+	echo $title unreadable torture output file: $file
 	exit 1
 fi
 
@@ -76,9 +76,9 @@ BEGIN	{
 END	{
 	if (badseq) {
 		if (badseqno1 == badseqno2 && badseqno2 == ver)
-			print "RCU GP HANG at " ver " rcutorture stat " badseqnr;
+			print "GP HANG at " ver " torture stat " badseqnr;
 		else
-			print "BAD SEQ " badseqno1 ":" badseqno2 " last:" ver " RCU version " badseqnr;
+			print "BAD SEQ " badseqno1 ":" badseqno2 " last:" ver " version " badseqnr;
 	}
 	}' > $T.seq
 
@@ -91,13 +91,13 @@ then
 		exit 2
 	fi
 else
-	if grep -q RCU_HOTPLUG $file
+	if grep -q "_HOTPLUG:" $file
 	then
 		print_warning HOTPLUG FAILURES $title `cat $T.seq`
 		echo "   " $file
 		exit 3
 	fi
-	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful RCU version messages
+	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful version messages
 	if test -s $T.seq
 	then
 		print_warning $title `cat $T.seq`
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
new file mode 100644
index 0000000..61c8d9c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_LEAF=3
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=y
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
new file mode 100644
index 0000000..3b42b8b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=sched
