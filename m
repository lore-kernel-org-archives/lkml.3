Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCaIRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:17:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47879 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaCaIRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:17:30 -0400
Date: Mon, 31 Mar 2014 10:17:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.15
Message-ID: <20140331081724.GA3193@gmail.com>
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

   # HEAD: 7de700e6806cafa30c70bc84478431a11197a5ea Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

Main changes:

   * Torture-test changes, including refactoring of rcutorture
     and introduction of a vestigial locktorture.

   * Real-time latency fixes.
    
   * Documentation updates.
    
   * Miscellaneous fixes.

 Thanks,

	Ingo

------------------>
Joe Perches (2):
      rcu: Glue ASCII strings together
      rcu: Indentation and spacing fixes.

Paul Bolle (2):
      rcu: Disambiguate CONFIG_RCU_NOCB_CPUs
      rcutorture: Rename TREE_RCU-Kconfig.txt

Paul E. McKenney (70):
      documentation: Document call_rcu() safety mechanisms and limitations
      Documentation/memory-barriers.txt: ACCESS_ONCE() provides cache coherence
      Documentation/memory-barriers.txt: Conditional must use prior load
      Documentation/kernel-per-CPU-kthreads.txt: Workqueue affinity
      Documentation/memory-barriers.txt: Need barriers() for some control dependencies
      documentation: Fix some inconsistencies in RTFP.txt
      rcu: Add ACCESS_ONCE() to ->n_force_qs_lh accesses
      rcu: Stop tracking FSF's postal address
      rcu: Remove ACCESS_ONCE() from jiffies
      rcu: Define rcu_assign_pointer() in terms of smp_store_release()
      fs: Substitute rcu_access_pointer() for rcu_dereference_raw()
      rcu: Optimize rcu_is_nocb_cpu() for RCU_NOCB_CPU_ALL
      rcu: Optimize rcu_needs_cpu() for RCU_NOCB_CPU_ALL
      rcu: Optimize RCU_FAST_NO_HZ for RCU_NOCB_CPU_ALL
      rcutorture: Print grace-period performance statistics
      rcutorture: Print script and arguments to standard output
      rcutorture: Move common boot flags to kvm-test-1-rcu.sh
      rcutorture: Allow kvm-test-1-rcu.sh to pause after build
      rcutorture: Move common qemu flags to kvm-test-1.sh
      rcutorture: Reduce SRCU-N number of CPUs
      rcutorture: Enable concurrent rcutorture runs
      rcutorture: Fix results-directory error message
      rcutorture: Add dryrun capability
      rcutorture: Handle multiple runs of the same test
      rcutorture: Do better bin packing
      rcutorture: Add comments, especially on bin packing.
      rcutorture: Flag tests requiring more CPUs than are available
      rcutorture: Print results directory when dumping results
      rcutorture: Fix checkpatch complaint
      rcutorture: Abstract rcu_torture_random()
      rcutorture: Don't create results directory for dryruns
      rcutorture: Abstract torture_param()
      rcutorture: Rename PRINTK to TOROUT
      rcutorture: Abstract TOROUT_STRING() and friends
      rcutorture: Abstract torture_shutdown_absorb()
      rcutorture: Abstract torture_shuffle()
      rcutorture: Abstract torture_onoff()
      rcutorture: Abstract torture-test initialization
      rcutorture: Abstract torture-test cleanup
      rcutorture: Print dates when doing parallel rcutorture runs
      rcutorture: Abstract torture_shutdown_notify()
      rcutorture: Privatize fullstop
      rcutorture: Add diagnostic for unscheduled system shutdown
      rcutorture: Abstract stutter_wait()
      rcutorture: Apply ACCESS_ONCE() to racy fullstop accesses
      rcutorture: Abstract torture_shutdown()
      rcutorture: Clean up rcu_torture_init() error checking
      rcutorture: Announce task creation
      rcutorture: Fix rcutorture shutdown races
      rcutorture: Fix missing-return bug in rcu_torture_barrier_init()
      rcutorture: Abstract torture_create_kthread()
      rcutorture: Abstract torture_stop_kthread()
      rcutorture: Stop generic kthreads in torture_cleanup()
      rcutorture: Abstract kvm-recheck.sh
      locktorture: Add a lock-torture kernel module
      rcutorture: Add an rcu_busted to test the test
      rcutorture: Create config files for scripted test-the-test testing
      rcutorture: Create CFcommon file for common Kconfig parameters
      rcutorture: Remove RCU dependencies from ver_functions.sh API
      rcutorture: Rename kvm-test-1-rcu.sh
      rcutorture: Introduce "rcu" directory level underneath configs
      locktorture: Add vestigial locktorture configuration
      rcutorture: Gracefully handle NULL cleanup hooks
      locktorture: Add kvm-recheck.sh plug-in for locktorture
      rcutorture: Place kvm-test-1-run.sh output into res directory
      rcutorture: Add a lock_busted to test the test
      rcutorture: Save kvm.sh output to log
      Documentation/memory-barriers.txt: Clarify release/acquire ordering
      notifier: Substitute rcu_access_pointer() for rcu_dereference_raw()
      rcu: Provide grace-period piggybacking API

Paul Gortmaker (2):
      rcu: Fix sparse warning for rcu_expedited from kernel/ksysfs.c
      rcu: Ensure kernel/rcu/rcu.h can be sourced/used stand-alone

Shaibal Dutta (1):
      rcu: Move SRCU grace period work to power efficient workqueue


 Documentation/RCU/RTFP.txt                         | 149 ++-
 Documentation/RCU/checklist.txt                    |  18 +-
 Documentation/kernel-per-CPU-kthreads.txt          |  13 +-
 Documentation/memory-barriers.txt                  | 137 ++-
 fs/file.c                                          |   2 +-
 include/linux/rculist.h                            |  17 +-
 include/linux/rcupdate.h                           |  94 +-
 include/linux/rcutiny.h                            |  20 +-
 include/linux/rcutree.h                            |   8 +-
 include/linux/srcu.h                               |   4 +-
 include/linux/torture.h                            | 100 +++
 kernel/Makefile                                    |   1 +
 kernel/ksysfs.c                                    |   2 +
 kernel/locking/Makefile                            |   1 +
 kernel/locking/locktorture.c                       | 452 ++++++++++
 kernel/notifier.c                                  |   2 +-
 kernel/rcu/Makefile                                |   2 +-
 kernel/rcu/rcu.h                                   |   7 +-
 kernel/rcu/{torture.c => rcutorture.c}             | 996 +++++----------------
 kernel/rcu/srcu.c                                  |  11 +-
 kernel/rcu/tiny.c                                  |   8 +-
 kernel/rcu/tiny_plugin.h                           |   4 +-
 kernel/rcu/tree.c                                  |  80 +-
 kernel/rcu/tree.h                                  |   4 +-
 kernel/rcu/tree_plugin.h                           |  19 +-
 kernel/rcu/tree_trace.c                            |   6 +-
 kernel/rcu/update.c                                |   5 +-
 kernel/torture.c                                   | 719 +++++++++++++++
 lib/Kconfig.debug                                  |  20 +
 .../testing/selftests/rcutorture/bin/functions.sh  |   1 +
 .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |  51 ++
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |  51 ++
 .../selftests/rcutorture/bin/kvm-recheck.sh        |  13 +-
 .../bin/{kvm-test-1-rcu.sh => kvm-test-1-run.sh}   |  53 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 276 +++++-
 .../selftests/rcutorture/configs/lock/BUSTED       |   6 +
 .../selftests/rcutorture/configs/lock/BUSTED.boot  |   1 +
 .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
 .../selftests/rcutorture/configs/lock/CFcommon     |   2 +
 .../selftests/rcutorture/configs/lock/LOCK01       |   6 +
 .../rcutorture/configs/lock/ver_functions.sh       |  43 +
 .../selftests/rcutorture/configs/rcu/BUSTED        |   7 +
 .../selftests/rcutorture/configs/rcu/BUSTED.boot   |   1 +
 .../selftests/rcutorture/configs/{ => rcu}/CFLIST  |   0
 .../selftests/rcutorture/configs/rcu/CFcommon      |   2 +
 .../selftests/rcutorture/configs/{ => rcu}/SRCU-N  |   3 +-
 .../rcutorture/configs/{ => rcu}/SRCU-N.boot       |   0
 .../selftests/rcutorture/configs/{ => rcu}/SRCU-P  |   1 -
 .../rcutorture/configs/{ => rcu}/SRCU-P.boot       |   0
 .../selftests/rcutorture/configs/{ => rcu}/TINY01  |   1 -
 .../selftests/rcutorture/configs/{ => rcu}/TINY02  |   1 -
 .../selftests/rcutorture/configs/{ => rcu}/TREE01  |   1 -
 .../rcutorture/configs/{ => rcu}/TREE01.boot       |   0
 .../selftests/rcutorture/configs/{ => rcu}/TREE02  |   3 +-
 .../selftests/rcutorture/configs/{ => rcu}/TREE03  |   1 -
 .../selftests/rcutorture/configs/{ => rcu}/TREE04  |   1 -
 .../rcutorture/configs/{ => rcu}/TREE04.boot       |   0
 .../selftests/rcutorture/configs/{ => rcu}/TREE05  |   1 -
 .../rcutorture/configs/{ => rcu}/TREE05.boot       |   0
 .../selftests/rcutorture/configs/{ => rcu}/TREE06  |   1 -
 .../selftests/rcutorture/configs/{ => rcu}/TREE07  |   1 -
 .../selftests/rcutorture/configs/{ => rcu}/TREE08  |   1 -
 .../rcutorture/configs/{ => rcu}/TREE08-T          |   1 -
 .../selftests/rcutorture/configs/{ => rcu}/TREE09  |   1 -
 .../rcutorture/configs/{ => rcu}/v0.0/CFLIST       |   0
 .../configs/{ => rcu}/v0.0/N1-S-T-NH-SD-SMP-HP     |   0
 .../configs/{ => rcu}/v0.0/N2-2-t-nh-sd-SMP-hp     |   0
 .../configs/{ => rcu}/v0.0/N3-3-T-nh-SD-SMP-hp     |   0
 .../configs/{ => rcu}/v0.0/N4-A-t-NH-sd-SMP-HP     |   0
 .../configs/{ => rcu}/v0.0/N5-U-T-NH-sd-SMP-hp     |   0
 .../rcutorture/configs/{ => rcu}/v0.0/NT1-nh       |   0
 .../rcutorture/configs/{ => rcu}/v0.0/NT3-NH       |   0
 .../configs/{ => rcu}/v0.0/P1-S-T-NH-SD-SMP-HP     |   0
 .../configs/{ => rcu}/v0.0/P2-2-t-nh-sd-SMP-hp     |   0
 .../configs/{ => rcu}/v0.0/P3-3-T-nh-SD-SMP-hp     |   0
 .../configs/{ => rcu}/v0.0/P4-A-t-NH-sd-SMP-HP     |   0
 .../configs/{ => rcu}/v0.0/P5-U-T-NH-sd-SMP-hp     |   0
 .../rcutorture/configs/{ => rcu}/v0.0/PT1-nh       |   0
 .../rcutorture/configs/{ => rcu}/v0.0/PT2-NH       |   0
 .../configs/{ => rcu}/v0.0/ver_functions.sh        |  22 +-
 .../rcutorture/configs/{ => rcu}/v3.12/CFLIST      |   0
 .../configs/{ => rcu}/v3.12/N1-S-T-NH-SD-SMP-HP    |   0
 .../configs/{ => rcu}/v3.12/N2-2-t-nh-sd-SMP-hp    |   0
 .../configs/{ => rcu}/v3.12/N3-3-T-nh-SD-SMP-hp    |   0
 .../configs/{ => rcu}/v3.12/N4-A-t-NH-sd-SMP-HP    |   0
 .../configs/{ => rcu}/v3.12/N5-U-T-NH-sd-SMP-hp    |   0
 .../configs/{ => rcu}/v3.12/N6---t-nh-SD-smp-hp    |   0
 .../configs/{ => rcu}/v3.12/N7-4-T-NH-SD-SMP-HP    |   0
 .../configs/{ => rcu}/v3.12/N8-2-T-NH-SD-SMP-HP    |   0
 .../rcutorture/configs/{ => rcu}/v3.12/NT1-nh      |   0
 .../rcutorture/configs/{ => rcu}/v3.12/NT3-NH      |   0
 .../configs/{ => rcu}/v3.12/P1-S-T-NH-SD-SMP-HP    |   0
 .../configs/{ => rcu}/v3.12/P2-2-t-nh-sd-SMP-hp    |   0
 .../configs/{ => rcu}/v3.12/P3-3-T-nh-SD-SMP-hp    |   0
 .../configs/{ => rcu}/v3.12/P4-A-t-NH-sd-SMP-HP    |   0
 .../configs/{ => rcu}/v3.12/P5-U-T-NH-sd-SMP-hp    |   0
 .../configs/{ => rcu}/v3.12/P6---t-nh-SD-smp-hp    |   0
 .../configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP    |   0
 .../{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-all        |   0
 .../{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-none       |   0
 .../configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-hp    |   0
 .../rcutorture/configs/{ => rcu}/v3.12/PT1-nh      |   0
 .../rcutorture/configs/{ => rcu}/v3.12/PT2-NH      |   0
 .../rcutorture/configs/{ => rcu}/v3.3/CFLIST       |   0
 .../configs/{ => rcu}/v3.3/N1-S-T-NH-SD-SMP-HP     |   0
 .../configs/{ => rcu}/v3.3/N2-2-t-nh-sd-SMP-hp     |   0
 .../configs/{ => rcu}/v3.3/N3-3-T-nh-SD-SMP-hp     |   0
 .../configs/{ => rcu}/v3.3/N4-A-t-NH-sd-SMP-HP     |   0
 .../configs/{ => rcu}/v3.3/N5-U-T-NH-sd-SMP-hp     |   0
 .../rcutorture/configs/{ => rcu}/v3.3/NT1-nh       |   0
 .../rcutorture/configs/{ => rcu}/v3.3/NT3-NH       |   0
 .../configs/{ => rcu}/v3.3/P1-S-T-NH-SD-SMP-HP     |   0
 .../configs/{ => rcu}/v3.3/P2-2-t-nh-sd-SMP-hp     |   0
 .../configs/{ => rcu}/v3.3/P3-3-T-nh-SD-SMP-hp     |   0
 .../configs/{ => rcu}/v3.3/P4-A-t-NH-sd-SMP-HP     |   0
 .../configs/{ => rcu}/v3.3/P5-U-T-NH-sd-SMP-hp     |   0
 .../rcutorture/configs/{ => rcu}/v3.3/PT1-nh       |   0
 .../rcutorture/configs/{ => rcu}/v3.3/PT2-NH       |   0
 .../configs/{ => rcu/v3.3}/ver_functions.sh        |  28 +-
 .../rcutorture/configs/{ => rcu}/v3.5/CFLIST       |   0
 .../configs/{ => rcu}/v3.5/N1-S-T-NH-SD-SMP-HP     |   0
 .../configs/{ => rcu}/v3.5/N2-2-t-nh-sd-SMP-hp     |   0
 .../configs/{ => rcu}/v3.5/N3-3-T-nh-SD-SMP-hp     |   0
 .../configs/{ => rcu}/v3.5/N4-A-t-NH-sd-SMP-HP     |   0
 .../configs/{ => rcu}/v3.5/N5-U-T-NH-sd-SMP-hp     |   0
 .../rcutorture/configs/{ => rcu}/v3.5/NT1-nh       |   0
 .../rcutorture/configs/{ => rcu}/v3.5/NT3-NH       |   0
 .../configs/{ => rcu}/v3.5/P1-S-T-NH-SD-SMP-HP     |   0
 .../configs/{ => rcu}/v3.5/P2-2-t-nh-sd-SMP-hp     |   0
 .../configs/{ => rcu}/v3.5/P3-3-T-nh-SD-SMP-hp     |   0
 .../configs/{ => rcu}/v3.5/P4-A-t-NH-sd-SMP-HP     |   0
 .../configs/{ => rcu}/v3.5/P5-U-T-NH-sd-SMP-hp     |   0
 .../rcutorture/configs/{ => rcu}/v3.5/PT1-nh       |   0
 .../rcutorture/configs/{ => rcu}/v3.5/PT2-NH       |   0
 .../configs/{ => rcu}/v3.5/ver_functions.sh        |  23 +-
 .../configs/{v3.3 => rcu}/ver_functions.sh         |  26 +-
 .../{TREE_RCU-Kconfig.txt => TREE_RCU-kconfig.txt} |   0
 137 files changed, 2454 insertions(+), 1078 deletions(-)
 create mode 100644 include/linux/torture.h
 create mode 100644 kernel/locking/locktorture.c
 rename kernel/rcu/{torture.c => rcutorture.c} (59%)
 create mode 100644 kernel/torture.c
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
 rename tools/testing/selftests/rcutorture/bin/{kvm-test-1-rcu.sh => kvm-test-1-run.sh} (79%)
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/BUSTED
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/CFcommon
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK01
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/BUSTED
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/CFLIST (100%)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/CFcommon
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-N (75%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-N.boot (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-P (86%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-P.boot (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TINY01 (92%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TINY02 (92%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE01 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE01.boot (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE02 (92%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE03 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE04 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE04.boot (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE05 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE05.boot (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE06 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE07 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE08 (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE08-T (96%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE09 (95%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/CFLIST (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/NT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/NT3-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/PT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/PT2-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/ver_functions.sh (70%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/CFLIST (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N6---t-nh-SD-smp-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N7-4-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N8-2-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/NT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/NT3-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P6---t-nh-SD-smp-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-all (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-none (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/PT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/PT2-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/CFLIST (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/NT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/NT3-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/PT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/PT2-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu/v3.3}/ver_functions.sh (72%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/CFLIST (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/NT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/NT3-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P1-S-T-NH-SD-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P2-2-t-nh-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P3-3-T-nh-SD-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P4-A-t-NH-sd-SMP-HP (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P5-U-T-NH-sd-SMP-hp (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/PT1-nh (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/PT2-NH (100%)
 rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/ver_functions.sh (69%)
 rename tools/testing/selftests/rcutorture/configs/{v3.3 => rcu}/ver_functions.sh (66%)
 rename tools/testing/selftests/rcutorture/doc/{TREE_RCU-Kconfig.txt => TREE_RCU-kconfig.txt} (100%)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 273e654d..2f0fcb2 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -31,6 +31,14 @@ has lapsed, so this approach may be used in non-GPL software, if desired.
 (In contrast, implementation of RCU is permitted only in software licensed
 under either GPL or LGPL.  Sorry!!!)
 
+In 1987, Rashid et al. described lazy TLB-flush [RichardRashid87a].
+At first glance, this has nothing to do with RCU, but nevertheless
+this paper helped inspire the update-side batching used in the later
+RCU implementation in DYNIX/ptx.  In 1988, Barbara Liskov published
+a description of Argus that noted that use of out-of-date values can
+be tolerated in some situations.  Thus, this paper provides some early
+theoretical justification for use of stale data.
+
 In 1990, Pugh [Pugh90] noted that explicitly tracking which threads
 were reading a given data structure permitted deferred free to operate
 in the presence of non-terminating threads.  However, this explicit
@@ -41,11 +49,11 @@ providing a fine-grained locking design, however, it would be interesting
 to see how much of the performance advantage reported in 1990 remains
 today.
 
-At about this same time, Adams [Adams91] described ``chaotic relaxation'',
-where the normal barriers between successive iterations of convergent
-numerical algorithms are relaxed, so that iteration $n$ might use
-data from iteration $n-1$ or even $n-2$.  This introduces error,
-which typically slows convergence and thus increases the number of
+At about this same time, Andrews [Andrews91textbook] described ``chaotic
+relaxation'', where the normal barriers between successive iterations
+of convergent numerical algorithms are relaxed, so that iteration $n$
+might use data from iteration $n-1$ or even $n-2$.  This introduces
+error, which typically slows convergence and thus increases the number of
 iterations required.  However, this increase is sometimes more than made
 up for by a reduction in the number of expensive barrier operations,
 which are otherwise required to synchronize the threads at the end
@@ -55,7 +63,8 @@ is thus inapplicable to most data structures in operating-system kernels.
 
 In 1992, Henry (now Alexia) Massalin completed a dissertation advising
 parallel programmers to defer processing when feasible to simplify
-synchronization.  RCU makes extremely heavy use of this advice.
+synchronization [HMassalinPhD].  RCU makes extremely heavy use of
+this advice.
 
 In 1993, Jacobson [Jacobson93] verbally described what is perhaps the
 simplest deferred-free technique: simply waiting a fixed amount of time
@@ -90,27 +99,29 @@ mechanism, which is quite similar to RCU [Gamsa99].  These operating
 systems made pervasive use of RCU in place of "existence locks", which
 greatly simplifies locking hierarchies and helps avoid deadlocks.
 
-2001 saw the first RCU presentation involving Linux [McKenney01a]
-at OLS.  The resulting abundance of RCU patches was presented the
-following year [McKenney02a], and use of RCU in dcache was first
-described that same year [Linder02a].
+The year 2000 saw an email exchange that would likely have
+led to yet another independent invention of something like RCU
+[RustyRussell2000a,RustyRussell2000b].  Instead, 2001 saw the first
+RCU presentation involving Linux [McKenney01a] at OLS.  The resulting
+abundance of RCU patches was presented the following year [McKenney02a],
+and use of RCU in dcache was first described that same year [Linder02a].
 
 Also in 2002, Michael [Michael02b,Michael02a] presented "hazard-pointer"
 techniques that defer the destruction of data structures to simplify
 non-blocking synchronization (wait-free synchronization, lock-free
 synchronization, and obstruction-free synchronization are all examples of
-non-blocking synchronization).  In particular, this technique eliminates
-locking, reduces contention, reduces memory latency for readers, and
-parallelizes pipeline stalls and memory latency for writers.  However,
-these techniques still impose significant read-side overhead in the
-form of memory barriers.  Researchers at Sun worked along similar lines
-in the same timeframe [HerlihyLM02].  These techniques can be thought
-of as inside-out reference counts, where the count is represented by the
-number of hazard pointers referencing a given data structure rather than
-the more conventional counter field within the data structure itself.
-The key advantage of inside-out reference counts is that they can be
-stored in immortal variables, thus allowing races between access and
-deletion to be avoided.
+non-blocking synchronization).  The corresponding journal article appeared
+in 2004 [MagedMichael04a].  This technique eliminates locking, reduces
+contention, reduces memory latency for readers, and parallelizes pipeline
+stalls and memory latency for writers.  However, these techniques still
+impose significant read-side overhead in the form of memory barriers.
+Researchers at Sun worked along similar lines in the same timeframe
+[HerlihyLM02].  These techniques can be thought of as inside-out reference
+counts, where the count is represented by the number of hazard pointers
+referencing a given data structure rather than the more conventional
+counter field within the data structure itself.  The key advantage
+of inside-out reference counts is that they can be stored in immortal
+variables, thus allowing races between access and deletion to be avoided.
 
 By the same token, RCU can be thought of as a "bulk reference count",
 where some form of reference counter covers all reference by a given CPU
@@ -123,8 +134,10 @@ can be thought of in other terms as well.
 
 In 2003, the K42 group described how RCU could be used to create
 hot-pluggable implementations of operating-system functions [Appavoo03a].
-Later that year saw a paper describing an RCU implementation of System
-V IPC [Arcangeli03], and an introduction to RCU in Linux Journal
+Later that year saw a paper describing an RCU implementation
+of System V IPC [Arcangeli03] (following up on a suggestion by
+Hugh Dickins [Dickins02a] and an implementation by Mingming Cao
+[MingmingCao2002IPCRCU]), and an introduction to RCU in Linux Journal
 [McKenney03a].
 
 2004 has seen a Linux-Journal article on use of RCU in dcache
@@ -383,6 +396,21 @@ for Programming Languages and Operating Systems}"
 }
 }
 
+@phdthesis{HMassalinPhD
+,author="H. Massalin"
+,title="Synthesis: An Efficient Implementation of Fundamental Operating
+System Services"
+,school="Columbia University"
+,address="New York, NY"
+,year="1992"
+,annotation={
+	Mondo optimizing compiler.
+	Wait-free stuff.
+	Good advice: defer work to avoid synchronization.  See page 90
+		(PDF page 106), Section 5.4, fourth bullet point.
+}
+}
+
 @unpublished{Jacobson93
 ,author="Van Jacobson"
 ,title="Avoid Read-Side Locking Via Delayed Free"
@@ -671,6 +699,20 @@ Orran Krieger and Rusty Russell and Dipankar Sarma and Maneesh Soni"
 [Viewed October 18, 2004]"
 }
 
+@conference{Michael02b
+,author="Maged M. Michael"
+,title="High Performance Dynamic Lock-Free Hash Tables and List-Based Sets"
+,Year="2002"
+,Month="August"
+,booktitle="{Proceedings of the 14\textsuperscript{th} Annual ACM
+Symposium on Parallel
+Algorithms and Architecture}"
+,pages="73-82"
+,annotation={
+Like the title says...
+}
+}
+
 @Conference{Linder02a
 ,Author="Hanna Linder and Dipankar Sarma and Maneesh Soni"
 ,Title="Scalability of the Directory Entry Cache"
@@ -727,6 +769,24 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 }
 }
 
+@conference{Michael02a
+,author="Maged M. Michael"
+,title="Safe Memory Reclamation for Dynamic Lock-Free Objects Using Atomic
+Reads and Writes"
+,Year="2002"
+,Month="August"
+,booktitle="{Proceedings of the 21\textsuperscript{st} Annual ACM
+Symposium on Principles of Distributed Computing}"
+,pages="21-30"
+,annotation={
+	Each thread keeps an array of pointers to items that it is
+	currently referencing.	Sort of an inside-out garbage collection
+	mechanism, but one that requires the accessing code to explicitly
+	state its needs.  Also requires read-side memory barriers on
+	most architectures.
+}
+}
+
 @unpublished{Dickins02a
 ,author="Hugh Dickins"
 ,title="Use RCU for System-V IPC"
@@ -735,6 +795,17 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="private communication"
 }
 
+@InProceedings{HerlihyLM02
+,author={Maurice Herlihy and Victor Luchangco and Mark Moir}
+,title="The Repeat Offender Problem: A Mechanism for Supporting Dynamic-Sized,
+Lock-Free Data Structures"
+,booktitle={Proceedings of 16\textsuperscript{th} International
+Symposium on Distributed Computing}
+,year=2002
+,month="October"
+,pages="339-353"
+}
+
 @unpublished{Sarma02b
 ,Author="Dipankar Sarma"
 ,Title="Some dcache\_rcu benchmark numbers"
@@ -749,6 +820,19 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 }
 }
 
+@unpublished{MingmingCao2002IPCRCU
+,Author="Mingming Cao"
+,Title="[PATCH]updated ipc lock patch"
+,month="October"
+,year="2002"
+,note="Available:
+\url{https://lkml.org/lkml/2002/10/24/262}
+[Viewed February 15, 2014]"
+,annotation={
+	Mingming Cao's patch to introduce RCU to SysV IPC.
+}
+}
+
 @unpublished{LinusTorvalds2003a
 ,Author="Linus Torvalds"
 ,Title="Re: {[PATCH]} small fixes in brlock.h"
@@ -982,6 +1066,23 @@ Realtime Applications"
 }
 }
 
+@article{MagedMichael04a
+,author="Maged M. Michael"
+,title="Hazard Pointers: Safe Memory Reclamation for Lock-Free Objects"
+,Year="2004"
+,Month="June"
+,journal="IEEE Transactions on Parallel and Distributed Systems"
+,volume="15"
+,number="6"
+,pages="491-504"
+,url="Available:
+\url{http://www.research.ibm.com/people/m/michael/ieeetpds-2004.pdf}
+[Viewed March 1, 2005]"
+,annotation={
+	New canonical hazard-pointer citation.
+}
+}
+
 @phdthesis{PaulEdwardMcKenneyPhD
 ,author="Paul E. McKenney"
 ,title="Exploiting Deferred Destruction:
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 9126619..9d10d1d 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -256,10 +256,10 @@ over a rather long period of time, but improvements are always welcome!
 		variations on this theme.
 
 	b.	Limiting update rate.  For example, if updates occur only
-		once per hour, then no explicit rate limiting is required,
-		unless your system is already badly broken.  The dcache
-		subsystem takes this approach -- updates are guarded
-		by a global lock, limiting their rate.
+		once per hour, then no explicit rate limiting is
+		required, unless your system is already badly broken.
+		Older versions of the dcache subsystem take this approach,
+		guarding updates with a global lock, limiting their rate.
 
 	c.	Trusted update -- if updates can only be done manually by
 		superuser or some other trusted user, then it might not
@@ -268,7 +268,8 @@ over a rather long period of time, but improvements are always welcome!
 		the machine.
 
 	d.	Use call_rcu_bh() rather than call_rcu(), in order to take
-		advantage of call_rcu_bh()'s faster grace periods.
+		advantage of call_rcu_bh()'s faster grace periods.  (This
+		is only a partial solution, though.)
 
 	e.	Periodically invoke synchronize_rcu(), permitting a limited
 		number of updates per grace period.
@@ -276,6 +277,13 @@ over a rather long period of time, but improvements are always welcome!
 	The same cautions apply to call_rcu_bh(), call_rcu_sched(),
 	call_srcu(), and kfree_rcu().
 
+	Note that although these primitives do take action to avoid memory
+	exhaustion when any given CPU has too many callbacks, a determined
+	user could still exhaust memory.  This is especially the case
+	if a system with a large number of CPUs has been configured to
+	offload all of its RCU callbacks onto a single CPU, or if the
+	system has relatively little free memory.
+
 9.	All RCU list-traversal primitives, which include
 	rcu_dereference(), list_for_each_entry_rcu(), and
 	list_for_each_safe_rcu(), must be either within an RCU read-side
diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 827104f..f3cd299 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -162,7 +162,18 @@ Purpose: Execute workqueue requests
 To reduce its OS jitter, do any of the following:
 1.	Run your workload at a real-time priority, which will allow
 	preempting the kworker daemons.
-2.	Do any of the following needed to avoid jitter that your
+2.	A given workqueue can be made visible in the sysfs filesystem
+	by passing the WQ_SYSFS to that workqueue's alloc_workqueue().
+	Such a workqueue can be confined to a given subset of the
+	CPUs using the /sys/devices/virtual/workqueue/*/cpumask sysfs
+	files.	The set of WQ_SYSFS workqueues can be displayed using
+	"ls sys/devices/virtual/workqueue".  That said, the workqueues
+	maintainer would like to caution people against indiscriminately
+	sprinkling WQ_SYSFS across all the workqueues.	The reason for
+	caution is that it is easy to add WQ_SYSFS, but because sysfs is
+	part of the formal user/kernel API, it can be nearly impossible
+	to remove it, even if its addition was a mistake.
+3.	Do any of the following needed to avoid jitter that your
 	application cannot tolerate:
 	a.	Build your kernel with CONFIG_SLUB=y rather than
 		CONFIG_SLAB=y, thus avoiding the slab allocator's periodic
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 102dc19..11c1d20 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -608,26 +608,30 @@ as follows:
 	b = p;  /* BUG: Compiler can reorder!!! */
 	do_something();
 
-The solution is again ACCESS_ONCE(), which preserves the ordering between
-the load from variable 'a' and the store to variable 'b':
+The solution is again ACCESS_ONCE() and barrier(), which preserves the
+ordering between the load from variable 'a' and the store to variable 'b':
 
 	q = ACCESS_ONCE(a);
 	if (q) {
+		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
+		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something_else();
 	}
 
-You could also use barrier() to prevent the compiler from moving
-the stores to variable 'b', but barrier() would not prevent the
-compiler from proving to itself that a==1 always, so ACCESS_ONCE()
-is also needed.
+The initial ACCESS_ONCE() is required to prevent the compiler from
+proving the value of 'a', and the pair of barrier() invocations are
+required to prevent the compiler from pulling the two identical stores
+to 'b' out from the legs of the "if" statement.
 
 It is important to note that control dependencies absolutely require a
 a conditional.  For example, the following "optimized" version of
-the above example breaks ordering:
+the above example breaks ordering, which is why the barrier() invocations
+are absolutely required if you have identical stores in both legs of
+the "if" statement:
 
 	q = ACCESS_ONCE(a);
 	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
@@ -643,9 +647,11 @@ It is of course legal for the prior load to be part of the conditional,
 for example, as follows:
 
 	if (ACCESS_ONCE(a) > 0) {
+		barrier();
 		ACCESS_ONCE(b) = q / 2;
 		do_something();
 	} else {
+		barrier();
 		ACCESS_ONCE(b) = q / 3;
 		do_something_else();
 	}
@@ -659,9 +665,11 @@ the needed conditional.  For example:
 
 	q = ACCESS_ONCE(a);
 	if (q % MAX) {
+		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
+		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something_else();
 	}
@@ -723,8 +731,13 @@ In summary:
       use smb_rmb(), smp_wmb(), or, in the case of prior stores and
       later loads, smp_mb().
 
+  (*) If both legs of the "if" statement begin with identical stores
+      to the same variable, a barrier() statement is required at the
+      beginning of each leg of the "if" statement.
+
   (*) Control dependencies require at least one run-time conditional
-      between the prior load and the subsequent store.  If the compiler
+      between the prior load and the subsequent store, and this
+      conditional must involve the prior load.  If the compiler
       is able to optimize the conditional away, it will have also
       optimized away the ordering.  Careful use of ACCESS_ONCE() can
       help to preserve the needed conditional.
@@ -1249,6 +1262,23 @@ The ACCESS_ONCE() function can prevent any number of optimizations that,
 while perfectly safe in single-threaded code, can be fatal in concurrent
 code.  Here are some examples of these sorts of optimizations:
 
+ (*) The compiler is within its rights to reorder loads and stores
+     to the same variable, and in some cases, the CPU is within its
+     rights to reorder loads to the same variable.  This means that
+     the following code:
+
+	a[0] = x;
+	a[1] = x;
+
+     Might result in an older value of x stored in a[1] than in a[0].
+     Prevent both the compiler and the CPU from doing this as follows:
+
+	a[0] = ACCESS_ONCE(x);
+	a[1] = ACCESS_ONCE(x);
+
+     In short, ACCESS_ONCE() provides cache coherence for accesses from
+     multiple CPUs to a single variable.
+
  (*) The compiler is within its rights to merge successive loads from
      the same variable.  Such merging can cause the compiler to "optimize"
      the following code:
@@ -1644,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
      Memory operations issued after the ACQUIRE will be completed after the
      ACQUIRE operation has completed.
 
-     Memory operations issued before the ACQUIRE may be completed after the
-     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
-     with a following ACQUIRE, orders prior loads against subsequent stores and
-     stores and prior stores against subsequent stores.  Note that this is
-     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
-     many architectures.
+     Memory operations issued before the ACQUIRE may be completed after
+     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
+     combined with a following ACQUIRE, orders prior loads against
+     subsequent loads and stores and also orders prior stores against
+     subsequent stores.  Note that this is weaker than smp_mb()!  The
+     smp_mb__before_spinlock() primitive is free on many architectures.
 
  (2) RELEASE operation implication:
 
@@ -1694,24 +1724,21 @@ may occur as:
 
 	ACQUIRE M, STORE *B, STORE *A, RELEASE M
 
-This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
-to the same lock variable, but only from the perspective of another CPU not
-holding that lock.
-
-In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
-memory barrier because it is possible for a preceding RELEASE to pass a
-later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
-of the compiler.  Note that deadlocks cannot be introduced by this
-interchange because if such a deadlock threatened, the RELEASE would
-simply complete.
-
-If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
-ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
-will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
-executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
-same variable.  The smp_mb__after_unlock_lock() primitive is free on many
-architectures.  Without smp_mb__after_unlock_lock(), the critical sections
-corresponding to the RELEASE and the ACQUIRE can cross:
+When the ACQUIRE and RELEASE are a lock acquisition and release,
+respectively, this same reordering can occur if the lock's ACQUIRE and
+RELEASE are to the same lock variable, but only from the perspective of
+another CPU not holding that lock.  In short, a ACQUIRE followed by an
+RELEASE may -not- be assumed to be a full memory barrier.
+
+Similarly, the reverse case of a RELEASE followed by an ACQUIRE does not
+imply a full memory barrier.  If it is necessary for a RELEASE-ACQUIRE
+pair to produce a full barrier, the ACQUIRE can be followed by an
+smp_mb__after_unlock_lock() invocation.  This will produce a full barrier
+if either (a) the RELEASE and the ACQUIRE are executed by the same
+CPU or task, or (b) the RELEASE and ACQUIRE act on the same variable.
+The smp_mb__after_unlock_lock() primitive is free on many architectures.
+Without smp_mb__after_unlock_lock(), the CPU's execution of the critical
+sections corresponding to the RELEASE and the ACQUIRE can cross, so that:
 
 	*A = a;
 	RELEASE M
@@ -1722,7 +1749,36 @@ could occur as:
 
 	ACQUIRE N, STORE *B, STORE *A, RELEASE M
 
-With smp_mb__after_unlock_lock(), they cannot, so that:
+It might appear that this reordering could introduce a deadlock.
+However, this cannot happen because if such a deadlock threatened,
+the RELEASE would simply complete, thereby avoiding the deadlock.
+
+	Why does this work?
+
+	One key point is that we are only talking about the CPU doing
+	the reordering, not the compiler.  If the compiler (or, for
+	that matter, the developer) switched the operations, deadlock
+	-could- occur.
+
+	But suppose the CPU reordered the operations.  In this case,
+	the unlock precedes the lock in the assembly code.  The CPU
+	simply elected to try executing the later lock operation first.
+	If there is a deadlock, this lock operation will simply spin (or
+	try to sleep, but more on that later).	The CPU will eventually
+	execute the unlock operation (which preceded the lock operation
+	in the assembly code), which will unravel the potential deadlock,
+	allowing the lock operation to succeed.
+
+	But what if the lock is a sleeplock?  In that case, the code will
+	try to enter the scheduler, where it will eventually encounter
+	a memory barrier, which will force the earlier unlock operation
+	to complete, again unraveling the deadlock.  There might be
+	a sleep-unlock race, but the locking primitive needs to resolve
+	such races properly in any case.
+
+With smp_mb__after_unlock_lock(), the two critical sections cannot overlap.
+For example, with the following code, the store to *A will always be
+seen by other CPUs before the store to *B:
 
 	*A = a;
 	RELEASE M
@@ -1730,13 +1786,18 @@ With smp_mb__after_unlock_lock(), they cannot, so that:
 	smp_mb__after_unlock_lock();
 	*B = b;
 
-will always occur as either of the following:
+The operations will always occur in one of the following orders:
 
-	STORE *A, RELEASE, ACQUIRE, STORE *B
-	STORE *A, ACQUIRE, RELEASE, STORE *B
+	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
+	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
+	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
 
 If the RELEASE and ACQUIRE were instead both operating on the same lock
-variable, only the first of these two alternatives can occur.
+variable, only the first of these alternatives can occur.  In addition,
+the more strongly ordered systems may rule out some of the above orders.
+But in any case, as noted earlier, the smp_mb__after_unlock_lock()
+ensures that the store to *A will always be seen as happening before
+the store to *B.
 
 Locks and semaphores may not provide any guarantee of ordering on UP compiled
 systems, and so cannot be counted on in such a situation to actually achieve
@@ -2757,7 +2818,7 @@ in that order, but, without intervention, the sequence may have almost any
 combination of elements combined or discarded, provided the program's view of
 the world remains consistent.  Note that ACCESS_ONCE() is -not- optional
 in the above example, as there are architectures where a given CPU might
-interchange successive loads to the same location.  On such architectures,
+reorder successive loads to the same location.  On such architectures,
 ACCESS_ONCE() does whatever is necessary to prevent this, for example, on
 Itanium the volatile casts used by ACCESS_ONCE() cause GCC to emit the
 special ld.acq and st.rel instructions that prevent such reordering.
diff --git a/fs/file.c b/fs/file.c
index db25c2b..18f7d27 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -497,7 +497,7 @@ repeat:
 	error = fd;
 #if 1
 	/* Sanity check */
-	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
+	if (rcu_access_pointer(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 	}
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index dbaf990..8183b46 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -247,9 +247,10 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_entry_rcu(ptr, type, member) \
-	({typeof (*ptr) __rcu *__ptr = (typeof (*ptr) __rcu __force *)ptr; \
-	 container_of((typeof(ptr))rcu_dereference_raw(__ptr), type, member); \
-	})
+({ \
+	typeof(*ptr) __rcu *__ptr = (typeof(*ptr) __rcu __force *)ptr; \
+	container_of((typeof(ptr))rcu_dereference_raw(__ptr), type, member); \
+})
 
 /**
  * Where are list_empty_rcu() and list_first_entry_rcu()?
@@ -285,11 +286,11 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_first_or_null_rcu(ptr, type, member) \
-	({struct list_head *__ptr = (ptr); \
-	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
-	  likely(__ptr != __next) ? \
-		list_entry_rcu(__next, type, member) : NULL; \
-	})
+({ \
+	struct list_head *__ptr = (ptr); \
+	struct list_head *__next = ACCESS_ONCE(__ptr->next); \
+	likely(__ptr != __next) ? list_entry_rcu(__next, type, member) : NULL; \
+})
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 72bf3a0..cda2583 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2001
  *
@@ -44,7 +44,9 @@
 #include <linux/debugobjects.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
+extern int rcu_expedited; /* for sysctl */
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
@@ -479,11 +481,9 @@ static inline void rcu_preempt_sleep_check(void)
 	do {								\
 		rcu_preempt_sleep_check();				\
 		rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),	\
-				   "Illegal context switch in RCU-bh"	\
-				   " read-side critical section");	\
+				   "Illegal context switch in RCU-bh read-side critical section"); \
 		rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),	\
-				   "Illegal context switch in RCU-sched"\
-				   " read-side critical section");	\
+				   "Illegal context switch in RCU-sched read-side critical section"); \
 	} while (0)
 
 #else /* #ifdef CONFIG_PROVE_RCU */
@@ -510,43 +510,40 @@ static inline void rcu_preempt_sleep_check(void)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __rcu_access_pointer(p, space) \
-	({ \
-		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_dereference_sparse(p, space); \
-		((typeof(*p) __force __kernel *)(_________p1)); \
-	})
+({ \
+	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
+	rcu_dereference_sparse(p, space); \
+	((typeof(*p) __force __kernel *)(_________p1)); \
+})
 #define __rcu_dereference_check(p, c, space) \
-	({ \
-		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
-				      " usage"); \
-		rcu_dereference_sparse(p, space); \
-		smp_read_barrier_depends(); \
-		((typeof(*p) __force __kernel *)(_________p1)); \
-	})
+({ \
+	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
+	rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
+	rcu_dereference_sparse(p, space); \
+	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
+	((typeof(*p) __force __kernel *)(_________p1)); \
+})
 #define __rcu_dereference_protected(p, c, space) \
-	({ \
-		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected()" \
-				      " usage"); \
-		rcu_dereference_sparse(p, space); \
-		((typeof(*p) __force __kernel *)(p)); \
-	})
+({ \
+	rcu_lockdep_assert(c, "suspicious rcu_dereference_protected() usage"); \
+	rcu_dereference_sparse(p, space); \
+	((typeof(*p) __force __kernel *)(p)); \
+})
 
 #define __rcu_access_index(p, space) \
-	({ \
-		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_dereference_sparse(p, space); \
-		(_________p1); \
-	})
+({ \
+	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	rcu_dereference_sparse(p, space); \
+	(_________p1); \
+})
 #define __rcu_dereference_index_check(p, c) \
-	({ \
-		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c, \
-				   "suspicious rcu_dereference_index_check()" \
-				   " usage"); \
-		smp_read_barrier_depends(); \
-		(_________p1); \
-	})
+({ \
+	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	rcu_lockdep_assert(c, \
+			   "suspicious rcu_dereference_index_check() usage"); \
+	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
+	(_________p1); \
+})
 
 /**
  * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
@@ -585,12 +582,7 @@ static inline void rcu_preempt_sleep_check(void)
  * please be careful when making changes to rcu_assign_pointer() and the
  * other macros that it invokes.
  */
-#define rcu_assign_pointer(p, v) \
-	do { \
-		smp_wmb(); \
-		ACCESS_ONCE(p) = RCU_INITIALIZER(v); \
-	} while (0)
-
+#define rcu_assign_pointer(p, v) smp_store_release(&p, RCU_INITIALIZER(v))
 
 /**
  * rcu_access_pointer() - fetch RCU pointer with no dereferencing
@@ -1015,11 +1007,21 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
-#ifdef CONFIG_RCU_NOCB_CPU
+#if defined(CONFIG_TINY_RCU) || defined(CONFIG_RCU_NOCB_CPU_ALL)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+{
+	*delta_jiffies = ULONG_MAX;
+	return 0;
+}
+#endif /* #if defined(CONFIG_TINY_RCU) || defined(CONFIG_RCU_NOCB_CPU_ALL) */
+
+#if defined(CONFIG_RCU_NOCB_CPU_ALL)
+static inline bool rcu_is_nocb_cpu(int cpu) { return true; }
+#elif defined(CONFIG_RCU_NOCB_CPU)
 bool rcu_is_nocb_cpu(int cpu);
 #else
 static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
-#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+#endif
 
 
 /* Only for use by adaptive-ticks code. */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 6f01771..425c659 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
@@ -27,6 +27,16 @@
 
 #include <linux/cache.h>
 
+static inline unsigned long get_state_synchronize_rcu(void)
+{
+	return 0;
+}
+
+static inline void cond_synchronize_rcu(unsigned long oldstate)
+{
+	might_sleep();
+}
+
 static inline void rcu_barrier_bh(void)
 {
 	wait_rcu_gp(call_rcu_bh);
@@ -68,12 +78,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
-{
-	*delta_jiffies = ULONG_MAX;
-	return 0;
-}
-
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 72137ee..a59ca05 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
@@ -31,7 +31,9 @@
 #define __LINUX_RCUTREE_H
 
 void rcu_note_context_switch(int cpu);
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 void rcu_cpu_stall_reset(void);
 
 /*
@@ -74,6 +76,8 @@ static inline void synchronize_rcu_bh_expedited(void)
 void rcu_barrier(void);
 void rcu_barrier_bh(void);
 void rcu_barrier_sched(void);
+unsigned long get_state_synchronize_rcu(void);
+void cond_synchronize_rcu(unsigned long oldstate);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9b058ee..a2783cb 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (C) IBM Corporation, 2006
  * Copyright (C) Fujitsu, 2012
diff --git a/include/linux/torture.h b/include/linux/torture.h
new file mode 100644
index 0000000..b2e2b46
--- /dev/null
+++ b/include/linux/torture.h
@@ -0,0 +1,100 @@
+/*
+ * Common functions for in-kernel torture tests.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
+ *
+ * Copyright IBM Corporation, 2014
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#ifndef __LINUX_TORTURE_H
+#define __LINUX_TORTURE_H
+
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/seqlock.h>
+#include <linux/lockdep.h>
+#include <linux/completion.h>
+#include <linux/debugobjects.h>
+#include <linux/bug.h>
+#include <linux/compiler.h>
+
+/* Definitions for a non-string torture-test module parameter. */
+#define torture_param(type, name, init, msg) \
+	static type name = init; \
+	module_param(name, type, 0444); \
+	MODULE_PARM_DESC(name, msg);
+
+#define TORTURE_FLAG "-torture:"
+#define TOROUT_STRING(s) \
+	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
+#define VERBOSE_TOROUT_STRING(s) \
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG " %s\n", torture_type, s); } while (0)
+#define VERBOSE_TOROUT_ERRSTRING(s) \
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! %s\n", torture_type, s); } while (0)
+
+/* Definitions for a non-string torture-test module parameter. */
+#define torture_parm(type, name, init, msg) \
+	static type name = init; \
+	module_param(name, type, 0444); \
+	MODULE_PARM_DESC(name, msg);
+
+/* Definitions for online/offline exerciser. */
+int torture_onoff_init(long ooholdoff, long oointerval);
+char *torture_onoff_stats(char *page);
+bool torture_onoff_failures(void);
+
+/* Low-rider random number generator. */
+struct torture_random_state {
+	unsigned long trs_state;
+	long trs_count;
+};
+#define DEFINE_TORTURE_RANDOM(name) struct torture_random_state name = { 0, 0 }
+unsigned long torture_random(struct torture_random_state *trsp);
+
+/* Task shuffler, which causes CPUs to occasionally go idle. */
+void torture_shuffle_task_register(struct task_struct *tp);
+int torture_shuffle_init(long shuffint);
+
+/* Test auto-shutdown handling. */
+void torture_shutdown_absorb(const char *title);
+int torture_shutdown_init(int ssecs, void (*cleanup)(void));
+
+/* Task stuttering, which forces load/no-load transitions. */
+void stutter_wait(const char *title);
+int torture_stutter_init(int s);
+
+/* Initialization and cleanup. */
+void torture_init_begin(char *ttype, bool v, int *runnable);
+void torture_init_end(void);
+bool torture_cleanup(void);
+bool torture_must_stop(void);
+bool torture_must_stop_irq(void);
+void torture_kthread_stopping(char *title);
+int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
+			     char *f, struct task_struct **tp);
+void _torture_stop_kthread(char *m, struct task_struct **tp);
+
+#define torture_create_kthread(n, arg, tp) \
+	_torture_create_kthread(n, (arg), #n, "Creating " #n " task", \
+				"Failed to create " #n, &(tp))
+#define torture_stop_kthread(n, tp) \
+	_torture_stop_kthread("Stopping " #n " task", &(tp))
+
+#endif /* __LINUX_TORTURE_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..5c0e766 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
+obj-$(CONFIG_TORTURE_TEST) += torture.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index d945a94..e660964 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -19,6 +19,8 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 
+#include <linux/rcupdate.h>	/* rcu_expedited */
+
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index baab8e5..a28ea6d 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
 obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
+obj-$(CONFIG_LOCK_TORTURE_TEST) += locktorture.o
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
new file mode 100644
index 0000000..f26b1a1
--- /dev/null
+++ b/kernel/locking/locktorture.c
@@ -0,0 +1,452 @@
+/*
+ * Module-based torture test facility for locking
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
+ *
+ * Copyright (C) IBM Corporation, 2014
+ *
+ * Author: Paul E. McKenney <paulmck@us.ibm.com>
+ *	Based on kernel/rcu/torture.c.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/freezer.h>
+#include <linux/cpu.h>
+#include <linux/delay.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/trace_clock.h>
+#include <asm/byteorder.h>
+#include <linux/torture.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
+
+torture_param(int, nwriters_stress, -1,
+	     "Number of write-locking stress-test threads");
+torture_param(int, onoff_holdoff, 0, "Time after boot before CPU hotplugs (s)");
+torture_param(int, onoff_interval, 0,
+	     "Time between CPU hotplugs (s), 0=disable");
+torture_param(int, shuffle_interval, 3,
+	     "Number of jiffies between shuffles, 0=disable");
+torture_param(int, shutdown_secs, 0, "Shutdown time (j), <= zero to disable.");
+torture_param(int, stat_interval, 60,
+	     "Number of seconds between stats printk()s");
+torture_param(int, stutter, 5, "Number of jiffies to run/halt test, 0=disable");
+torture_param(bool, verbose, true,
+	     "Enable verbose debugging printk()s");
+
+static char *torture_type = "spin_lock";
+module_param(torture_type, charp, 0444);
+MODULE_PARM_DESC(torture_type,
+		 "Type of lock to torture (spin_lock, spin_lock_irq, ...)");
+
+static atomic_t n_lock_torture_errors;
+
+static struct task_struct *stats_task;
+static struct task_struct **writer_tasks;
+
+static int nrealwriters_stress;
+static bool lock_is_write_held;
+
+struct lock_writer_stress_stats {
+	long n_write_lock_fail;
+	long n_write_lock_acquired;
+};
+static struct lock_writer_stress_stats *lwsa;
+
+#if defined(MODULE) || defined(CONFIG_LOCK_TORTURE_TEST_RUNNABLE)
+#define LOCKTORTURE_RUNNABLE_INIT 1
+#else
+#define LOCKTORTURE_RUNNABLE_INIT 0
+#endif
+int locktorture_runnable = LOCKTORTURE_RUNNABLE_INIT;
+module_param(locktorture_runnable, int, 0444);
+MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at boot");
+
+/* Forward reference. */
+static void lock_torture_cleanup(void);
+
+/*
+ * Operations vector for selecting different types of tests.
+ */
+struct lock_torture_ops {
+	void (*init)(void);
+	int (*writelock)(void);
+	void (*write_delay)(struct torture_random_state *trsp);
+	void (*writeunlock)(void);
+	unsigned long flags;
+	const char *name;
+};
+
+static struct lock_torture_ops *cur_ops;
+
+/*
+ * Definitions for lock torture testing.
+ */
+
+static int torture_lock_busted_write_lock(void)
+{
+	return 0;  /* BUGGY, do not use in real life!!! */
+}
+
+static void torture_lock_busted_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_us = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2000 * longdelay_us)))
+		mdelay(longdelay_us);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_lock_busted_write_unlock(void)
+{
+	  /* BUGGY, do not use in real life!!! */
+}
+
+static struct lock_torture_ops lock_busted_ops = {
+	.writelock	= torture_lock_busted_write_lock,
+	.write_delay	= torture_lock_busted_write_delay,
+	.writeunlock	= torture_lock_busted_write_unlock,
+	.name		= "lock_busted"
+};
+
+static DEFINE_SPINLOCK(torture_spinlock);
+
+static int torture_spin_lock_write_lock(void) __acquires(torture_spinlock)
+{
+	spin_lock(&torture_spinlock);
+	return 0;
+}
+
+static void torture_spin_lock_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long shortdelay_us = 2;
+	const unsigned long longdelay_us = 100;
+
+	/* We want a short delay mostly to emulate likely code, and
+	 * we want a long delay occasionally to force massive contention.
+	 */
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2000 * longdelay_us)))
+		mdelay(longdelay_us);
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2 * shortdelay_us)))
+		udelay(shortdelay_us);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_spin_lock_write_unlock(void) __releases(torture_spinlock)
+{
+	spin_unlock(&torture_spinlock);
+}
+
+static struct lock_torture_ops spin_lock_ops = {
+	.writelock	= torture_spin_lock_write_lock,
+	.write_delay	= torture_spin_lock_write_delay,
+	.writeunlock	= torture_spin_lock_write_unlock,
+	.name		= "spin_lock"
+};
+
+static int torture_spin_lock_write_lock_irq(void)
+__acquires(torture_spinlock_irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&torture_spinlock, flags);
+	cur_ops->flags = flags;
+	return 0;
+}
+
+static void torture_lock_spin_write_unlock_irq(void)
+__releases(torture_spinlock)
+{
+	spin_unlock_irqrestore(&torture_spinlock, cur_ops->flags);
+}
+
+static struct lock_torture_ops spin_lock_irq_ops = {
+	.writelock	= torture_spin_lock_write_lock_irq,
+	.write_delay	= torture_spin_lock_write_delay,
+	.writeunlock	= torture_lock_spin_write_unlock_irq,
+	.name		= "spin_lock_irq"
+};
+
+/*
+ * Lock torture writer kthread.  Repeatedly acquires and releases
+ * the lock, checking for duplicate acquisitions.
+ */
+static int lock_torture_writer(void *arg)
+{
+	struct lock_writer_stress_stats *lwsp = arg;
+	static DEFINE_TORTURE_RANDOM(rand);
+
+	VERBOSE_TOROUT_STRING("lock_torture_writer task started");
+	set_user_nice(current, 19);
+
+	do {
+		schedule_timeout_uninterruptible(1);
+		cur_ops->writelock();
+		if (WARN_ON_ONCE(lock_is_write_held))
+			lwsp->n_write_lock_fail++;
+		lock_is_write_held = 1;
+		lwsp->n_write_lock_acquired++;
+		cur_ops->write_delay(&rand);
+		lock_is_write_held = 0;
+		cur_ops->writeunlock();
+		stutter_wait("lock_torture_writer");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("lock_torture_writer");
+	return 0;
+}
+
+/*
+ * Create an lock-torture-statistics message in the specified buffer.
+ */
+static void lock_torture_printk(char *page)
+{
+	bool fail = 0;
+	int i;
+	long max = 0;
+	long min = lwsa[0].n_write_lock_acquired;
+	long long sum = 0;
+
+	for (i = 0; i < nrealwriters_stress; i++) {
+		if (lwsa[i].n_write_lock_fail)
+			fail = true;
+		sum += lwsa[i].n_write_lock_acquired;
+		if (max < lwsa[i].n_write_lock_fail)
+			max = lwsa[i].n_write_lock_fail;
+		if (min > lwsa[i].n_write_lock_fail)
+			min = lwsa[i].n_write_lock_fail;
+	}
+	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
+	page += sprintf(page,
+			"Writes:  Total: %lld  Max/Min: %ld/%ld %s  Fail: %d %s\n",
+			sum, max, min, max / 2 > min ? "???" : "",
+			fail, fail ? "!!!" : "");
+	if (fail)
+		atomic_inc(&n_lock_torture_errors);
+}
+
+/*
+ * Print torture statistics.  Caller must ensure that there is only one
+ * call to this function at a given time!!!  This is normally accomplished
+ * by relying on the module system to only have one copy of the module
+ * loaded, and then by giving the lock_torture_stats kthread full control
+ * (or the init/cleanup functions when lock_torture_stats thread is not
+ * running).
+ */
+static void lock_torture_stats_print(void)
+{
+	int size = nrealwriters_stress * 200 + 8192;
+	char *buf;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		pr_err("lock_torture_stats_print: Out of memory, need: %d",
+		       size);
+		return;
+	}
+	lock_torture_printk(buf);
+	pr_alert("%s", buf);
+	kfree(buf);
+}
+
+/*
+ * Periodically prints torture statistics, if periodic statistics printing
+ * was specified via the stat_interval module parameter.
+ *
+ * No need to worry about fullstop here, since this one doesn't reference
+ * volatile state or register callbacks.
+ */
+static int lock_torture_stats(void *arg)
+{
+	VERBOSE_TOROUT_STRING("lock_torture_stats task started");
+	do {
+		schedule_timeout_interruptible(stat_interval * HZ);
+		lock_torture_stats_print();
+		torture_shutdown_absorb("lock_torture_stats");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("lock_torture_stats");
+	return 0;
+}
+
+static inline void
+lock_torture_print_module_parms(struct lock_torture_ops *cur_ops,
+				const char *tag)
+{
+	pr_alert("%s" TORTURE_FLAG
+		 "--- %s: nwriters_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
+		 torture_type, tag, nrealwriters_stress, stat_interval, verbose,
+		 shuffle_interval, stutter, shutdown_secs,
+		 onoff_interval, onoff_holdoff);
+}
+
+static void lock_torture_cleanup(void)
+{
+	int i;
+
+	if (torture_cleanup())
+		return;
+
+	if (writer_tasks) {
+		for (i = 0; i < nrealwriters_stress; i++)
+			torture_stop_kthread(lock_torture_writer,
+					     writer_tasks[i]);
+		kfree(writer_tasks);
+		writer_tasks = NULL;
+	}
+
+	torture_stop_kthread(lock_torture_stats, stats_task);
+	lock_torture_stats_print();  /* -After- the stats thread is stopped! */
+
+	if (atomic_read(&n_lock_torture_errors))
+		lock_torture_print_module_parms(cur_ops,
+						"End of test: FAILURE");
+	else if (torture_onoff_failures())
+		lock_torture_print_module_parms(cur_ops,
+						"End of test: LOCK_HOTPLUG");
+	else
+		lock_torture_print_module_parms(cur_ops,
+						"End of test: SUCCESS");
+}
+
+static int __init lock_torture_init(void)
+{
+	int i;
+	int firsterr = 0;
+	static struct lock_torture_ops *torture_ops[] = {
+		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
+	};
+
+	torture_init_begin(torture_type, verbose, &locktorture_runnable);
+
+	/* Process args and tell the world that the torturer is on the job. */
+	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
+		cur_ops = torture_ops[i];
+		if (strcmp(torture_type, cur_ops->name) == 0)
+			break;
+	}
+	if (i == ARRAY_SIZE(torture_ops)) {
+		pr_alert("lock-torture: invalid torture type: \"%s\"\n",
+			 torture_type);
+		pr_alert("lock-torture types:");
+		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
+			pr_alert(" %s", torture_ops[i]->name);
+		pr_alert("\n");
+		torture_init_end();
+		return -EINVAL;
+	}
+	if (cur_ops->init)
+		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
+
+	if (nwriters_stress >= 0)
+		nrealwriters_stress = nwriters_stress;
+	else
+		nrealwriters_stress = 2 * num_online_cpus();
+	lock_torture_print_module_parms(cur_ops, "Start of test");
+
+	/* Initialize the statistics so that each run gets its own numbers. */
+
+	lock_is_write_held = 0;
+	lwsa = kmalloc(sizeof(*lwsa) * nrealwriters_stress, GFP_KERNEL);
+	if (lwsa == NULL) {
+		VERBOSE_TOROUT_STRING("lwsa: Out of memory");
+		firsterr = -ENOMEM;
+		goto unwind;
+	}
+	for (i = 0; i < nrealwriters_stress; i++) {
+		lwsa[i].n_write_lock_fail = 0;
+		lwsa[i].n_write_lock_acquired = 0;
+	}
+
+	/* Start up the kthreads. */
+
+	if (onoff_interval > 0) {
+		firsterr = torture_onoff_init(onoff_holdoff * HZ,
+					      onoff_interval * HZ);
+		if (firsterr)
+			goto unwind;
+	}
+	if (shuffle_interval > 0) {
+		firsterr = torture_shuffle_init(shuffle_interval);
+		if (firsterr)
+			goto unwind;
+	}
+	if (shutdown_secs > 0) {
+		firsterr = torture_shutdown_init(shutdown_secs,
+						 lock_torture_cleanup);
+		if (firsterr)
+			goto unwind;
+	}
+	if (stutter > 0) {
+		firsterr = torture_stutter_init(stutter);
+		if (firsterr)
+			goto unwind;
+	}
+
+	writer_tasks = kzalloc(nrealwriters_stress * sizeof(writer_tasks[0]),
+			       GFP_KERNEL);
+	if (writer_tasks == NULL) {
+		VERBOSE_TOROUT_ERRSTRING("writer_tasks: Out of memory");
+		firsterr = -ENOMEM;
+		goto unwind;
+	}
+	for (i = 0; i < nrealwriters_stress; i++) {
+		firsterr = torture_create_kthread(lock_torture_writer, &lwsa[i],
+						  writer_tasks[i]);
+		if (firsterr)
+			goto unwind;
+	}
+	if (stat_interval > 0) {
+		firsterr = torture_create_kthread(lock_torture_stats, NULL,
+						  stats_task);
+		if (firsterr)
+			goto unwind;
+	}
+	torture_init_end();
+	return 0;
+
+unwind:
+	torture_init_end();
+	lock_torture_cleanup();
+	return firsterr;
+}
+
+module_init(lock_torture_init);
+module_exit(lock_torture_cleanup);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2d5cc4c..db4c8b0 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -309,7 +309,7 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	 * racy then it does not matter what the result of the test
 	 * is, we re-check the list after having taken the lock anyway:
 	 */
-	if (rcu_dereference_raw(nh->head)) {
+	if (rcu_access_pointer(nh->head)) {
 		down_read(&nh->rwsem);
 		ret = notifier_call_chain(&nh->head, val, v, nr_to_call,
 					nr_calls);
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
index 01e9ec3..807ccfb 100644
--- a/kernel/rcu/Makefile
+++ b/kernel/rcu/Makefile
@@ -1,5 +1,5 @@
 obj-y += update.o srcu.o
-obj-$(CONFIG_RCU_TORTURE_TEST) += torture.o
+obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += tree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += tree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += tree_trace.o
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 79c3877..bfda272 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2011
  *
@@ -23,6 +23,7 @@
 #ifndef __LINUX_RCU_H
 #define __LINUX_RCU_H
 
+#include <trace/events/rcu.h>
 #ifdef CONFIG_RCU_TRACE
 #define RCU_TRACE(stmt) stmt
 #else /* #ifdef CONFIG_RCU_TRACE */
@@ -116,8 +117,6 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 	}
 }
 
-extern int rcu_expedited;
-
 #ifdef CONFIG_RCU_STALL_COMMON
 
 extern int rcu_cpu_stall_suppress;
diff --git a/kernel/rcu/torture.c b/kernel/rcu/rcutorture.c
similarity index 59%
rename from kernel/rcu/torture.c
rename to kernel/rcu/rcutorture.c
index 732f8ae..f59d485 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/rcutorture.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (C) IBM Corporation, 2005, 2006
  *
@@ -48,110 +48,58 @@
 #include <linux/slab.h>
 #include <linux/trace_clock.h>
 #include <asm/byteorder.h>
+#include <linux/torture.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
 
-MODULE_ALIAS("rcutorture");
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "rcutorture."
-
-static int fqs_duration;
-module_param(fqs_duration, int, 0444);
-MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us), 0 to disable");
-static int fqs_holdoff;
-module_param(fqs_holdoff, int, 0444);
-MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
-static int fqs_stutter = 3;
-module_param(fqs_stutter, int, 0444);
-MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
-static bool gp_exp;
-module_param(gp_exp, bool, 0444);
-MODULE_PARM_DESC(gp_exp, "Use expedited GP wait primitives");
-static bool gp_normal;
-module_param(gp_normal, bool, 0444);
-MODULE_PARM_DESC(gp_normal, "Use normal (non-expedited) GP wait primitives");
-static int irqreader = 1;
-module_param(irqreader, int, 0444);
-MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
-static int n_barrier_cbs;
-module_param(n_barrier_cbs, int, 0444);
-MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
-static int nfakewriters = 4;
-module_param(nfakewriters, int, 0444);
-MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-static int nreaders = -1;
-module_param(nreaders, int, 0444);
-MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
-static int object_debug;
-module_param(object_debug, int, 0444);
-MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
-static int onoff_holdoff;
-module_param(onoff_holdoff, int, 0444);
-MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
-static int onoff_interval;
-module_param(onoff_interval, int, 0444);
-MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
-static int shuffle_interval = 3;
-module_param(shuffle_interval, int, 0444);
-MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
-static int shutdown_secs;
-module_param(shutdown_secs, int, 0444);
-MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), <= zero to disable.");
-static int stall_cpu;
-module_param(stall_cpu, int, 0444);
-MODULE_PARM_DESC(stall_cpu, "Stall duration (s), zero to disable.");
-static int stall_cpu_holdoff = 10;
-module_param(stall_cpu_holdoff, int, 0444);
-MODULE_PARM_DESC(stall_cpu_holdoff, "Time to wait before starting stall (s).");
-static int stat_interval = 60;
-module_param(stat_interval, int, 0644);
-MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
-static int stutter = 5;
-module_param(stutter, int, 0444);
-MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
-static int test_boost = 1;
-module_param(test_boost, int, 0444);
-MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
-static int test_boost_duration = 4;
-module_param(test_boost_duration, int, 0444);
-MODULE_PARM_DESC(test_boost_duration, "Duration of each boost test, seconds.");
-static int test_boost_interval = 7;
-module_param(test_boost_interval, int, 0444);
-MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
-static bool test_no_idle_hz = true;
-module_param(test_no_idle_hz, bool, 0444);
-MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
+
+torture_param(int, fqs_duration, 0,
+	      "Duration of fqs bursts (us), 0 to disable");
+torture_param(int, fqs_holdoff, 0, "Holdoff time within fqs bursts (us)");
+torture_param(int, fqs_stutter, 3, "Wait time between fqs bursts (s)");
+torture_param(bool, gp_exp, false, "Use expedited GP wait primitives");
+torture_param(bool, gp_normal, false,
+	     "Use normal (non-expedited) GP wait primitives");
+torture_param(int, irqreader, 1, "Allow RCU readers from irq handlers");
+torture_param(int, n_barrier_cbs, 0,
+	     "# of callbacks/kthreads for barrier testing");
+torture_param(int, nfakewriters, 4, "Number of RCU fake writer threads");
+torture_param(int, nreaders, -1, "Number of RCU reader threads");
+torture_param(int, object_debug, 0,
+	     "Enable debug-object double call_rcu() testing");
+torture_param(int, onoff_holdoff, 0, "Time after boot before CPU hotplugs (s)");
+torture_param(int, onoff_interval, 0,
+	     "Time between CPU hotplugs (s), 0=disable");
+torture_param(int, shuffle_interval, 3, "Number of seconds between shuffles");
+torture_param(int, shutdown_secs, 0, "Shutdown time (s), <= zero to disable.");
+torture_param(int, stall_cpu, 0, "Stall duration (s), zero to disable.");
+torture_param(int, stall_cpu_holdoff, 10,
+	     "Time to wait before starting stall (s).");
+torture_param(int, stat_interval, 60,
+	     "Number of seconds between stats printk()s");
+torture_param(int, stutter, 5, "Number of seconds to run/halt test");
+torture_param(int, test_boost, 1, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
+torture_param(int, test_boost_duration, 4,
+	     "Duration of each boost test, seconds.");
+torture_param(int, test_boost_interval, 7,
+	     "Interval between boost tests, seconds.");
+torture_param(bool, test_no_idle_hz, true,
+	     "Test support for tickless idle CPUs");
+torture_param(bool, verbose, true,
+	     "Enable verbose debugging printk()s");
+
 static char *torture_type = "rcu";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
-static bool verbose;
-module_param(verbose, bool, 0444);
-MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
-
-#define TORTURE_FLAG "-torture:"
-#define PRINTK_STRING(s) \
-	do { pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
-#define VERBOSE_PRINTK_STRING(s) \
-	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
-#define VERBOSE_PRINTK_ERRSTRING(s) \
-	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
 static int nrealreaders;
 static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
 static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
-static struct task_struct *shuffler_task;
-static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
-static struct task_struct *shutdown_task;
-#ifdef CONFIG_HOTPLUG_CPU
-static struct task_struct *onoff_task;
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static struct task_struct *stall_task;
 static struct task_struct **barrier_cbs_tasks;
 static struct task_struct *barrier_task;
@@ -170,10 +118,10 @@ static struct rcu_torture __rcu *rcu_torture_current;
 static unsigned long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
-static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
-	{ 0 };
-static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_batch) =
-	{ 0 };
+static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1],
+		      rcu_torture_count) = { 0 };
+static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1],
+		      rcu_torture_batch) = { 0 };
 static atomic_t rcu_torture_wcount[RCU_TORTURE_PIPE_LEN + 1];
 static atomic_t n_rcu_torture_alloc;
 static atomic_t n_rcu_torture_alloc_fail;
@@ -186,22 +134,9 @@ static long n_rcu_torture_boost_rterror;
 static long n_rcu_torture_boost_failure;
 static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
-static long n_offline_attempts;
-static long n_offline_successes;
-static unsigned long sum_offline;
-static int min_offline = -1;
-static int max_offline;
-static long n_online_attempts;
-static long n_online_successes;
-static unsigned long sum_online;
-static int min_online = -1;
-static int max_online;
 static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
-static cpumask_var_t shuffle_tmp_mask;
-
-static int stutter_pause_test;
 
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
@@ -232,7 +167,6 @@ static u64 notrace rcu_trace_clock_local(void)
 }
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
-static unsigned long shutdown_time;	/* jiffies to system shutdown. */
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
@@ -242,51 +176,6 @@ static atomic_t barrier_cbs_invoked;	/* Barrier callbacks invoked. */
 static wait_queue_head_t *barrier_cbs_wq; /* Coordinate barrier testing. */
 static DECLARE_WAIT_QUEUE_HEAD(barrier_wq);
 
-/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
-
-#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
-#define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
-#define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
-static int fullstop = FULLSTOP_RMMOD;
-/*
- * Protect fullstop transitions and spawning of kthreads.
- */
-static DEFINE_MUTEX(fullstop_mutex);
-
-/* Forward reference. */
-static void rcu_torture_cleanup(void);
-
-/*
- * Detect and respond to a system shutdown.
- */
-static int
-rcutorture_shutdown_notify(struct notifier_block *unused1,
-			   unsigned long unused2, void *unused3)
-{
-	mutex_lock(&fullstop_mutex);
-	if (fullstop == FULLSTOP_DONTSTOP)
-		fullstop = FULLSTOP_SHUTDOWN;
-	else
-		pr_warn(/* but going down anyway, so... */
-		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
-	mutex_unlock(&fullstop_mutex);
-	return NOTIFY_DONE;
-}
-
-/*
- * Absorb kthreads into a kernel function that won't return, so that
- * they won't ever access module text or data again.
- */
-static void rcutorture_shutdown_absorb(const char *title)
-{
-	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
-		pr_notice(
-		       "rcutorture thread %s parking due to system shutdown\n",
-		       title);
-		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
-	}
-}
-
 /*
  * Allocate an element from the rcu_tortures pool.
  */
@@ -320,44 +209,6 @@ rcu_torture_free(struct rcu_torture *p)
 	spin_unlock_bh(&rcu_torture_lock);
 }
 
-struct rcu_random_state {
-	unsigned long rrs_state;
-	long rrs_count;
-};
-
-#define RCU_RANDOM_MULT 39916801  /* prime */
-#define RCU_RANDOM_ADD	479001701 /* prime */
-#define RCU_RANDOM_REFRESH 10000
-
-#define DEFINE_RCU_RANDOM(name) struct rcu_random_state name = { 0, 0 }
-
-/*
- * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from cpu_clock().
- */
-static unsigned long
-rcu_random(struct rcu_random_state *rrsp)
-{
-	if (--rrsp->rrs_count < 0) {
-		rrsp->rrs_state += (unsigned long)local_clock();
-		rrsp->rrs_count = RCU_RANDOM_REFRESH;
-	}
-	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
-	return swahw32(rrsp->rrs_state);
-}
-
-static void
-rcu_stutter_wait(const char *title)
-{
-	while (stutter_pause_test || !rcutorture_runnable) {
-		if (rcutorture_runnable)
-			schedule_timeout_interruptible(1);
-		else
-			schedule_timeout_interruptible(round_jiffies_relative(HZ));
-		rcutorture_shutdown_absorb(title);
-	}
-}
-
 /*
  * Operations vector for selecting different types of tests.
  */
@@ -365,7 +216,7 @@ rcu_stutter_wait(const char *title)
 struct rcu_torture_ops {
 	void (*init)(void);
 	int (*readlock)(void);
-	void (*read_delay)(struct rcu_random_state *rrsp);
+	void (*read_delay)(struct torture_random_state *rrsp);
 	void (*readunlock)(int idx);
 	int (*completed)(void);
 	void (*deferred_free)(struct rcu_torture *p);
@@ -392,7 +243,7 @@ static int rcu_torture_read_lock(void) __acquires(RCU)
 	return 0;
 }
 
-static void rcu_read_delay(struct rcu_random_state *rrsp)
+static void rcu_read_delay(struct torture_random_state *rrsp)
 {
 	const unsigned long shortdelay_us = 200;
 	const unsigned long longdelay_ms = 50;
@@ -401,12 +252,13 @@ static void rcu_read_delay(struct rcu_random_state *rrsp)
 	 * period, and we want a long delay occasionally to trigger
 	 * force_quiescent_state. */
 
-	if (!(rcu_random(rrsp) % (nrealreaders * 2000 * longdelay_ms)))
+	if (!(torture_random(rrsp) % (nrealreaders * 2000 * longdelay_ms)))
 		mdelay(longdelay_ms);
-	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
+	if (!(torture_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
 		udelay(shortdelay_us);
 #ifdef CONFIG_PREEMPT
-	if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
+	if (!preempt_count() &&
+	    !(torture_random(rrsp) % (nrealreaders * 20000)))
 		preempt_schedule();  /* No QS if preempt_disable() in effect */
 #endif
 }
@@ -427,7 +279,7 @@ rcu_torture_cb(struct rcu_head *p)
 	int i;
 	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
-	if (fullstop != FULLSTOP_DONTSTOP) {
+	if (torture_must_stop_irq()) {
 		/* Test is ending, just drop callbacks on the floor. */
 		/* The next initialization will pick up the pieces. */
 		return;
@@ -520,6 +372,48 @@ static struct rcu_torture_ops rcu_bh_ops = {
 };
 
 /*
+ * Don't even think about trying any of these in real life!!!
+ * The names includes "busted", and they really means it!
+ * The only purpose of these functions is to provide a buggy RCU
+ * implementation to make sure that rcutorture correctly emits
+ * buggy-RCU error messages.
+ */
+static void rcu_busted_torture_deferred_free(struct rcu_torture *p)
+{
+	/* This is a deliberate bug for testing purposes only! */
+	rcu_torture_cb(&p->rtort_rcu);
+}
+
+static void synchronize_rcu_busted(void)
+{
+	/* This is a deliberate bug for testing purposes only! */
+}
+
+static void
+call_rcu_busted(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	/* This is a deliberate bug for testing purposes only! */
+	func(head);
+}
+
+static struct rcu_torture_ops rcu_busted_ops = {
+	.init		= rcu_sync_torture_init,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_no_completed,
+	.deferred_free	= rcu_busted_torture_deferred_free,
+	.sync		= synchronize_rcu_busted,
+	.exp_sync	= synchronize_rcu_busted,
+	.call		= call_rcu_busted,
+	.cb_barrier	= NULL,
+	.fqs		= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_busted"
+};
+
+/*
  * Definitions for srcu torture testing.
  */
 
@@ -530,7 +424,7 @@ static int srcu_torture_read_lock(void) __acquires(&srcu_ctl)
 	return srcu_read_lock(&srcu_ctl);
 }
 
-static void srcu_read_delay(struct rcu_random_state *rrsp)
+static void srcu_read_delay(struct torture_random_state *rrsp)
 {
 	long delay;
 	const long uspertick = 1000000 / HZ;
@@ -538,7 +432,8 @@ static void srcu_read_delay(struct rcu_random_state *rrsp)
 
 	/* We want there to be long-running readers, but not all the time. */
 
-	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay * uspertick);
+	delay = torture_random(rrsp) %
+		(nrealreaders * 2 * longdelay * uspertick);
 	if (!delay)
 		schedule_timeout_interruptible(longdelay);
 	else
@@ -677,12 +572,12 @@ static int rcu_torture_boost(void *arg)
 	struct rcu_boost_inflight rbi = { .inflight = 0 };
 	struct sched_param sp;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_boost started");
+	VERBOSE_TOROUT_STRING("rcu_torture_boost started");
 
 	/* Set real-time priority. */
 	sp.sched_priority = 1;
 	if (sched_setscheduler(current, SCHED_FIFO, &sp) < 0) {
-		VERBOSE_PRINTK_STRING("rcu_torture_boost RT prio failed!");
+		VERBOSE_TOROUT_STRING("rcu_torture_boost RT prio failed!");
 		n_rcu_torture_boost_rterror++;
 	}
 
@@ -693,9 +588,8 @@ static int rcu_torture_boost(void *arg)
 		oldstarttime = boost_starttime;
 		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
 			schedule_timeout_interruptible(oldstarttime - jiffies);
-			rcu_stutter_wait("rcu_torture_boost");
-			if (kthread_should_stop() ||
-			    fullstop != FULLSTOP_DONTSTOP)
+			stutter_wait("rcu_torture_boost");
+			if (torture_must_stop())
 				goto checkwait;
 		}
 
@@ -710,15 +604,14 @@ static int rcu_torture_boost(void *arg)
 				call_rcu(&rbi.rcu, rcu_torture_boost_cb);
 				if (jiffies - call_rcu_time >
 					 test_boost_duration * HZ - HZ / 2) {
-					VERBOSE_PRINTK_STRING("rcu_torture_boost boosting failed");
+					VERBOSE_TOROUT_STRING("rcu_torture_boost boosting failed");
 					n_rcu_torture_boost_failure++;
 				}
 				call_rcu_time = jiffies;
 			}
 			cond_resched();
-			rcu_stutter_wait("rcu_torture_boost");
-			if (kthread_should_stop() ||
-			    fullstop != FULLSTOP_DONTSTOP)
+			stutter_wait("rcu_torture_boost");
+			if (torture_must_stop())
 				goto checkwait;
 		}
 
@@ -742,16 +635,17 @@ static int rcu_torture_boost(void *arg)
 		}
 
 		/* Go do the stutter. */
-checkwait:	rcu_stutter_wait("rcu_torture_boost");
-	} while (!kthread_should_stop() && fullstop  == FULLSTOP_DONTSTOP);
+checkwait:	stutter_wait("rcu_torture_boost");
+	} while (!torture_must_stop());
 
 	/* Clean up and exit. */
-	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_boost");
-	while (!kthread_should_stop() || rbi.inflight)
+	while (!kthread_should_stop() || rbi.inflight) {
+		torture_shutdown_absorb("rcu_torture_boost");
 		schedule_timeout_uninterruptible(1);
+	}
 	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
 	destroy_rcu_head_on_stack(&rbi.rcu);
+	torture_kthread_stopping("rcu_torture_boost");
 	return 0;
 }
 
@@ -766,7 +660,7 @@ rcu_torture_fqs(void *arg)
 	unsigned long fqs_resume_time;
 	int fqs_burst_remaining;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_fqs task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_fqs task started");
 	do {
 		fqs_resume_time = jiffies + fqs_stutter * HZ;
 		while (ULONG_CMP_LT(jiffies, fqs_resume_time) &&
@@ -780,12 +674,9 @@ rcu_torture_fqs(void *arg)
 			udelay(fqs_holdoff);
 			fqs_burst_remaining -= fqs_holdoff;
 		}
-		rcu_stutter_wait("rcu_torture_fqs");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_fqs task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_fqs");
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+		stutter_wait("rcu_torture_fqs");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("rcu_torture_fqs");
 	return 0;
 }
 
@@ -802,9 +693,9 @@ rcu_torture_writer(void *arg)
 	struct rcu_torture *rp;
 	struct rcu_torture *rp1;
 	struct rcu_torture *old_rp;
-	static DEFINE_RCU_RANDOM(rand);
+	static DEFINE_TORTURE_RANDOM(rand);
 
-	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
 
 	do {
@@ -813,7 +704,7 @@ rcu_torture_writer(void *arg)
 		if (rp == NULL)
 			continue;
 		rp->rtort_pipe_count = 0;
-		udelay(rcu_random(&rand) & 0x3ff);
+		udelay(torture_random(&rand) & 0x3ff);
 		old_rp = rcu_dereference_check(rcu_torture_current,
 					       current == writer_task);
 		rp->rtort_mbtest = 1;
@@ -826,7 +717,7 @@ rcu_torture_writer(void *arg)
 			atomic_inc(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
 			if (gp_normal == gp_exp)
-				exp = !!(rcu_random(&rand) & 0x80);
+				exp = !!(torture_random(&rand) & 0x80);
 			else
 				exp = gp_exp;
 			if (!exp) {
@@ -852,12 +743,9 @@ rcu_torture_writer(void *arg)
 			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
-		rcu_stutter_wait("rcu_torture_writer");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_writer");
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+		stutter_wait("rcu_torture_writer");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("rcu_torture_writer");
 	return 0;
 }
 
@@ -868,19 +756,19 @@ rcu_torture_writer(void *arg)
 static int
 rcu_torture_fakewriter(void *arg)
 {
-	DEFINE_RCU_RANDOM(rand);
+	DEFINE_TORTURE_RANDOM(rand);
 
-	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
 
 	do {
-		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
-		udelay(rcu_random(&rand) & 0x3ff);
+		schedule_timeout_uninterruptible(1 + torture_random(&rand)%10);
+		udelay(torture_random(&rand) & 0x3ff);
 		if (cur_ops->cb_barrier != NULL &&
-		    rcu_random(&rand) % (nfakewriters * 8) == 0) {
+		    torture_random(&rand) % (nfakewriters * 8) == 0) {
 			cur_ops->cb_barrier();
 		} else if (gp_normal == gp_exp) {
-			if (rcu_random(&rand) & 0x80)
+			if (torture_random(&rand) & 0x80)
 				cur_ops->sync();
 			else
 				cur_ops->exp_sync();
@@ -889,13 +777,10 @@ rcu_torture_fakewriter(void *arg)
 		} else {
 			cur_ops->exp_sync();
 		}
-		rcu_stutter_wait("rcu_torture_fakewriter");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+		stutter_wait("rcu_torture_fakewriter");
+	} while (!torture_must_stop());
 
-	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_fakewriter");
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+	torture_kthread_stopping("rcu_torture_fakewriter");
 	return 0;
 }
 
@@ -921,7 +806,7 @@ static void rcu_torture_timer(unsigned long unused)
 	int idx;
 	int completed;
 	int completed_end;
-	static DEFINE_RCU_RANDOM(rand);
+	static DEFINE_TORTURE_RANDOM(rand);
 	static DEFINE_SPINLOCK(rand_lock);
 	struct rcu_torture *p;
 	int pipe_count;
@@ -980,13 +865,13 @@ rcu_torture_reader(void *arg)
 	int completed;
 	int completed_end;
 	int idx;
-	DEFINE_RCU_RANDOM(rand);
+	DEFINE_TORTURE_RANDOM(rand);
 	struct rcu_torture *p;
 	int pipe_count;
 	struct timer_list t;
 	unsigned long long ts;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
 	if (irqreader && cur_ops->irq_capable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
@@ -1034,14 +919,11 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
-		rcu_stutter_wait("rcu_torture_reader");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_reader");
+		stutter_wait("rcu_torture_reader");
+	} while (!torture_must_stop());
 	if (irqreader && cur_ops->irq_capable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+	torture_kthread_stopping("rcu_torture_reader");
 	return 0;
 }
 
@@ -1083,13 +965,7 @@ rcu_torture_printk(char *page)
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	page += sprintf(page,
-		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
-		       n_online_successes, n_online_attempts,
-		       n_offline_successes, n_offline_attempts,
-		       min_online, max_online,
-		       min_offline, max_offline,
-		       sum_online, sum_offline, HZ);
+	page = torture_onoff_stats(page);
 	page += sprintf(page, "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
@@ -1150,123 +1026,17 @@ rcu_torture_stats_print(void)
 /*
  * Periodically prints torture statistics, if periodic statistics printing
  * was specified via the stat_interval module parameter.
- *
- * No need to worry about fullstop here, since this one doesn't reference
- * volatile state or register callbacks.
  */
 static int
 rcu_torture_stats(void *arg)
 {
-	VERBOSE_PRINTK_STRING("rcu_torture_stats task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_stats task started");
 	do {
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
-		rcutorture_shutdown_absorb("rcu_torture_stats");
-	} while (!kthread_should_stop());
-	VERBOSE_PRINTK_STRING("rcu_torture_stats task stopping");
-	return 0;
-}
-
-static int rcu_idle_cpu;	/* Force all torture tasks off this CPU */
-
-/* Shuffle tasks such that we allow @rcu_idle_cpu to become idle. A special case
- * is when @rcu_idle_cpu = -1, when we allow the tasks to run on all CPUs.
- */
-static void rcu_torture_shuffle_tasks(void)
-{
-	int i;
-
-	cpumask_setall(shuffle_tmp_mask);
-	get_online_cpus();
-
-	/* No point in shuffling if there is only one online CPU (ex: UP) */
-	if (num_online_cpus() == 1) {
-		put_online_cpus();
-		return;
-	}
-
-	if (rcu_idle_cpu != -1)
-		cpumask_clear_cpu(rcu_idle_cpu, shuffle_tmp_mask);
-
-	set_cpus_allowed_ptr(current, shuffle_tmp_mask);
-
-	if (reader_tasks) {
-		for (i = 0; i < nrealreaders; i++)
-			if (reader_tasks[i])
-				set_cpus_allowed_ptr(reader_tasks[i],
-						     shuffle_tmp_mask);
-	}
-	if (fakewriter_tasks) {
-		for (i = 0; i < nfakewriters; i++)
-			if (fakewriter_tasks[i])
-				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     shuffle_tmp_mask);
-	}
-	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, shuffle_tmp_mask);
-	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, shuffle_tmp_mask);
-	if (stutter_task)
-		set_cpus_allowed_ptr(stutter_task, shuffle_tmp_mask);
-	if (fqs_task)
-		set_cpus_allowed_ptr(fqs_task, shuffle_tmp_mask);
-	if (shutdown_task)
-		set_cpus_allowed_ptr(shutdown_task, shuffle_tmp_mask);
-#ifdef CONFIG_HOTPLUG_CPU
-	if (onoff_task)
-		set_cpus_allowed_ptr(onoff_task, shuffle_tmp_mask);
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-	if (stall_task)
-		set_cpus_allowed_ptr(stall_task, shuffle_tmp_mask);
-	if (barrier_cbs_tasks)
-		for (i = 0; i < n_barrier_cbs; i++)
-			if (barrier_cbs_tasks[i])
-				set_cpus_allowed_ptr(barrier_cbs_tasks[i],
-						     shuffle_tmp_mask);
-	if (barrier_task)
-		set_cpus_allowed_ptr(barrier_task, shuffle_tmp_mask);
-
-	if (rcu_idle_cpu == -1)
-		rcu_idle_cpu = num_online_cpus() - 1;
-	else
-		rcu_idle_cpu--;
-
-	put_online_cpus();
-}
-
-/* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
- * system to become idle at a time and cut off its timer ticks. This is meant
- * to test the support for such tickless idle CPU in RCU.
- */
-static int
-rcu_torture_shuffle(void *arg)
-{
-	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task started");
-	do {
-		schedule_timeout_interruptible(shuffle_interval * HZ);
-		rcu_torture_shuffle_tasks();
-		rcutorture_shutdown_absorb("rcu_torture_shuffle");
-	} while (!kthread_should_stop());
-	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task stopping");
-	return 0;
-}
-
-/* Cause the rcutorture test to "stutter", starting and stopping all
- * threads periodically.
- */
-static int
-rcu_torture_stutter(void *arg)
-{
-	VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
-	do {
-		schedule_timeout_interruptible(stutter * HZ);
-		stutter_pause_test = 1;
-		if (!kthread_should_stop())
-			schedule_timeout_interruptible(stutter * HZ);
-		stutter_pause_test = 0;
-		rcutorture_shutdown_absorb("rcu_torture_stutter");
-	} while (!kthread_should_stop());
-	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
+		torture_shutdown_absorb("rcu_torture_stats");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("rcu_torture_stats");
 	return 0;
 }
 
@@ -1293,10 +1063,6 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, const char *tag)
 		 onoff_interval, onoff_holdoff);
 }
 
-static struct notifier_block rcutorture_shutdown_nb = {
-	.notifier_call = rcutorture_shutdown_notify,
-};
-
 static void rcutorture_booster_cleanup(int cpu)
 {
 	struct task_struct *t;
@@ -1304,14 +1070,12 @@ static void rcutorture_booster_cleanup(int cpu)
 	if (boost_tasks[cpu] == NULL)
 		return;
 	mutex_lock(&boost_mutex);
-	VERBOSE_PRINTK_STRING("Stopping rcu_torture_boost task");
 	t = boost_tasks[cpu];
 	boost_tasks[cpu] = NULL;
 	mutex_unlock(&boost_mutex);
 
 	/* This must be outside of the mutex, otherwise deadlock! */
-	kthread_stop(t);
-	boost_tasks[cpu] = NULL;
+	torture_stop_kthread(rcu_torture_boost, t);
 }
 
 static int rcutorture_booster_init(int cpu)
@@ -1323,13 +1087,13 @@ static int rcutorture_booster_init(int cpu)
 
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
-	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
+	VERBOSE_TOROUT_STRING("Creating rcu_torture_boost task");
 	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
 						  cpu_to_node(cpu),
 						  "rcu_torture_boost");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
-		VERBOSE_PRINTK_STRING("rcu_torture_boost task create failed");
+		VERBOSE_TOROUT_STRING("rcu_torture_boost task create failed");
 		n_rcu_torture_boost_ktrerror++;
 		boost_tasks[cpu] = NULL;
 		mutex_unlock(&boost_mutex);
@@ -1342,175 +1106,6 @@ static int rcutorture_booster_init(int cpu)
 }
 
 /*
- * Cause the rcutorture test to shutdown the system after the test has
- * run for the time specified by the shutdown_secs module parameter.
- */
-static int
-rcu_torture_shutdown(void *arg)
-{
-	long delta;
-	unsigned long jiffies_snap;
-
-	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
-	jiffies_snap = ACCESS_ONCE(jiffies);
-	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
-	       !kthread_should_stop()) {
-		delta = shutdown_time - jiffies_snap;
-		if (verbose)
-			pr_alert("%s" TORTURE_FLAG
-				 "rcu_torture_shutdown task: %lu jiffies remaining\n",
-				 torture_type, delta);
-		schedule_timeout_interruptible(delta);
-		jiffies_snap = ACCESS_ONCE(jiffies);
-	}
-	if (kthread_should_stop()) {
-		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
-		return 0;
-	}
-
-	/* OK, shut down the system. */
-
-	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task shutting down system");
-	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
-	rcu_torture_cleanup();	/* Get the success/failure message. */
-	kernel_power_off();	/* Shut down the system. */
-	return 0;
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/*
- * Execute random CPU-hotplug operations at the interval specified
- * by the onoff_interval.
- */
-static int
-rcu_torture_onoff(void *arg)
-{
-	int cpu;
-	unsigned long delta;
-	int maxcpu = -1;
-	DEFINE_RCU_RANDOM(rand);
-	int ret;
-	unsigned long starttime;
-
-	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
-	for_each_online_cpu(cpu)
-		maxcpu = cpu;
-	WARN_ON(maxcpu < 0);
-	if (onoff_holdoff > 0) {
-		VERBOSE_PRINTK_STRING("rcu_torture_onoff begin holdoff");
-		schedule_timeout_interruptible(onoff_holdoff * HZ);
-		VERBOSE_PRINTK_STRING("rcu_torture_onoff end holdoff");
-	}
-	while (!kthread_should_stop()) {
-		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
-		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
-			if (verbose)
-				pr_alert("%s" TORTURE_FLAG
-					 "rcu_torture_onoff task: offlining %d\n",
-					 torture_type, cpu);
-			starttime = jiffies;
-			n_offline_attempts++;
-			ret = cpu_down(cpu);
-			if (ret) {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: offline %d failed: errno %d\n",
-						 torture_type, cpu, ret);
-			} else {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: offlined %d\n",
-						 torture_type, cpu);
-				n_offline_successes++;
-				delta = jiffies - starttime;
-				sum_offline += delta;
-				if (min_offline < 0) {
-					min_offline = delta;
-					max_offline = delta;
-				}
-				if (min_offline > delta)
-					min_offline = delta;
-				if (max_offline < delta)
-					max_offline = delta;
-			}
-		} else if (cpu_is_hotpluggable(cpu)) {
-			if (verbose)
-				pr_alert("%s" TORTURE_FLAG
-					 "rcu_torture_onoff task: onlining %d\n",
-					 torture_type, cpu);
-			starttime = jiffies;
-			n_online_attempts++;
-			ret = cpu_up(cpu);
-			if (ret) {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: online %d failed: errno %d\n",
-						 torture_type, cpu, ret);
-			} else {
-				if (verbose)
-					pr_alert("%s" TORTURE_FLAG
-						 "rcu_torture_onoff task: onlined %d\n",
-						 torture_type, cpu);
-				n_online_successes++;
-				delta = jiffies - starttime;
-				sum_online += delta;
-				if (min_online < 0) {
-					min_online = delta;
-					max_online = delta;
-				}
-				if (min_online > delta)
-					min_online = delta;
-				if (max_online < delta)
-					max_online = delta;
-			}
-		}
-		schedule_timeout_interruptible(onoff_interval * HZ);
-	}
-	VERBOSE_PRINTK_STRING("rcu_torture_onoff task stopping");
-	return 0;
-}
-
-static int
-rcu_torture_onoff_init(void)
-{
-	int ret;
-
-	if (onoff_interval <= 0)
-		return 0;
-	onoff_task = kthread_run(rcu_torture_onoff, NULL, "rcu_torture_onoff");
-	if (IS_ERR(onoff_task)) {
-		ret = PTR_ERR(onoff_task);
-		onoff_task = NULL;
-		return ret;
-	}
-	return 0;
-}
-
-static void rcu_torture_onoff_cleanup(void)
-{
-	if (onoff_task == NULL)
-		return;
-	VERBOSE_PRINTK_STRING("Stopping rcu_torture_onoff task");
-	kthread_stop(onoff_task);
-	onoff_task = NULL;
-}
-
-#else /* #ifdef CONFIG_HOTPLUG_CPU */
-
-static int
-rcu_torture_onoff_init(void)
-{
-	return 0;
-}
-
-static void rcu_torture_onoff_cleanup(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
-
-/*
  * CPU-stall kthread.  It waits as specified by stall_cpu_holdoff, then
  * induces a CPU stall for the time specified by stall_cpu.
  */
@@ -1518,11 +1113,11 @@ static int rcu_torture_stall(void *args)
 {
 	unsigned long stop_at;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_stall task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_stall task started");
 	if (stall_cpu_holdoff > 0) {
-		VERBOSE_PRINTK_STRING("rcu_torture_stall begin holdoff");
+		VERBOSE_TOROUT_STRING("rcu_torture_stall begin holdoff");
 		schedule_timeout_interruptible(stall_cpu_holdoff * HZ);
-		VERBOSE_PRINTK_STRING("rcu_torture_stall end holdoff");
+		VERBOSE_TOROUT_STRING("rcu_torture_stall end holdoff");
 	}
 	if (!kthread_should_stop()) {
 		stop_at = get_seconds() + stall_cpu;
@@ -1536,7 +1131,7 @@ static int rcu_torture_stall(void *args)
 		rcu_read_unlock();
 		pr_alert("rcu_torture_stall end.\n");
 	}
-	rcutorture_shutdown_absorb("rcu_torture_stall");
+	torture_shutdown_absorb("rcu_torture_stall");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(10 * HZ);
 	return 0;
@@ -1545,27 +1140,9 @@ static int rcu_torture_stall(void *args)
 /* Spawn CPU-stall kthread, if stall_cpu specified. */
 static int __init rcu_torture_stall_init(void)
 {
-	int ret;
-
 	if (stall_cpu <= 0)
 		return 0;
-	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
-	if (IS_ERR(stall_task)) {
-		ret = PTR_ERR(stall_task);
-		stall_task = NULL;
-		return ret;
-	}
-	return 0;
-}
-
-/* Clean up after the CPU-stall kthread, if one was spawned. */
-static void rcu_torture_stall_cleanup(void)
-{
-	if (stall_task == NULL)
-		return;
-	VERBOSE_PRINTK_STRING("Stopping rcu_torture_stall_task.");
-	kthread_stop(stall_task);
-	stall_task = NULL;
+	return torture_create_kthread(rcu_torture_stall, NULL, stall_task);
 }
 
 /* Callback function for RCU barrier testing. */
@@ -1583,28 +1160,24 @@ static int rcu_torture_barrier_cbs(void *arg)
 	struct rcu_head rcu;
 
 	init_rcu_head_on_stack(&rcu);
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
+	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task started");
 	set_user_nice(current, 19);
 	do {
 		wait_event(barrier_cbs_wq[myid],
 			   (newphase =
 			    ACCESS_ONCE(barrier_phase)) != lastphase ||
-			   kthread_should_stop() ||
-			   fullstop != FULLSTOP_DONTSTOP);
+			   torture_must_stop());
 		lastphase = newphase;
 		smp_mb(); /* ensure barrier_phase load before ->call(). */
-		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
+		if (torture_must_stop())
 			break;
 		cur_ops->call(&rcu, rcu_torture_barrier_cbf);
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
-	while (!kthread_should_stop())
-		schedule_timeout_interruptible(1);
+	} while (!torture_must_stop());
 	cur_ops->cb_barrier();
 	destroy_rcu_head_on_stack(&rcu);
+	torture_kthread_stopping("rcu_torture_barrier_cbs");
 	return 0;
 }
 
@@ -1613,7 +1186,7 @@ static int rcu_torture_barrier(void *arg)
 {
 	int i;
 
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier task starting");
+	VERBOSE_TOROUT_STRING("rcu_torture_barrier task starting");
 	do {
 		atomic_set(&barrier_cbs_invoked, 0);
 		atomic_set(&barrier_cbs_count, n_barrier_cbs);
@@ -1623,9 +1196,8 @@ static int rcu_torture_barrier(void *arg)
 			wake_up(&barrier_cbs_wq[i]);
 		wait_event(barrier_wq,
 			   atomic_read(&barrier_cbs_count) == 0 ||
-			   kthread_should_stop() ||
-			   fullstop != FULLSTOP_DONTSTOP);
-		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
+			   torture_must_stop());
+		if (torture_must_stop())
 			break;
 		n_barrier_attempts++;
 		cur_ops->cb_barrier(); /* Implies smp_mb() for wait_event(). */
@@ -1635,11 +1207,8 @@ static int rcu_torture_barrier(void *arg)
 		}
 		n_barrier_successes++;
 		schedule_timeout_interruptible(HZ / 10);
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
-	VERBOSE_PRINTK_STRING("rcu_torture_barrier task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_barrier");
-	while (!kthread_should_stop())
-		schedule_timeout_interruptible(1);
+	} while (!torture_must_stop());
+	torture_kthread_stopping("rcu_torture_barrier");
 	return 0;
 }
 
@@ -1672,24 +1241,13 @@ static int rcu_torture_barrier_init(void)
 		return -ENOMEM;
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
-		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
-						   (void *)(long)i,
-						   "rcu_torture_barrier_cbs");
-		if (IS_ERR(barrier_cbs_tasks[i])) {
-			ret = PTR_ERR(barrier_cbs_tasks[i]);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create rcu_torture_barrier_cbs");
-			barrier_cbs_tasks[i] = NULL;
+		ret = torture_create_kthread(rcu_torture_barrier_cbs,
+					     (void *)(long)i,
+					     barrier_cbs_tasks[i]);
+		if (ret)
 			return ret;
-		}
 	}
-	barrier_task = kthread_run(rcu_torture_barrier, NULL,
-				   "rcu_torture_barrier");
-	if (IS_ERR(barrier_task)) {
-		ret = PTR_ERR(barrier_task);
-		VERBOSE_PRINTK_ERRSTRING("Failed to create rcu_torture_barrier");
-		barrier_task = NULL;
-	}
-	return 0;
+	return torture_create_kthread(rcu_torture_barrier, NULL, barrier_task);
 }
 
 /* Clean up after RCU barrier testing. */
@@ -1697,19 +1255,11 @@ static void rcu_torture_barrier_cleanup(void)
 {
 	int i;
 
-	if (barrier_task != NULL) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_barrier task");
-		kthread_stop(barrier_task);
-		barrier_task = NULL;
-	}
+	torture_stop_kthread(rcu_torture_barrier, barrier_task);
 	if (barrier_cbs_tasks != NULL) {
-		for (i = 0; i < n_barrier_cbs; i++) {
-			if (barrier_cbs_tasks[i] != NULL) {
-				VERBOSE_PRINTK_STRING("Stopping rcu_torture_barrier_cbs task");
-				kthread_stop(barrier_cbs_tasks[i]);
-				barrier_cbs_tasks[i] = NULL;
-			}
-		}
+		for (i = 0; i < n_barrier_cbs; i++)
+			torture_stop_kthread(rcu_torture_barrier_cbs,
+					     barrier_cbs_tasks[i]);
 		kfree(barrier_cbs_tasks);
 		barrier_cbs_tasks = NULL;
 	}
@@ -1747,90 +1297,42 @@ rcu_torture_cleanup(void)
 {
 	int i;
 
-	mutex_lock(&fullstop_mutex);
 	rcutorture_record_test_transition();
-	if (fullstop == FULLSTOP_SHUTDOWN) {
-		pr_warn(/* but going down anyway, so... */
-		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
-		mutex_unlock(&fullstop_mutex);
-		schedule_timeout_uninterruptible(10);
+	if (torture_cleanup()) {
 		if (cur_ops->cb_barrier != NULL)
 			cur_ops->cb_barrier();
 		return;
 	}
-	fullstop = FULLSTOP_RMMOD;
-	mutex_unlock(&fullstop_mutex);
-	unregister_reboot_notifier(&rcutorture_shutdown_nb);
-	rcu_torture_barrier_cleanup();
-	rcu_torture_stall_cleanup();
-	if (stutter_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
-		kthread_stop(stutter_task);
-	}
-	stutter_task = NULL;
-	if (shuffler_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
-		kthread_stop(shuffler_task);
-		free_cpumask_var(shuffle_tmp_mask);
-	}
-	shuffler_task = NULL;
 
-	if (writer_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_writer task");
-		kthread_stop(writer_task);
-	}
-	writer_task = NULL;
+	rcu_torture_barrier_cleanup();
+	torture_stop_kthread(rcu_torture_stall, stall_task);
+	torture_stop_kthread(rcu_torture_writer, writer_task);
 
 	if (reader_tasks) {
-		for (i = 0; i < nrealreaders; i++) {
-			if (reader_tasks[i]) {
-				VERBOSE_PRINTK_STRING(
-					"Stopping rcu_torture_reader task");
-				kthread_stop(reader_tasks[i]);
-			}
-			reader_tasks[i] = NULL;
-		}
+		for (i = 0; i < nrealreaders; i++)
+			torture_stop_kthread(rcu_torture_reader,
+					     reader_tasks[i]);
 		kfree(reader_tasks);
-		reader_tasks = NULL;
 	}
 	rcu_torture_current = NULL;
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++) {
-			if (fakewriter_tasks[i]) {
-				VERBOSE_PRINTK_STRING(
-					"Stopping rcu_torture_fakewriter task");
-				kthread_stop(fakewriter_tasks[i]);
-			}
-			fakewriter_tasks[i] = NULL;
+			torture_stop_kthread(rcu_torture_fakewriter,
+					     fakewriter_tasks[i]);
 		}
 		kfree(fakewriter_tasks);
 		fakewriter_tasks = NULL;
 	}
 
-	if (stats_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stats task");
-		kthread_stop(stats_task);
-	}
-	stats_task = NULL;
-
-	if (fqs_task) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_fqs task");
-		kthread_stop(fqs_task);
-	}
-	fqs_task = NULL;
+	torture_stop_kthread(rcu_torture_stats, stats_task);
+	torture_stop_kthread(rcu_torture_fqs, fqs_task);
 	if ((test_boost == 1 && cur_ops->can_boost) ||
 	    test_boost == 2) {
 		unregister_cpu_notifier(&rcutorture_cpu_nb);
 		for_each_possible_cpu(i)
 			rcutorture_booster_cleanup(i);
 	}
-	if (shutdown_task != NULL) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
-		kthread_stop(shutdown_task);
-	}
-	shutdown_task = NULL;
-	rcu_torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1841,8 +1343,7 @@ rcu_torture_cleanup(void)
 
 	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
-	else if (n_online_successes != n_online_attempts ||
-		 n_offline_successes != n_offline_attempts)
+	else if (torture_onoff_failures())
 		rcu_torture_print_module_parms(cur_ops,
 					       "End of test: RCU_HOTPLUG");
 	else
@@ -1911,12 +1412,11 @@ rcu_torture_init(void)
 	int i;
 	int cpu;
 	int firsterr = 0;
-	int retval;
 	static struct rcu_torture_ops *torture_ops[] = {
-		&rcu_ops, &rcu_bh_ops, &srcu_ops, &sched_ops,
+		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
 	};
 
-	mutex_lock(&fullstop_mutex);
+	torture_init_begin(torture_type, verbose, &rcutorture_runnable);
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
@@ -1931,7 +1431,7 @@ rcu_torture_init(void)
 		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
 			pr_alert(" %s", torture_ops[i]->name);
 		pr_alert("\n");
-		mutex_unlock(&fullstop_mutex);
+		torture_init_end();
 		return -EINVAL;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
@@ -1946,7 +1446,6 @@ rcu_torture_init(void)
 	else
 		nrealreaders = 2 * num_online_cpus();
 	rcu_torture_print_module_parms(cur_ops, "Start of test");
-	fullstop = FULLSTOP_DONTSTOP;
 
 	/* Set up the freelist. */
 
@@ -1982,108 +1481,61 @@ rcu_torture_init(void)
 
 	/* Start up the kthreads. */
 
-	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
-	writer_task = kthread_create(rcu_torture_writer, NULL,
-				     "rcu_torture_writer");
-	if (IS_ERR(writer_task)) {
-		firsterr = PTR_ERR(writer_task);
-		VERBOSE_PRINTK_ERRSTRING("Failed to create writer");
-		writer_task = NULL;
+	firsterr = torture_create_kthread(rcu_torture_writer, NULL,
+					  writer_task);
+	if (firsterr)
 		goto unwind;
-	}
-	wake_up_process(writer_task);
 	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
 				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
-		VERBOSE_PRINTK_ERRSTRING("out of memory");
+		VERBOSE_TOROUT_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
 	for (i = 0; i < nfakewriters; i++) {
-		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
-		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
-						  "rcu_torture_fakewriter");
-		if (IS_ERR(fakewriter_tasks[i])) {
-			firsterr = PTR_ERR(fakewriter_tasks[i]);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create fakewriter");
-			fakewriter_tasks[i] = NULL;
+		firsterr = torture_create_kthread(rcu_torture_fakewriter,
+						  NULL, fakewriter_tasks[i]);
+		if (firsterr)
 			goto unwind;
-		}
 	}
 	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (reader_tasks == NULL) {
-		VERBOSE_PRINTK_ERRSTRING("out of memory");
+		VERBOSE_TOROUT_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
 	for (i = 0; i < nrealreaders; i++) {
-		VERBOSE_PRINTK_STRING("Creating rcu_torture_reader task");
-		reader_tasks[i] = kthread_run(rcu_torture_reader, NULL,
-					      "rcu_torture_reader");
-		if (IS_ERR(reader_tasks[i])) {
-			firsterr = PTR_ERR(reader_tasks[i]);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create reader");
-			reader_tasks[i] = NULL;
+		firsterr = torture_create_kthread(rcu_torture_reader, NULL,
+						  reader_tasks[i]);
+		if (firsterr)
 			goto unwind;
-		}
 	}
 	if (stat_interval > 0) {
-		VERBOSE_PRINTK_STRING("Creating rcu_torture_stats task");
-		stats_task = kthread_run(rcu_torture_stats, NULL,
-					"rcu_torture_stats");
-		if (IS_ERR(stats_task)) {
-			firsterr = PTR_ERR(stats_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create stats");
-			stats_task = NULL;
+		firsterr = torture_create_kthread(rcu_torture_stats, NULL,
+						  stats_task);
+		if (firsterr)
 			goto unwind;
-		}
 	}
 	if (test_no_idle_hz) {
-		rcu_idle_cpu = num_online_cpus() - 1;
-
-		if (!alloc_cpumask_var(&shuffle_tmp_mask, GFP_KERNEL)) {
-			firsterr = -ENOMEM;
-			VERBOSE_PRINTK_ERRSTRING("Failed to alloc mask");
-			goto unwind;
-		}
-
-		/* Create the shuffler thread */
-		shuffler_task = kthread_run(rcu_torture_shuffle, NULL,
-					  "rcu_torture_shuffle");
-		if (IS_ERR(shuffler_task)) {
-			free_cpumask_var(shuffle_tmp_mask);
-			firsterr = PTR_ERR(shuffler_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create shuffler");
-			shuffler_task = NULL;
+		firsterr = torture_shuffle_init(shuffle_interval * HZ);
+		if (firsterr)
 			goto unwind;
-		}
 	}
 	if (stutter < 0)
 		stutter = 0;
 	if (stutter) {
-		/* Create the stutter thread */
-		stutter_task = kthread_run(rcu_torture_stutter, NULL,
-					  "rcu_torture_stutter");
-		if (IS_ERR(stutter_task)) {
-			firsterr = PTR_ERR(stutter_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create stutter");
-			stutter_task = NULL;
+		firsterr = torture_stutter_init(stutter * HZ);
+		if (firsterr)
 			goto unwind;
-		}
 	}
 	if (fqs_duration < 0)
 		fqs_duration = 0;
 	if (fqs_duration) {
-		/* Create the stutter thread */
-		fqs_task = kthread_run(rcu_torture_fqs, NULL,
-				       "rcu_torture_fqs");
-		if (IS_ERR(fqs_task)) {
-			firsterr = PTR_ERR(fqs_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create fqs");
-			fqs_task = NULL;
+		/* Create the fqs thread */
+		torture_create_kthread(rcu_torture_fqs, NULL, fqs_task);
+		if (firsterr)
 			goto unwind;
-		}
 	}
 	if (test_boost_interval < 1)
 		test_boost_interval = 1;
@@ -2097,49 +1549,31 @@ rcu_torture_init(void)
 		for_each_possible_cpu(i) {
 			if (cpu_is_offline(i))
 				continue;  /* Heuristic: CPU can go offline. */
-			retval = rcutorture_booster_init(i);
-			if (retval < 0) {
-				firsterr = retval;
+			firsterr = rcutorture_booster_init(i);
+			if (firsterr)
 				goto unwind;
-			}
 		}
 	}
-	if (shutdown_secs > 0) {
-		shutdown_time = jiffies + shutdown_secs * HZ;
-		shutdown_task = kthread_create(rcu_torture_shutdown, NULL,
-					       "rcu_torture_shutdown");
-		if (IS_ERR(shutdown_task)) {
-			firsterr = PTR_ERR(shutdown_task);
-			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
-			shutdown_task = NULL;
-			goto unwind;
-		}
-		wake_up_process(shutdown_task);
-	}
-	i = rcu_torture_onoff_init();
-	if (i != 0) {
-		firsterr = i;
+	firsterr = torture_shutdown_init(shutdown_secs, rcu_torture_cleanup);
+	if (firsterr)
 		goto unwind;
-	}
-	register_reboot_notifier(&rcutorture_shutdown_nb);
-	i = rcu_torture_stall_init();
-	if (i != 0) {
-		firsterr = i;
+	firsterr = torture_onoff_init(onoff_holdoff * HZ, onoff_interval * HZ);
+	if (firsterr)
 		goto unwind;
-	}
-	retval = rcu_torture_barrier_init();
-	if (retval != 0) {
-		firsterr = retval;
+	firsterr = rcu_torture_stall_init();
+	if (firsterr)
+		goto unwind;
+	firsterr = rcu_torture_barrier_init();
+	if (firsterr)
 		goto unwind;
-	}
 	if (object_debug)
 		rcu_test_debug_objects();
 	rcutorture_record_test_transition();
-	mutex_unlock(&fullstop_mutex);
+	torture_init_end();
 	return 0;
 
 unwind:
-	mutex_unlock(&fullstop_mutex);
+	torture_init_end();
 	rcu_torture_cleanup();
 	return firsterr;
 }
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 3318d82..c639556 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (C) IBM Corporation, 2006
  * Copyright (C) Fujitsu, 2012
@@ -36,8 +36,6 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
-#include <trace/events/rcu.h>
-
 #include "rcu.h"
 
 /*
@@ -398,7 +396,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
 	rcu_batch_queue(&sp->batch_queue, head);
 	if (!sp->running) {
 		sp->running = true;
-		schedule_delayed_work(&sp->work, 0);
+		queue_delayed_work(system_power_efficient_wq, &sp->work, 0);
 	}
 	spin_unlock_irqrestore(&sp->queue_lock, flags);
 }
@@ -674,7 +672,8 @@ static void srcu_reschedule(struct srcu_struct *sp)
 	}
 
 	if (pending)
-		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
+		queue_delayed_work(system_power_efficient_wq,
+				   &sp->work, SRCU_INTERVAL);
 }
 
 /*
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 1254f31..d9efcc1 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
@@ -37,10 +37,6 @@
 #include <linux/prefetch.h>
 #include <linux/ftrace_event.h>
 
-#ifdef CONFIG_RCU_TRACE
-#include <trace/events/rcu.h>
-#endif /* #else #ifdef CONFIG_RCU_TRACE */
-
 #include "rcu.h"
 
 /* Forward declarations for tiny_plugin.h. */
diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
index 280d06c..4315285 100644
--- a/kernel/rcu/tiny_plugin.h
+++ b/kernel/rcu/tiny_plugin.h
@@ -14,8 +14,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (c) 2010 Linaro
  *
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b3d116c..0c47e30 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
@@ -58,8 +58,6 @@
 #include <linux/suspend.h>
 
 #include "tree.h"
-#include <trace/events/rcu.h>
-
 #include "rcu.h"
 
 MODULE_ALIAS("rcutree");
@@ -837,7 +835,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 * to the next.  Only do this for the primary flavor of RCU.
 	 */
 	if (rdp->rsp == rcu_state &&
-	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
+	    ULONG_CMP_GE(jiffies, rdp->rsp->jiffies_resched)) {
 		rdp->rsp->jiffies_resched += 5;
 		resched_cpu(rdp->cpu);
 	}
@@ -847,7 +845,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
-	unsigned long j = ACCESS_ONCE(jiffies);
+	unsigned long j = jiffies;
 	unsigned long j1;
 
 	rsp->gp_start = j;
@@ -1005,7 +1003,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_cpu_stall_suppress || !rcu_gp_in_progress(rsp))
 		return;
-	j = ACCESS_ONCE(jiffies);
+	j = jiffies;
 
 	/*
 	 * Lots of memory barriers to reject false positives.
@@ -1423,13 +1421,14 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	/* Advance to a new grace period and initialize state. */
 	record_gp_stall_check_time(rsp);
-	smp_wmb(); /* Record GP times before starting GP. */
-	rsp->gpnum++;
+	/* Record GP times before starting GP, hence smp_store_release(). */
+	smp_store_release(&rsp->gpnum, rsp->gpnum + 1);
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
 	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */
 	mutex_lock(&rsp->onoff_mutex);
+	smp_mb__after_unlock_lock(); /* ->gpnum increment before GP! */
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
@@ -1557,10 +1556,11 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
-	smp_mb__after_unlock_lock();
+	smp_mb__after_unlock_lock(); /* Order GP before ->completed update. */
 	rcu_nocb_gp_set(rnp, nocb);
 
-	rsp->completed = rsp->gpnum; /* Declare grace period done. */
+	/* Declare grace period done. */
+	ACCESS_ONCE(rsp->completed) = rsp->gpnum;
 	trace_rcu_grace_period(rsp->name, rsp->completed, TPS("end"));
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
@@ -2304,7 +2304,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		if (rnp_old != NULL)
 			raw_spin_unlock(&rnp_old->fqslock);
 		if (ret) {
-			rsp->n_force_qs_lh++;
+			ACCESS_ONCE(rsp->n_force_qs_lh)++;
 			return;
 		}
 		rnp_old = rnp;
@@ -2316,7 +2316,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
-		rsp->n_force_qs_lh++;
+		ACCESS_ONCE(rsp->n_force_qs_lh)++;
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
@@ -2639,6 +2639,58 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
+/**
+ * get_state_synchronize_rcu - Snapshot current RCU state
+ *
+ * Returns a cookie that is used by a later call to cond_synchronize_rcu()
+ * to determine whether or not a full grace period has elapsed in the
+ * meantime.
+ */
+unsigned long get_state_synchronize_rcu(void)
+{
+	/*
+	 * Any prior manipulation of RCU-protected data must happen
+	 * before the load from ->gpnum.
+	 */
+	smp_mb();  /* ^^^ */
+
+	/*
+	 * Make sure this load happens before the purportedly
+	 * time-consuming work between get_state_synchronize_rcu()
+	 * and cond_synchronize_rcu().
+	 */
+	return smp_load_acquire(&rcu_state->gpnum);
+}
+EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);
+
+/**
+ * cond_synchronize_rcu - Conditionally wait for an RCU grace period
+ *
+ * @oldstate: return value from earlier call to get_state_synchronize_rcu()
+ *
+ * If a full RCU grace period has elapsed since the earlier call to
+ * get_state_synchronize_rcu(), just return.  Otherwise, invoke
+ * synchronize_rcu() to wait for a full grace period.
+ *
+ * Yes, this function does not take counter wrap into account.  But
+ * counter wrap is harmless.  If the counter wraps, we have waited for
+ * more than 2 billion grace periods (and way more on a 64-bit system!),
+ * so waiting for one additional grace period should be just fine.
+ */
+void cond_synchronize_rcu(unsigned long oldstate)
+{
+	unsigned long newstate;
+
+	/*
+	 * Ensure that this load happens before any RCU-destructive
+	 * actions the caller might carry out after we return.
+	 */
+	newstate = smp_load_acquire(&rcu_state->completed);
+	if (ULONG_CMP_GE(oldstate, newstate))
+		synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cond_synchronize_rcu);
+
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
 	/*
@@ -2880,7 +2932,7 @@ static int rcu_pending(int cpu)
  * non-NULL, store an indication of whether all callbacks are lazy.
  * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
+static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 {
 	bool al = true;
 	bool hc = false;
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8c19873..75dc3c3 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -13,8 +13,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6e2ef4b..962d1d5 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -14,8 +14,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright Red Hat, 2009
  * Copyright IBM Corporation, 2009
@@ -1586,11 +1586,13 @@ static void rcu_prepare_kthreads(int cpu)
  * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
  * any flavor of RCU.
  */
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
 	return rcu_cpu_has_callbacks(cpu, NULL);
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Because we do not have RCU_FAST_NO_HZ, don't bother cleaning up
@@ -1656,7 +1658,7 @@ extern int tick_nohz_active;
  * only if it has been awhile since the last time we did so.  Afterwards,
  * if there are any callbacks ready for immediate invocation, return true.
  */
-static bool rcu_try_advance_all_cbs(void)
+static bool __maybe_unused rcu_try_advance_all_cbs(void)
 {
 	bool cbs_ready = false;
 	struct rcu_data *rdp;
@@ -1696,6 +1698,7 @@ static bool rcu_try_advance_all_cbs(void)
  *
  * The caller must have disabled interrupts.
  */
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 int rcu_needs_cpu(int cpu, unsigned long *dj)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
@@ -1726,6 +1729,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
 	}
 	return 0;
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Prepare a CPU for idle from an RCU perspective.  The first major task
@@ -1739,6 +1743,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 	struct rcu_data *rdp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	struct rcu_node *rnp;
@@ -1790,6 +1795,7 @@ static void rcu_prepare_for_idle(int cpu)
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 }
 
 /*
@@ -1799,11 +1805,12 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 	if (rcu_is_nocb_cpu(cpu))
 		return;
 	if (rcu_try_advance_all_cbs())
 		invoke_rcu_core();
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 }
 
 /*
@@ -2101,6 +2108,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
 }
 
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 /* Is the specified CPU a no-CPUs CPU? */
 bool rcu_is_nocb_cpu(int cpu)
 {
@@ -2108,6 +2116,7 @@ bool rcu_is_nocb_cpu(int cpu)
 		return cpumask_test_cpu(cpu, rcu_nocb_mask);
 	return false;
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Enqueue the specified string of rcu_head structures onto the specified
@@ -2893,7 +2902,7 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
  * CPU unless the grace period has extended for too long.
  *
  * This code relies on the fact that all NO_HZ_FULL CPUs are also
- * CONFIG_RCU_NOCB_CPUs.
+ * CONFIG_RCU_NOCB_CPU CPUs.
  */
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 {
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index 4def475..5cdc62e 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
@@ -273,7 +273,7 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	seq_printf(m, "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh, rsp->qlen_lazy, rsp->qlen);
+		   ACCESS_ONCE(rsp->n_force_qs_lh), rsp->qlen_lazy, rsp->qlen);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < rcu_num_nodes; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index c54609f..4c0a9b0 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2001
  *
@@ -49,7 +49,6 @@
 #include <linux/module.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/rcu.h>
 
 #include "rcu.h"
 
diff --git a/kernel/torture.c b/kernel/torture.c
new file mode 100644
index 0000000..acc9afc
--- /dev/null
+++ b/kernel/torture.c
@@ -0,0 +1,719 @@
+/*
+ * Common functions for in-kernel torture tests.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
+ *
+ * Copyright (C) IBM Corporation, 2014
+ *
+ * Author: Paul E. McKenney <paulmck@us.ibm.com>
+ *	Based on kernel/rcu/torture.c.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/freezer.h>
+#include <linux/cpu.h>
+#include <linux/delay.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/trace_clock.h>
+#include <asm/byteorder.h>
+#include <linux/torture.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
+
+static char *torture_type;
+static bool verbose;
+
+/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
+#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
+#define FULLSTOP_SHUTDOWN 1	/* System shutdown with torture running. */
+#define FULLSTOP_RMMOD    2	/* Normal rmmod of torture. */
+static int fullstop = FULLSTOP_RMMOD;
+static DEFINE_MUTEX(fullstop_mutex);
+static int *torture_runnable;
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Variables for online-offline handling.  Only present if CPU hotplug
+ * is enabled, otherwise does nothing.
+ */
+
+static struct task_struct *onoff_task;
+static long onoff_holdoff;
+static long onoff_interval;
+static long n_offline_attempts;
+static long n_offline_successes;
+static unsigned long sum_offline;
+static int min_offline = -1;
+static int max_offline;
+static long n_online_attempts;
+static long n_online_successes;
+static unsigned long sum_online;
+static int min_online = -1;
+static int max_online;
+
+/*
+ * Execute random CPU-hotplug operations at the interval specified
+ * by the onoff_interval.
+ */
+static int
+torture_onoff(void *arg)
+{
+	int cpu;
+	unsigned long delta;
+	int maxcpu = -1;
+	DEFINE_TORTURE_RANDOM(rand);
+	int ret;
+	unsigned long starttime;
+
+	VERBOSE_TOROUT_STRING("torture_onoff task started");
+	for_each_online_cpu(cpu)
+		maxcpu = cpu;
+	WARN_ON(maxcpu < 0);
+	if (onoff_holdoff > 0) {
+		VERBOSE_TOROUT_STRING("torture_onoff begin holdoff");
+		schedule_timeout_interruptible(onoff_holdoff);
+		VERBOSE_TOROUT_STRING("torture_onoff end holdoff");
+	}
+	while (!torture_must_stop()) {
+		cpu = (torture_random(&rand) >> 4) % (maxcpu + 1);
+		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
+			if (verbose)
+				pr_alert("%s" TORTURE_FLAG
+					 "torture_onoff task: offlining %d\n",
+					 torture_type, cpu);
+			starttime = jiffies;
+			n_offline_attempts++;
+			ret = cpu_down(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: offline %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: offlined %d\n",
+						 torture_type, cpu);
+				n_offline_successes++;
+				delta = jiffies - starttime;
+				sum_offline += delta;
+				if (min_offline < 0) {
+					min_offline = delta;
+					max_offline = delta;
+				}
+				if (min_offline > delta)
+					min_offline = delta;
+				if (max_offline < delta)
+					max_offline = delta;
+			}
+		} else if (cpu_is_hotpluggable(cpu)) {
+			if (verbose)
+				pr_alert("%s" TORTURE_FLAG
+					 "torture_onoff task: onlining %d\n",
+					 torture_type, cpu);
+			starttime = jiffies;
+			n_online_attempts++;
+			ret = cpu_up(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: online %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "torture_onoff task: onlined %d\n",
+						 torture_type, cpu);
+				n_online_successes++;
+				delta = jiffies - starttime;
+				sum_online += delta;
+				if (min_online < 0) {
+					min_online = delta;
+					max_online = delta;
+				}
+				if (min_online > delta)
+					min_online = delta;
+				if (max_online < delta)
+					max_online = delta;
+			}
+		}
+		schedule_timeout_interruptible(onoff_interval);
+	}
+	torture_kthread_stopping("torture_onoff");
+	return 0;
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Initiate online-offline handling.
+ */
+int torture_onoff_init(long ooholdoff, long oointerval)
+{
+	int ret = 0;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	onoff_holdoff = ooholdoff;
+	onoff_interval = oointerval;
+	if (onoff_interval <= 0)
+		return 0;
+	ret = torture_create_kthread(torture_onoff, NULL, onoff_task);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+	return ret;
+}
+EXPORT_SYMBOL_GPL(torture_onoff_init);
+
+/*
+ * Clean up after online/offline testing.
+ */
+static void torture_onoff_cleanup(void)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	if (onoff_task == NULL)
+		return;
+	VERBOSE_TOROUT_STRING("Stopping torture_onoff task");
+	kthread_stop(onoff_task);
+	onoff_task = NULL;
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+}
+EXPORT_SYMBOL_GPL(torture_onoff_cleanup);
+
+/*
+ * Print online/offline testing statistics.
+ */
+char *torture_onoff_stats(char *page)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	page += sprintf(page,
+		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
+		       n_online_successes, n_online_attempts,
+		       n_offline_successes, n_offline_attempts,
+		       min_online, max_online,
+		       min_offline, max_offline,
+		       sum_online, sum_offline, HZ);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+	return page;
+}
+EXPORT_SYMBOL_GPL(torture_onoff_stats);
+
+/*
+ * Were all the online/offline operations successful?
+ */
+bool torture_onoff_failures(void)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	return n_online_successes != n_online_attempts ||
+	       n_offline_successes != n_offline_attempts;
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+	return false;
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+}
+EXPORT_SYMBOL_GPL(torture_onoff_failures);
+
+#define TORTURE_RANDOM_MULT	39916801  /* prime */
+#define TORTURE_RANDOM_ADD	479001701 /* prime */
+#define TORTURE_RANDOM_REFRESH	10000
+
+/*
+ * Crude but fast random-number generator.  Uses a linear congruential
+ * generator, with occasional help from cpu_clock().
+ */
+unsigned long
+torture_random(struct torture_random_state *trsp)
+{
+	if (--trsp->trs_count < 0) {
+		trsp->trs_state += (unsigned long)local_clock();
+		trsp->trs_count = TORTURE_RANDOM_REFRESH;
+	}
+	trsp->trs_state = trsp->trs_state * TORTURE_RANDOM_MULT +
+		TORTURE_RANDOM_ADD;
+	return swahw32(trsp->trs_state);
+}
+EXPORT_SYMBOL_GPL(torture_random);
+
+/*
+ * Variables for shuffling.  The idea is to ensure that each CPU stays
+ * idle for an extended period to test interactions with dyntick idle,
+ * as well as interactions with any per-CPU varibles.
+ */
+struct shuffle_task {
+	struct list_head st_l;
+	struct task_struct *st_t;
+};
+
+static long shuffle_interval;	/* In jiffies. */
+static struct task_struct *shuffler_task;
+static cpumask_var_t shuffle_tmp_mask;
+static int shuffle_idle_cpu;	/* Force all torture tasks off this CPU */
+static struct list_head shuffle_task_list = LIST_HEAD_INIT(shuffle_task_list);
+static DEFINE_MUTEX(shuffle_task_mutex);
+
+/*
+ * Register a task to be shuffled.  If there is no memory, just splat
+ * and don't bother registering.
+ */
+void torture_shuffle_task_register(struct task_struct *tp)
+{
+	struct shuffle_task *stp;
+
+	if (WARN_ON_ONCE(tp == NULL))
+		return;
+	stp = kmalloc(sizeof(*stp), GFP_KERNEL);
+	if (WARN_ON_ONCE(stp == NULL))
+		return;
+	stp->st_t = tp;
+	mutex_lock(&shuffle_task_mutex);
+	list_add(&stp->st_l, &shuffle_task_list);
+	mutex_unlock(&shuffle_task_mutex);
+}
+EXPORT_SYMBOL_GPL(torture_shuffle_task_register);
+
+/*
+ * Unregister all tasks, for example, at the end of the torture run.
+ */
+static void torture_shuffle_task_unregister_all(void)
+{
+	struct shuffle_task *stp;
+	struct shuffle_task *p;
+
+	mutex_lock(&shuffle_task_mutex);
+	list_for_each_entry_safe(stp, p, &shuffle_task_list, st_l) {
+		list_del(&stp->st_l);
+		kfree(stp);
+	}
+	mutex_unlock(&shuffle_task_mutex);
+}
+
+/* Shuffle tasks such that we allow shuffle_idle_cpu to become idle.
+ * A special case is when shuffle_idle_cpu = -1, in which case we allow
+ * the tasks to run on all CPUs.
+ */
+static void torture_shuffle_tasks(void)
+{
+	struct shuffle_task *stp;
+
+	cpumask_setall(shuffle_tmp_mask);
+	get_online_cpus();
+
+	/* No point in shuffling if there is only one online CPU (ex: UP) */
+	if (num_online_cpus() == 1) {
+		put_online_cpus();
+		return;
+	}
+
+	/* Advance to the next CPU.  Upon overflow, don't idle any CPUs. */
+	shuffle_idle_cpu = cpumask_next(shuffle_idle_cpu, shuffle_tmp_mask);
+	if (shuffle_idle_cpu >= nr_cpu_ids)
+		shuffle_idle_cpu = -1;
+	if (shuffle_idle_cpu != -1) {
+		cpumask_clear_cpu(shuffle_idle_cpu, shuffle_tmp_mask);
+		if (cpumask_empty(shuffle_tmp_mask)) {
+			put_online_cpus();
+			return;
+		}
+	}
+
+	mutex_lock(&shuffle_task_mutex);
+	list_for_each_entry(stp, &shuffle_task_list, st_l)
+		set_cpus_allowed_ptr(stp->st_t, shuffle_tmp_mask);
+	mutex_unlock(&shuffle_task_mutex);
+
+	put_online_cpus();
+}
+
+/* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
+ * system to become idle at a time and cut off its timer ticks. This is meant
+ * to test the support for such tickless idle CPU in RCU.
+ */
+static int torture_shuffle(void *arg)
+{
+	VERBOSE_TOROUT_STRING("torture_shuffle task started");
+	do {
+		schedule_timeout_interruptible(shuffle_interval);
+		torture_shuffle_tasks();
+		torture_shutdown_absorb("torture_shuffle");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("torture_shuffle");
+	return 0;
+}
+
+/*
+ * Start the shuffler, with shuffint in jiffies.
+ */
+int torture_shuffle_init(long shuffint)
+{
+	shuffle_interval = shuffint;
+
+	shuffle_idle_cpu = -1;
+
+	if (!alloc_cpumask_var(&shuffle_tmp_mask, GFP_KERNEL)) {
+		VERBOSE_TOROUT_ERRSTRING("Failed to alloc mask");
+		return -ENOMEM;
+	}
+
+	/* Create the shuffler thread */
+	return torture_create_kthread(torture_shuffle, NULL, shuffler_task);
+}
+EXPORT_SYMBOL_GPL(torture_shuffle_init);
+
+/*
+ * Stop the shuffling.
+ */
+static void torture_shuffle_cleanup(void)
+{
+	torture_shuffle_task_unregister_all();
+	if (shuffler_task) {
+		VERBOSE_TOROUT_STRING("Stopping torture_shuffle task");
+		kthread_stop(shuffler_task);
+		free_cpumask_var(shuffle_tmp_mask);
+	}
+	shuffler_task = NULL;
+}
+EXPORT_SYMBOL_GPL(torture_shuffle_cleanup);
+
+/*
+ * Variables for auto-shutdown.  This allows "lights out" torture runs
+ * to be fully scripted.
+ */
+static int shutdown_secs;		/* desired test duration in seconds. */
+static struct task_struct *shutdown_task;
+static unsigned long shutdown_time;	/* jiffies to system shutdown. */
+static void (*torture_shutdown_hook)(void);
+
+/*
+ * Absorb kthreads into a kernel function that won't return, so that
+ * they won't ever access module text or data again.
+ */
+void torture_shutdown_absorb(const char *title)
+{
+	while (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
+		pr_notice("torture thread %s parking due to system shutdown\n",
+			  title);
+		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
+	}
+}
+EXPORT_SYMBOL_GPL(torture_shutdown_absorb);
+
+/*
+ * Cause the torture test to shutdown the system after the test has
+ * run for the time specified by the shutdown_secs parameter.
+ */
+static int torture_shutdown(void *arg)
+{
+	long delta;
+	unsigned long jiffies_snap;
+
+	VERBOSE_TOROUT_STRING("torture_shutdown task started");
+	jiffies_snap = jiffies;
+	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
+	       !torture_must_stop()) {
+		delta = shutdown_time - jiffies_snap;
+		if (verbose)
+			pr_alert("%s" TORTURE_FLAG
+				 "torture_shutdown task: %lu jiffies remaining\n",
+				 torture_type, delta);
+		schedule_timeout_interruptible(delta);
+		jiffies_snap = jiffies;
+	}
+	if (torture_must_stop()) {
+		torture_kthread_stopping("torture_shutdown");
+		return 0;
+	}
+
+	/* OK, shut down the system. */
+
+	VERBOSE_TOROUT_STRING("torture_shutdown task shutting down system");
+	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
+	if (torture_shutdown_hook)
+		torture_shutdown_hook();
+	else
+		VERBOSE_TOROUT_STRING("No torture_shutdown_hook(), skipping.");
+	kernel_power_off();	/* Shut down the system. */
+	return 0;
+}
+
+/*
+ * Start up the shutdown task.
+ */
+int torture_shutdown_init(int ssecs, void (*cleanup)(void))
+{
+	int ret = 0;
+
+	shutdown_secs = ssecs;
+	torture_shutdown_hook = cleanup;
+	if (shutdown_secs > 0) {
+		shutdown_time = jiffies + shutdown_secs * HZ;
+		ret = torture_create_kthread(torture_shutdown, NULL,
+					     shutdown_task);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(torture_shutdown_init);
+
+/*
+ * Detect and respond to a system shutdown.
+ */
+static int torture_shutdown_notify(struct notifier_block *unused1,
+				   unsigned long unused2, void *unused3)
+{
+	mutex_lock(&fullstop_mutex);
+	if (ACCESS_ONCE(fullstop) == FULLSTOP_DONTSTOP) {
+		VERBOSE_TOROUT_STRING("Unscheduled system shutdown detected");
+		ACCESS_ONCE(fullstop) = FULLSTOP_SHUTDOWN;
+	} else {
+		pr_warn("Concurrent rmmod and shutdown illegal!\n");
+	}
+	mutex_unlock(&fullstop_mutex);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block torture_shutdown_nb = {
+	.notifier_call = torture_shutdown_notify,
+};
+
+/*
+ * Shut down the shutdown task.  Say what???  Heh!  This can happen if
+ * the torture module gets an rmmod before the shutdown time arrives.  ;-)
+ */
+static void torture_shutdown_cleanup(void)
+{
+	unregister_reboot_notifier(&torture_shutdown_nb);
+	if (shutdown_task != NULL) {
+		VERBOSE_TOROUT_STRING("Stopping torture_shutdown task");
+		kthread_stop(shutdown_task);
+	}
+	shutdown_task = NULL;
+}
+
+/*
+ * Variables for stuttering, which means to periodically pause and
+ * restart testing in order to catch bugs that appear when load is
+ * suddenly applied to or removed from the system.
+ */
+static struct task_struct *stutter_task;
+static int stutter_pause_test;
+static int stutter;
+
+/*
+ * Block until the stutter interval ends.  This must be called periodically
+ * by all running kthreads that need to be subject to stuttering.
+ */
+void stutter_wait(const char *title)
+{
+	while (ACCESS_ONCE(stutter_pause_test) ||
+	       (torture_runnable && !ACCESS_ONCE(*torture_runnable))) {
+		if (stutter_pause_test)
+			schedule_timeout_interruptible(1);
+		else
+			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+		torture_shutdown_absorb(title);
+	}
+}
+EXPORT_SYMBOL_GPL(stutter_wait);
+
+/*
+ * Cause the torture test to "stutter", starting and stopping all
+ * threads periodically.
+ */
+static int torture_stutter(void *arg)
+{
+	VERBOSE_TOROUT_STRING("torture_stutter task started");
+	do {
+		if (!torture_must_stop()) {
+			schedule_timeout_interruptible(stutter);
+			ACCESS_ONCE(stutter_pause_test) = 1;
+		}
+		if (!torture_must_stop())
+			schedule_timeout_interruptible(stutter);
+		ACCESS_ONCE(stutter_pause_test) = 0;
+		torture_shutdown_absorb("torture_stutter");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("torture_stutter");
+	return 0;
+}
+
+/*
+ * Initialize and kick off the torture_stutter kthread.
+ */
+int torture_stutter_init(int s)
+{
+	int ret;
+
+	stutter = s;
+	ret = torture_create_kthread(torture_stutter, NULL, stutter_task);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(torture_stutter_init);
+
+/*
+ * Cleanup after the torture_stutter kthread.
+ */
+static void torture_stutter_cleanup(void)
+{
+	if (!stutter_task)
+		return;
+	VERBOSE_TOROUT_STRING("Stopping torture_stutter task");
+	kthread_stop(stutter_task);
+	stutter_task = NULL;
+}
+
+/*
+ * Initialize torture module.  Please note that this is -not- invoked via
+ * the usual module_init() mechanism, but rather by an explicit call from
+ * the client torture module.  This call must be paired with a later
+ * torture_init_end().
+ *
+ * The runnable parameter points to a flag that controls whether or not
+ * the test is currently runnable.  If there is no such flag, pass in NULL.
+ */
+void __init torture_init_begin(char *ttype, bool v, int *runnable)
+{
+	mutex_lock(&fullstop_mutex);
+	torture_type = ttype;
+	verbose = v;
+	torture_runnable = runnable;
+	fullstop = FULLSTOP_DONTSTOP;
+
+}
+EXPORT_SYMBOL_GPL(torture_init_begin);
+
+/*
+ * Tell the torture module that initialization is complete.
+ */
+void __init torture_init_end(void)
+{
+	mutex_unlock(&fullstop_mutex);
+	register_reboot_notifier(&torture_shutdown_nb);
+}
+EXPORT_SYMBOL_GPL(torture_init_end);
+
+/*
+ * Clean up torture module.  Please note that this is -not- invoked via
+ * the usual module_exit() mechanism, but rather by an explicit call from
+ * the client torture module.  Returns true if a race with system shutdown
+ * is detected, otherwise, all kthreads started by functions in this file
+ * will be shut down.
+ *
+ * This must be called before the caller starts shutting down its own
+ * kthreads.
+ */
+bool torture_cleanup(void)
+{
+	mutex_lock(&fullstop_mutex);
+	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
+		pr_warn("Concurrent rmmod and shutdown illegal!\n");
+		mutex_unlock(&fullstop_mutex);
+		schedule_timeout_uninterruptible(10);
+		return true;
+	}
+	ACCESS_ONCE(fullstop) = FULLSTOP_RMMOD;
+	mutex_unlock(&fullstop_mutex);
+	torture_shutdown_cleanup();
+	torture_shuffle_cleanup();
+	torture_stutter_cleanup();
+	torture_onoff_cleanup();
+	return false;
+}
+EXPORT_SYMBOL_GPL(torture_cleanup);
+
+/*
+ * Is it time for the current torture test to stop?
+ */
+bool torture_must_stop(void)
+{
+	return torture_must_stop_irq() || kthread_should_stop();
+}
+EXPORT_SYMBOL_GPL(torture_must_stop);
+
+/*
+ * Is it time for the current torture test to stop?  This is the irq-safe
+ * version, hence no check for kthread_should_stop().
+ */
+bool torture_must_stop_irq(void)
+{
+	return ACCESS_ONCE(fullstop) != FULLSTOP_DONTSTOP;
+}
+EXPORT_SYMBOL_GPL(torture_must_stop_irq);
+
+/*
+ * Each kthread must wait for kthread_should_stop() before returning from
+ * its top-level function, otherwise segfaults ensue.  This function
+ * prints a "stopping" message and waits for kthread_should_stop(), and
+ * should be called from all torture kthreads immediately prior to
+ * returning.
+ */
+void torture_kthread_stopping(char *title)
+{
+	if (verbose)
+		VERBOSE_TOROUT_STRING(title);
+	while (!kthread_should_stop()) {
+		torture_shutdown_absorb(title);
+		schedule_timeout_uninterruptible(1);
+	}
+}
+EXPORT_SYMBOL_GPL(torture_kthread_stopping);
+
+/*
+ * Create a generic torture kthread that is immediately runnable.  If you
+ * need the kthread to be stopped so that you can do something to it before
+ * it starts, you will need to open-code your own.
+ */
+int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
+			    char *f, struct task_struct **tp)
+{
+	int ret = 0;
+
+	VERBOSE_TOROUT_STRING(m);
+	*tp = kthread_run(fn, arg, s);
+	if (IS_ERR(*tp)) {
+		ret = PTR_ERR(*tp);
+		VERBOSE_TOROUT_ERRSTRING(f);
+		*tp = NULL;
+	}
+	torture_shuffle_task_register(*tp);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(_torture_create_kthread);
+
+/*
+ * Stop a generic kthread, emitting a message.
+ */
+void _torture_stop_kthread(char *m, struct task_struct **tp)
+{
+	if (*tp == NULL)
+		return;
+	VERBOSE_TOROUT_STRING(m);
+	kthread_stop(*tp);
+	*tp = NULL;
+}
+EXPORT_SYMBOL_GPL(_torture_stop_kthread);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a48abea..dd7f885 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -980,6 +980,21 @@ config DEBUG_LOCKING_API_SELFTESTS
 	  The following locking APIs are covered: spinlocks, rwlocks,
 	  mutexes and rwsems.
 
+config LOCK_TORTURE_TEST
+	tristate "torture tests for locking"
+	depends on DEBUG_KERNEL
+	select TORTURE_TEST
+	default n
+	help
+	  This option provides a kernel module that runs torture tests
+	  on kernel locking primitives.  The kernel module may be built
+	  after the fact on the running kernel to be tested, if desired.
+
+	  Say Y here if you want kernel locking-primitive torture tests
+	  to be built into the kernel.
+	  Say M if you want these torture tests to build as a module.
+	  Say N if you are unsure.
+
 endmenu # lock debugging
 
 config TRACE_IRQFLAGS
@@ -1141,9 +1156,14 @@ config SPARSE_RCU_POINTER
 
 	 Say N if you are unsure.
 
+config TORTURE_TEST
+	tristate
+	default n
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
+	select TORTURE_TEST
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 587561d..9b17e81 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -96,6 +96,7 @@ identify_qemu () {
 		echo qemu-system-ppc64
 	else
 		echo Cannot figure out what qemu command to use! 1>&2
+		echo file $1 output: $u
 		# Usually this will be one of /usr/bin/qemu-system-*
 		# Use RCU_QEMU_CMD environment variable or appropriate
 		# argument to top-level script.
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
new file mode 100755
index 0000000..829186e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+#
+# Analyze a given results directory for locktorture progress.
+#
+# Usage: sh kvm-recheck-lock.sh resdir
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2014
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+i="$1"
+if test -d $i
+then
+	:
+else
+	echo Unreadable results directory: $i
+	exit 1
+fi
+
+configfile=`echo $i | sed -e 's/^.*\///'`
+ncs=`grep "Writes:  Total:" $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* Total: //' -e 's/ .*$//'`
+if test -z "$ncs"
+then
+	echo $configfile
+else
+	title="$configfile ------- $ncs acquisitions/releases"
+	dur=`sed -e 's/^.* locktorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
+	if test -z "$dur"
+	then
+		:
+	else
+		ncsps=`awk -v ncs=$ncs -v dur=$dur '
+			BEGIN { print ncs / dur }' < /dev/null`
+		title="$title ($ncsps per second)"
+	fi
+	echo $title
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
new file mode 100755
index 0000000..d75b1dc5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+#
+# Analyze a given results directory for rcutorture progress.
+#
+# Usage: sh kvm-recheck-rcu.sh resdir
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2014
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+i="$1"
+if test -d $i
+then
+	:
+else
+	echo Unreadable results directory: $i
+	exit 1
+fi
+
+configfile=`echo $i | sed -e 's/^.*\///'`
+ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
+if test -z "$ngps"
+then
+	echo $configfile
+else
+	title="$configfile ------- $ngps grace periods"
+	dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
+	if test -z "$dur"
+	then
+		:
+	else
+		ngpsps=`awk -v ngps=$ngps -v dur=$dur '
+			BEGIN { print ngps / dur }' < /dev/null`
+		title="$title ($ngpsps per second)"
+	fi
+	echo $title
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index baef09f..a44daaa 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 #
-# Given the results directories for previous KVM runs of rcutorture,
+# Given the results directories for previous KVM-based torture runs,
 # check the build and console output for errors.  Given a directory
 # containing results directories, this recursively checks them all.
 #
@@ -27,11 +27,18 @@
 PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
 for rd in "$@"
 do
+	firsttime=1
 	dirs=`find $rd -name Make.defconfig.out -print | sort | sed -e 's,/[^/]*$,,' | sort -u`
 	for i in $dirs
 	do
-		configfile=`echo $i | sed -e 's/^.*\///'`
-		echo $configfile
+		if test -n "$firsttime"
+		then
+			firsttime=""
+			resdir=`echo $i | sed -e 's,/$,,' -e 's,/[^/]*$,,'`
+			head -1 $resdir/log
+		fi
+		TORTURE_SUITE="`cat $i/../TORTURE_SUITE`"
+		kvm-recheck-${TORTURE_SUITE}.sh $i
 		configcheck.sh $i/.config $i/ConfigFragment
 		parse-build.sh $i/Make.out $configfile
 		parse-rcutorture.sh $i/console.log $configfile
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
similarity index 79%
rename from tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
rename to tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 151b237..94b28bb 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -6,15 +6,15 @@
 # Execute this in the source tree.  Do not run it as a background task
 # because qemu does not seem to like that much.
 #
-# Usage: sh kvm-test-1-rcu.sh config builddir resdir minutes qemu-args bootargs
+# Usage: sh kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
 #
-# qemu-args defaults to "" -- you will want "-nographic" if running headless.
-# bootargs defaults to	"root=/dev/sda noapic selinux=0 console=ttyS0"
-#			"initcall_debug debug rcutorture.stat_interval=15"
-#			"rcutorture.shutdown_secs=$((minutes * 60))"
-#			"rcutorture.rcutorture_runnable=1"
+# qemu-args defaults to "-nographic", along with arguments specifying the
+#			number of CPUs and other options generated from
+#			the underlying CPU architecture.
+# boot_args defaults to value returned by the per_version_boot_params
+#			shell function.
 #
-# Anything you specify for either qemu-args or bootargs is appended to
+# Anything you specify for either qemu-args or boot_args is appended to
 # the default values.  The "-smp" value is deduced from the contents of
 # the config fragment.
 #
@@ -40,32 +40,34 @@
 
 grace=120
 
-T=/tmp/kvm-test-1-rcu.sh.$$
+T=/tmp/kvm-test-1-run.sh.$$
 trap 'rm -rf $T' 0
 
 . $KVM/bin/functions.sh
 . $KVPATH/ver_functions.sh
 
 config_template=${1}
+config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
 title=`echo $config_template | sed -e 's/^.*\///'`
 builddir=${2}
 if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
 then
-	echo "kvm-test-1-rcu.sh :$builddir: Not a writable directory, cannot build into it"
+	echo "kvm-test-1-run.sh :$builddir: Not a writable directory, cannot build into it"
 	exit 1
 fi
 resdir=${3}
 if test -z "$resdir" -o ! -d "$resdir" -o ! -w "$resdir"
 then
-	echo "kvm-test-1-rcu.sh :$resdir: Not a writable directory, cannot build into it"
+	echo "kvm-test-1-run.sh :$resdir: Not a writable directory, cannot store results into it"
 	exit 1
 fi
 cp $config_template $resdir/ConfigFragment
 echo ' ---' `date`: Starting build
 echo ' ---' Kconfig fragment at: $config_template >> $resdir/log
-cat << '___EOF___' >> $T
-CONFIG_RCU_TORTURE_TEST=y
-___EOF___
+if test -r "$config_dir/CFcommon"
+then
+	cat < $config_dir/CFcommon >> $T
+fi
 # Optimizations below this point
 # CONFIG_USB=n
 # CONFIG_SECURITY=n
@@ -96,11 +98,23 @@ then
 	cp $builddir/.config $resdir
 	cp $builddir/arch/x86/boot/bzImage $resdir
 	parse-build.sh $resdir/Make.out $title
+	if test -f $builddir.wait
+	then
+		mv $builddir.wait $builddir.ready
+	fi
 else
 	cp $builddir/Make*.out $resdir
 	echo Build failed, not running KVM, see $resdir.
+	if test -f $builddir.wait
+	then
+		mv $builddir.wait $builddir.ready
+	fi
 	exit 1
 fi
+while test -f $builddir.ready
+do
+	sleep 1
+done
 minutes=$4
 seconds=$(($minutes * 60))
 qemu_args=$5
@@ -111,9 +125,10 @@ kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
 echo ' ---' `date`: Starting kernel
 
 # Determine the appropriate flavor of qemu command.
-QEMU="`identify_qemu $builddir/vmlinux.o`"
+QEMU="`identify_qemu $builddir/vmlinux`"
 
 # Generate -smp qemu argument.
+qemu_args="-nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
 vcpus=`identify_qemu_vcpus`
 if test $cpu_count -gt $vcpus
@@ -133,12 +148,8 @@ qemu_append="`identify_qemu_append "$QEMU"`"
 
 # Pull in Kconfig-fragment boot parameters
 boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
-# Generate CPU-hotplug boot parameters
-boot_args="`rcutorture_param_onoff "$boot_args" $builddir/.config`"
-# Generate rcu_barrier() boot parameter
-boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
-# Pull in standard rcutorture boot arguments
-boot_args="$boot_args rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1"
+# Generate kernel-version-specific boot parameters
+boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
 echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 if test -n "$RCU_BUILDONLY"
@@ -188,5 +199,5 @@ then
 fi
 
 cp $builddir/console.log $resdir
-parse-rcutorture.sh $resdir/console.log $title
+parse-${TORTURE_SUITE}torture.sh $resdir/console.log $title
 parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 1b7923b..5a78cbf 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -30,14 +30,21 @@
 scriptname=$0
 args="$*"
 
+T=/tmp/kvm.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
 dur=30
+dryrun=""
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
 builddir="${KVM}/b1"
 RCU_INITRD="$KVM/initrd"; export RCU_INITRD
 RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
+TORTURE_SUITE=rcu
 resdir=""
 configs=""
+cpus=0
 ds=`date +%Y.%m.%d-%H:%M:%S`
 kversion=""
 
@@ -49,7 +56,9 @@ usage () {
 	echo "       --builddir absolute-pathname"
 	echo "       --buildonly"
 	echo "       --configs \"config-file list\""
+	echo "       --cpus N"
 	echo "       --datestamp string"
+	echo "       --dryrun sched|script"
 	echo "       --duration minutes"
 	echo "       --interactive"
 	echo "       --kmake-arg kernel-make-arguments"
@@ -58,8 +67,9 @@ usage () {
 	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
 	echo "       --qemu-cmd qemu-system-..."
-	echo "       --results absolute-pathname"
 	echo "       --relbuilddir relative-pathname"
+	echo "       --results absolute-pathname"
+	echo "       --torture rcu"
 	exit 1
 }
 
@@ -85,11 +95,21 @@ do
 		configs="$2"
 		shift
 		;;
+	--cpus)
+		checkarg --cpus "(number)" "$#" "$2" '^[0-9]*$' '^--'
+		cpus=$2
+		shift
+		;;
 	--datestamp)
 		checkarg --datestamp "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
 		ds=$2
 		shift
 		;;
+	--dryrun)
+		checkarg --dryrun "sched|script" $# "$2" 'sched\|script' '^--'
+		dryrun=$2
+		shift
+		;;
 	--duration)
 		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' '^error'
 		dur=$2
@@ -138,6 +158,11 @@ do
 		resdir=$2
 		shift
 		;;
+	--torture)
+		checkarg --torture "(suite name)" "$#" "$2" '^\(lock\|rcu\)$' '^--'
+		TORTURE_SUITE=$2
+		shift
+		;;
 	*)
 		echo Unknown argument $1
 		usage
@@ -146,7 +171,7 @@ do
 	shift
 done
 
-CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
+CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
 KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
 
 if test -z "$configs"
@@ -157,54 +182,231 @@ fi
 if test -z "$resdir"
 then
 	resdir=$KVM/res
-	if ! test -e $resdir
-	then
-		mkdir $resdir || :
-	fi
-else
+fi
+
+if test "$dryrun" = ""
+then
 	if ! test -e $resdir
 	then
 		mkdir -p "$resdir" || :
 	fi
-fi
-mkdir $resdir/$ds
-touch $resdir/$ds/log
-echo $scriptname $args >> $resdir/$ds/log
+	mkdir $resdir/$ds
 
-pwd > $resdir/$ds/testid.txt
-if test -d .git
-then
-	git status >> $resdir/$ds/testid.txt
-	git rev-parse HEAD >> $resdir/$ds/testid.txt
-fi
-builddir=$KVM/b1
-if ! test -e $builddir
-then
-	mkdir $builddir || :
+	# Be noisy only if running the script.
+	echo Results directory: $resdir/$ds
+	echo $scriptname $args
+
+	touch $resdir/$ds/log
+	echo $scriptname $args >> $resdir/$ds/log
+	echo ${TORTURE_SUITE} > $resdir/$ds/TORTURE_SUITE
+
+	pwd > $resdir/$ds/testid.txt
+	if test -d .git
+	then
+		git status >> $resdir/$ds/testid.txt
+		git rev-parse HEAD >> $resdir/$ds/testid.txt
+	fi
 fi
 
+# Create a file of test-name/#cpus pairs, sorted by decreasing #cpus.
+touch $T/cfgcpu
 for CF in $configs
 do
-	# Running TREE01 multiple times creates TREE01, TREE01.2, TREE01.3, ...
-	rd=$resdir/$ds/$CF
-	if test -d "${rd}"
+	if test -f "$CONFIGFRAG/$kversion/$CF"
 	then
-		n="`ls -d "${rd}"* | grep '\.[0-9]\+$' |
-			sed -e 's/^.*\.\([0-9]\+\)/\1/' |
-			sort -k1n | tail -1`"
-		if test -z "$n"
-		then
-			rd="${rd}.2"
-		else
-			n="`expr $n + 1`"
-			rd="${rd}.${n}"
-		fi
+		echo $CF `configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF` >> $T/cfgcpu
+	else
+		echo "The --configs file $CF does not exist, terminating."
+		exit 1
 	fi
-	mkdir "${rd}"
-	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1 $RCU_BOOTARGS"
 done
+sort -k2nr $T/cfgcpu > $T/cfgcpu.sort
+
+# Use a greedy bin-packing algorithm, sorting the list accordingly.
+awk < $T/cfgcpu.sort > $T/cfgcpu.pack -v ncpus=$cpus '
+BEGIN {
+	njobs = 0;
+}
+
+{
+	# Read file of tests and corresponding required numbers of CPUs.
+	cf[njobs] = $1;
+	cpus[njobs] = $2;
+	njobs++;
+}
+
+END {
+	alldone = 0;
+	batch = 0;
+	nc = -1;
+
+	# Each pass through the following loop creates on test batch
+	# that can be executed concurrently given ncpus.  Note that a
+	# given test that requires more than the available CPUs will run in
+	# their own batch.  Such tests just have to make do with what
+	# is available.
+	while (nc != ncpus) {
+		batch++;
+		nc = ncpus;
+
+		# Each pass through the following loop considers one
+		# test for inclusion in the current batch.
+		for (i = 0; i < njobs; i++) {
+			if (done[i])
+				continue; # Already part of a batch.
+			if (nc >= cpus[i] || nc == ncpus) {
+
+				# This test fits into the current batch.
+				done[i] = batch;
+				nc -= cpus[i];
+				if (nc <= 0)
+					break; # Too-big test in its own batch.
+			}
+		}
+	}
+
+	# Dump out the tests in batch order.
+	for (b = 1; b <= batch; b++)
+		for (i = 0; i < njobs; i++)
+			if (done[i] == b)
+				print cf[i], cpus[i];
+}'
+
+# Generate a script to execute the tests in appropriate batches.
+cat << ___EOF___ > $T/script
+TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
+___EOF___
+awk < $T/cfgcpu.pack \
+	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
+	-v KVM="$KVM" \
+	-v ncpus=$cpus \
+	-v rd=$resdir/$ds/ \
+	-v dur=$dur \
+	-v RCU_QEMU_ARG=$RCU_QEMU_ARG \
+	-v RCU_BOOTARGS=$RCU_BOOTARGS \
+'BEGIN {
+	i = 0;
+}
+
+{
+	cf[i] = $1;
+	cpus[i] = $2;
+	i++;
+}
+
+# Dump out the scripting required to run one test batch.
+function dump(first, pastlast)
+{
+	print "echo ----Start batch: `date`";
+	print "echo ----Start batch: `date` >> " rd "/log";
+	jn=1
+	for (j = first; j < pastlast; j++) {
+		builddir=KVM "/b" jn
+		cpusr[jn] = cpus[j];
+		if (cfrep[cf[j]] == "") {
+			cfr[jn] = cf[j];
+			cfrep[cf[j]] = 1;
+		} else {
+			cfrep[cf[j]]++;
+			cfr[jn] = cf[j] "." cfrep[cf[j]];
+		}
+		if (cpusr[jn] > ncpus && ncpus != 0)
+			ovf = "(!)";
+		else
+			ovf = "";
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Starting build. `date`";
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Starting build. `date` >> " rd "/log";
+		print "rm -f " builddir ".*";
+		print "touch " builddir ".wait";
+		print "mkdir " builddir " > /dev/null 2>&1 || :";
+		print "mkdir " rd cfr[jn] " || :";
+		print "kvm-test-1-run.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " rd cfr[jn]  "/kvm-test-1-run.sh.out 2>&1 &"
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date`";
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date` >> " rd "/log";
+		print "while test -f " builddir ".wait"
+		print "do"
+		print "\tsleep 1"
+		print "done"
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Build complete. `date`";
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Build complete. `date` >> " rd "/log";
+		jn++;
+	}
+	for (j = 1; j < jn; j++) {
+		builddir=KVM "/b" j
+		print "rm -f " builddir ".ready"
+		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date`";
+		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date` >> " rd "/log";
+	}
+	print "wait"
+	print "echo ---- All kernel runs complete. `date`";
+	print "echo ---- All kernel runs complete. `date` >> " rd "/log";
+	for (j = 1; j < jn; j++) {
+		builddir=KVM "/b" j
+		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results:";
+		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results: >> " rd "/log";
+		print "cat " rd cfr[j]  "/kvm-test-1-run.sh.out";
+		print "cat " rd cfr[j]  "/kvm-test-1-run.sh.out >> " rd "/log";
+	}
+}
+
+END {
+	njobs = i;
+	nc = ncpus;
+	first = 0;
+
+	# Each pass through the following loop considers one test.
+	for (i = 0; i < njobs; i++) {
+		if (ncpus == 0) {
+			# Sequential test specified, each test its own batch.
+			dump(i, i + 1);
+			first = i;
+		} else if (nc < cpus[i] && i != 0) {
+			# Out of CPUs, dump out a batch.
+			dump(first, i);
+			first = i;
+			nc = ncpus;
+		}
+		# Account for the CPUs needed by the current test.
+		nc -= cpus[i];
+	}
+	# Dump the last batch.
+	if (ncpus != 0)
+		dump(first, i);
+}' >> $T/script
+
+if test "$dryrun" = script
+then
+	# Dump out the script, but define the environment variables that
+	# it needs to run standalone.
+	echo CONFIGFRAG="$CONFIGFRAG; export CONFIGFRAG"
+	echo KVM="$KVM; export KVM"
+	echo KVPATH="$KVPATH; export KVPATH"
+	echo PATH="$PATH; export PATH"
+	echo RCU_BUILDONLY="$RCU_BUILDONLY; export RCU_BUILDONLY"
+	echo RCU_INITRD="$RCU_INITRD; export RCU_INITRD"
+	echo RCU_KMAKE_ARG="$RCU_KMAKE_ARG; export RCU_KMAKE_ARG"
+	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
+	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
+	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
+	echo "mkdir -p "$resdir" || :"
+	echo "mkdir $resdir/$ds"
+	cat $T/script
+	exit 0
+elif test "$dryrun" = sched
+then
+	# Extract the test run schedule from the script.
+	egrep 'start batch|Starting build\.' $T/script |
+		sed -e 's/:.*$//' -e 's/^echo //'
+	exit 0
+else
+	# Not a dryru, so run the script.
+	sh $T/script
+fi
+
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
 
+echo
+echo
 echo " --- `date` Test summary:"
+echo Results directory: $resdir/$ds
 kvm-recheck.sh $resdir/$ds
diff --git a/tools/testing/selftests/rcutorture/configs/lock/BUSTED b/tools/testing/selftests/rcutorture/configs/lock/BUSTED
new file mode 100644
index 0000000..1d1da14
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/BUSTED
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot b/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
new file mode 100644
index 0000000..6386c15
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
@@ -0,0 +1 @@
+locktorture.torture_type=lock_busted
diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFLIST b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
new file mode 100644
index 0000000..a061b22
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
@@ -0,0 +1 @@
+LOCK01
diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFcommon b/tools/testing/selftests/rcutorture/configs/lock/CFcommon
new file mode 100644
index 0000000..e372dc2
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFcommon
@@ -0,0 +1,2 @@
+CONFIG_LOCK_TORTURE_TEST=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK01 b/tools/testing/selftests/rcutorture/configs/lock/LOCK01
new file mode 100644
index 0000000..a9625e3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK01
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
new file mode 100644
index 0000000..9746ea1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2014
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# locktorture_param_onoff bootparam-string config-file
+#
+# Adds onoff locktorture module parameters to kernels having it.
+locktorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding locktorture onoff. 1>&2
+		echo locktorture.onoff_interval=3 locktorture.onoff_holdoff=30
+	fi
+}
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `locktorture_param_onoff "$1" "$2"` \
+		locktorture.stat_interval=15 \
+		locktorture.shutdown_secs=$3 \
+		locktorture.locktorture_runnable=1 \
+		locktorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/BUSTED b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED
new file mode 100644
index 0000000..48d8a24
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED
@@ -0,0 +1,7 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
new file mode 100644
index 0000000..6804f9d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_busted
diff --git a/tools/testing/selftests/rcutorture/configs/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/CFLIST
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/CFLIST
rename to tools/testing/selftests/rcutorture/configs/rcu/CFLIST
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/CFcommon b/tools/testing/selftests/rcutorture/configs/rcu/CFcommon
new file mode 100644
index 0000000..d2d2a86
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/CFcommon
@@ -0,0 +1,2 @@
+CONFIG_RCU_TORTURE_TEST=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N
similarity index 75%
rename from tools/testing/selftests/rcutorture/configs/SRCU-N
rename to tools/testing/selftests/rcutorture/configs/rcu/SRCU-N
index 10a0e27..9fbb41b 100644
--- a/tools/testing/selftests/rcutorture/configs/SRCU-N
+++ b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N
@@ -1,8 +1,7 @@
 CONFIG_RCU_TRACE=n
 CONFIG_SMP=y
-CONFIG_NR_CPUS=8
+CONFIG_NR_CPUS=4
 CONFIG_HOTPLUG_CPU=y
 CONFIG_PREEMPT_NONE=y
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N.boot b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/SRCU-N.boot
rename to tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P
similarity index 86%
rename from tools/testing/selftests/rcutorture/configs/SRCU-P
rename to tools/testing/selftests/rcutorture/configs/rcu/SRCU-P
index 6650e00..4b6f272 100644
--- a/tools/testing/selftests/rcutorture/configs/SRCU-P
+++ b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P
@@ -5,4 +5,3 @@ CONFIG_HOTPLUG_CPU=y
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P.boot b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/SRCU-P.boot
rename to tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot
diff --git a/tools/testing/selftests/rcutorture/configs/TINY01 b/tools/testing/selftests/rcutorture/configs/rcu/TINY01
similarity index 92%
rename from tools/testing/selftests/rcutorture/configs/TINY01
rename to tools/testing/selftests/rcutorture/configs/rcu/TINY01
index 0c2823f..0a63e07 100644
--- a/tools/testing/selftests/rcutorture/configs/TINY01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY01
@@ -10,4 +10,3 @@ CONFIG_RCU_TRACE=n
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_PREEMPT_COUNT=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TINY02 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
similarity index 92%
rename from tools/testing/selftests/rcutorture/configs/TINY02
rename to tools/testing/selftests/rcutorture/configs/rcu/TINY02
index e5072d7..f4feaee 100644
--- a/tools/testing/selftests/rcutorture/configs/TINY02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
@@ -10,4 +10,3 @@ CONFIG_RCU_TRACE=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_PREEMPT_COUNT=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE01
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 141119a..9c827ec 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -20,4 +20,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/TREE01.boot
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
diff --git a/tools/testing/selftests/rcutorture/configs/TREE02 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
similarity index 92%
rename from tools/testing/selftests/rcutorture/configs/TREE02
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE02
index 2d4d096..1a777b5 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
@@ -7,7 +7,7 @@ CONFIG_PREEMPT=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
-CONFIG_RCU_FAST_NO_HZ=n 
+CONFIG_RCU_FAST_NO_HZ=n
 CONFIG_RCU_TRACE=n
 CONFIG_HOTPLUG_CPU=n
 CONFIG_SUSPEND=n
@@ -23,4 +23,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE03 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE03
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE03
index a47de5b..c1f111c 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE03
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
@@ -20,4 +20,3 @@ CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=y
 CONFIG_RCU_BOOST_PRIO=2
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE04
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE04
index 8d839b8..7dbd27c 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -22,4 +22,3 @@ CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/TREE04.boot
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE05
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE05
index b5ba72e..d0f32e5 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE05
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
@@ -22,4 +22,3 @@ CONFIG_PROVE_RCU_DELAY=y
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/TREE05.boot
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
diff --git a/tools/testing/selftests/rcutorture/configs/TREE06 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE06
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE06
index 7c95ab4..2e477df 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE06
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
@@ -23,4 +23,3 @@ CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE07
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE07
index 1467404..042f86e 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -21,4 +21,3 @@ CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE08
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE08
index 7d097a6..3438cee 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -23,4 +23,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
similarity index 96%
rename from tools/testing/selftests/rcutorture/configs/TREE08-T
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
index 442c4e4..bf4523d 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE08-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
@@ -23,4 +23,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE09 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
similarity index 95%
rename from tools/testing/selftests/rcutorture/configs/TREE09
rename to tools/testing/selftests/rcutorture/configs/rcu/TREE09
index 0d1ec0d..81e4f7c 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE09
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
@@ -18,4 +18,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
similarity index 70%
rename from tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
rename to tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
index e805253..5ace37a 100644
--- a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
@@ -20,16 +20,14 @@
 #
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	echo $1
-}
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	echo $1
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+# Which old kernels do not.
+per_version_boot_params () {
+	echo	rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
 }
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
diff --git a/tools/testing/selftests/rcutorture/configs/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
similarity index 72%
rename from tools/testing/selftests/rcutorture/configs/ver_functions.sh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
index 5e40ead..bae5569 100644
--- a/tools/testing/selftests/rcutorture/configs/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
@@ -20,18 +20,6 @@
 #
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
-	then
-		echo $1
-	else
-		echo $1 rcutorture.n_barrier_cbs=4
-	fi
-}
-
 # rcutorture_param_onoff bootparam-string config-file
 #
 # Adds onoff rcutorture module parameters to kernels having it.
@@ -39,8 +27,18 @@ rcutorture_param_onoff () {
 	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
 	then
 		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	else
-		echo $1
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
 	fi
 }
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
similarity index 100%
rename from tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
similarity index 69%
rename from tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
rename to tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
index 6a5f13a..8977d8d 100644
--- a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
@@ -26,9 +26,9 @@
 rcutorture_param_n_barrier_cbs () {
 	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
 	then
-		echo $1
+		:
 	else
-		echo $1 rcutorture.n_barrier_cbs=4
+		echo rcutorture.n_barrier_cbs=4
 	fi
 }
 
@@ -38,9 +38,20 @@ rcutorture_param_n_barrier_cbs () {
 rcutorture_param_onoff () {
 	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
 	then
-		echo CPU-hotplug kernel, adding rcutorture onoff.
-		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	else
-		echo $1
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
 	fi
 }
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		`rcutorture_param_n_barrier_cbs "$1"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
similarity index 66%
rename from tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
rename to tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
index c37432f..8977d8d 100644
--- a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
@@ -24,7 +24,12 @@
 #
 # Adds n_barrier_cbs rcutorture module parameter to kernels having it.
 rcutorture_param_n_barrier_cbs () {
-	echo $1
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		:
+	else
+		echo rcutorture.n_barrier_cbs=4
+	fi
 }
 
 # rcutorture_param_onoff bootparam-string config-file
@@ -33,9 +38,20 @@ rcutorture_param_n_barrier_cbs () {
 rcutorture_param_onoff () {
 	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
 	then
-		echo CPU-hotplug kernel, adding rcutorture onoff.
-		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	else
-		echo $1
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
 	fi
 }
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		`rcutorture_param_n_barrier_cbs "$1"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
similarity index 100%
rename from tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
rename to tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
