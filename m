Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaB1HkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:40:22 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34749 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaB1HkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:40:19 -0500
Date: Fri, 28 Feb 2014 08:40:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, josh@joshtriplett.org,
        pebolle@tiscali.nl, shaibal.dutta@broadcom.com,
        paul.gortmaker@windriver.com, mst@redhat.com, tj@kernel.org,
        fweisbec@gmail.com, laijs@cn.fujitsu.com, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org, rostedt@goodmis.org,
        eric.dumazet@gmail.com, rusty@rustcorp.com.au
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.15
Message-ID: <20140228074015.GA20113@gmail.com>
References: <20140228014728.GA23789@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228014728.GA23789@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The major changes to this series are:
> 
> 1.	Update RCU documentation.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/2/17/555.
> 
> 2.	Miscellaneous fixes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/2/17/530.  Note that two of these
> 	are RCU changes to other maintainer's trees: add1f0995454
> 	(fs) and 8857563b819b (notifer), both of which substitute
> 	rcu_access_pointer() for rcu_dereference_raw().
> 
> 3.	Real-time latency fixes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/2/17/544.
> 
> 4.	Torture-test changes, including refactoring of rcutorture
> 	and introduction of a vestigial locktorture.  These were posted
> 	to LKML at https://lkml.org/lkml/2014/2/17/599.
> 
> All of these have been exposed to -next testing.
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to f5604f67fe8cbd6f2088b20b9463f721aa613d4b:
> 
>   Merge branch 'torture.2014.02.23a' into HEAD (2014-02-26 06:38:59 -0800)
> 
> ----------------------------------------------------------------
> 
> Joe Perches (2):
>       rcu: Glue ASCII strings together
>       rcu: Indentation and spacing fixes.
> 
> Paul Bolle (2):
>       rcu: Disambiguate CONFIG_RCU_NOCB_CPUs
>       rcutorture: Rename TREE_RCU-Kconfig.txt
> 
> Paul E. McKenney (71):
>       documentation: Document call_rcu() safety mechanisms and limitations
>       Documentation/memory-barriers.txt: ACCESS_ONCE() provides cache coherence
>       Documentation/memory-barriers.txt: Conditional must use prior load
>       Documentation/kernel-per-CPU-kthreads.txt: Workqueue affinity
>       Documentation/memory-barriers.txt: Need barriers() for some control dependencies
>       documentation: Fix some inconsistencies in RTFP.txt
>       rcu: Add ACCESS_ONCE() to ->n_force_qs_lh accesses
>       rcu: Stop tracking FSF's postal address
>       rcu: Remove ACCESS_ONCE() from jiffies
>       rcu: Define rcu_assign_pointer() in terms of smp_store_release()
>       fs: Substitute rcu_access_pointer() for rcu_dereference_raw()
>       rcu: Optimize rcu_is_nocb_cpu() for RCU_NOCB_CPU_ALL
>       rcu: Optimize rcu_needs_cpu() for RCU_NOCB_CPU_ALL
>       rcu: Optimize RCU_FAST_NO_HZ for RCU_NOCB_CPU_ALL
>       rcutorture: Print grace-period performance statistics
>       rcutorture: Print script and arguments to standard output
>       rcutorture: Move common boot flags to kvm-test-1-rcu.sh
>       rcutorture: Allow kvm-test-1-rcu.sh to pause after build
>       rcutorture: Move common qemu flags to kvm-test-1.sh
>       rcutorture: Reduce SRCU-N number of CPUs
>       rcutorture: Enable concurrent rcutorture runs
>       rcutorture: Fix results-directory error message
>       rcutorture: Add dryrun capability
>       rcutorture: Handle multiple runs of the same test
>       rcutorture: Do better bin packing
>       rcutorture: Add comments, especially on bin packing.
>       rcutorture: Flag tests requiring more CPUs than are available
>       rcutorture: Print results directory when dumping results
>       rcutorture: Fix checkpatch complaint
>       rcutorture: Abstract rcu_torture_random()
>       rcutorture: Don't create results directory for dryruns
>       rcutorture: Abstract torture_param()
>       rcutorture: Rename PRINTK to TOROUT
>       rcutorture: Abstract TOROUT_STRING() and friends
>       rcutorture: Abstract torture_shutdown_absorb()
>       rcutorture: Abstract torture_shuffle()
>       rcutorture: Abstract torture_onoff()
>       rcutorture: Abstract torture-test initialization
>       rcutorture: Abstract torture-test cleanup
>       rcutorture: Print dates when doing parallel rcutorture runs
>       rcutorture: Abstract torture_shutdown_notify()
>       rcutorture: Privatize fullstop
>       rcutorture: Add diagnostic for unscheduled system shutdown
>       rcutorture: Abstract stutter_wait()
>       rcutorture: Apply ACCESS_ONCE() to racy fullstop accesses
>       rcutorture: Abstract torture_shutdown()
>       rcutorture: Clean up rcu_torture_init() error checking
>       rcutorture: Announce task creation
>       rcutorture: Fix rcutorture shutdown races
>       rcutorture: Fix missing-return bug in rcu_torture_barrier_init()
>       rcutorture: Abstract torture_create_kthread()
>       rcutorture: Abstract torture_stop_kthread()
>       rcutorture: Stop generic kthreads in torture_cleanup()
>       rcutorture: Abstract kvm-recheck.sh
>       locktorture: Add a lock-torture kernel module
>       rcutorture: Add an rcu_busted to test the test
>       rcutorture: Create config files for scripted test-the-test testing
>       rcutorture: Create CFcommon file for common Kconfig parameters
>       rcutorture: Remove RCU dependencies from ver_functions.sh API
>       rcutorture: Rename kvm-test-1-rcu.sh
>       rcutorture: Introduce "rcu" directory level underneath configs
>       locktorture: Add vestigial locktorture configuration
>       rcutorture: Gracefully handle NULL cleanup hooks
>       locktorture: Add kvm-recheck.sh plug-in for locktorture
>       rcutorture: Place kvm-test-1-run.sh output into res directory
>       rcutorture: Add a lock_busted to test the test
>       rcutorture: Save kvm.sh output to log
>       Documentation/memory-barriers.txt: Clarify release/acquire ordering
>       notifier: Substitute rcu_access_pointer() for rcu_dereference_raw()
>       Merge branches 'doc.2014.02.24a', 'fixes.2014.02.26a' and 'rt.2014.02.17b' into HEAD
>       Merge branch 'torture.2014.02.23a' into HEAD
> 
> Paul Gortmaker (2):
>       rcu: Fix sparse warning for rcu_expedited from kernel/ksysfs.c
>       rcu: Ensure kernel/rcu/rcu.h can be sourced/used stand-alone
> 
> Shaibal Dutta (1):
>       rcu: Move SRCU grace period work to power efficient workqueue
> 
>  Documentation/RCU/RTFP.txt                         | 149 ++-
>  Documentation/RCU/checklist.txt                    |  18 +-
>  Documentation/kernel-per-CPU-kthreads.txt          |  13 +-
>  Documentation/memory-barriers.txt                  | 137 ++-
>  fs/file.c                                          |   2 +-
>  include/linux/rculist.h                            |  17 +-
>  include/linux/rcupdate.h                           |  94 +-
>  include/linux/rcutiny.h                            |  10 +-
>  include/linux/rcutree.h                            |   6 +-
>  include/linux/srcu.h                               |   4 +-
>  include/linux/torture.h                            | 100 +++
>  kernel/Makefile                                    |   1 +
>  kernel/ksysfs.c                                    |   2 +
>  kernel/locking/Makefile                            |   1 +
>  kernel/locking/locktorture.c                       | 452 ++++++++++
>  kernel/notifier.c                                  |   2 +-
>  kernel/rcu/Makefile                                |   2 +-
>  kernel/rcu/rcu.h                                   |   7 +-
>  kernel/rcu/{torture.c => rcutorture.c}             | 996 +++++----------------
>  kernel/rcu/srcu.c                                  |  11 +-
>  kernel/rcu/tiny.c                                  |   8 +-
>  kernel/rcu/tiny_plugin.h                           |   4 +-
>  kernel/rcu/tree.c                                  |  18 +-
>  kernel/rcu/tree.h                                  |   4 +-
>  kernel/rcu/tree_plugin.h                           |  19 +-
>  kernel/rcu/tree_trace.c                            |   6 +-
>  kernel/rcu/update.c                                |   5 +-
>  kernel/torture.c                                   | 719 +++++++++++++++
>  lib/Kconfig.debug                                  |  20 +
>  .../testing/selftests/rcutorture/bin/functions.sh  |   1 +
>  .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |  51 ++
>  .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |  51 ++
>  .../selftests/rcutorture/bin/kvm-recheck.sh        |  13 +-
>  .../bin/{kvm-test-1-rcu.sh => kvm-test-1-run.sh}   |  53 +-
>  tools/testing/selftests/rcutorture/bin/kvm.sh      | 276 +++++-
>  .../selftests/rcutorture/configs/lock/BUSTED       |   6 +
>  .../selftests/rcutorture/configs/lock/BUSTED.boot  |   1 +
>  .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
>  .../selftests/rcutorture/configs/lock/CFcommon     |   2 +
>  .../selftests/rcutorture/configs/lock/LOCK01       |   6 +
>  .../rcutorture/configs/lock/ver_functions.sh       |  43 +
>  .../selftests/rcutorture/configs/rcu/BUSTED        |   7 +
>  .../selftests/rcutorture/configs/rcu/BUSTED.boot   |   1 +
>  .../selftests/rcutorture/configs/{ => rcu}/CFLIST  |   0
>  .../selftests/rcutorture/configs/rcu/CFcommon      |   2 +
>  .../selftests/rcutorture/configs/{ => rcu}/SRCU-N  |   3 +-
>  .../rcutorture/configs/{ => rcu}/SRCU-N.boot       |   0
>  .../selftests/rcutorture/configs/{ => rcu}/SRCU-P  |   1 -
>  .../rcutorture/configs/{ => rcu}/SRCU-P.boot       |   0
>  .../selftests/rcutorture/configs/{ => rcu}/TINY01  |   1 -
>  .../selftests/rcutorture/configs/{ => rcu}/TINY02  |   1 -
>  .../selftests/rcutorture/configs/{ => rcu}/TREE01  |   1 -
>  .../rcutorture/configs/{ => rcu}/TREE01.boot       |   0
>  .../selftests/rcutorture/configs/{ => rcu}/TREE02  |   3 +-
>  .../selftests/rcutorture/configs/{ => rcu}/TREE03  |   1 -
>  .../selftests/rcutorture/configs/{ => rcu}/TREE04  |   1 -
>  .../rcutorture/configs/{ => rcu}/TREE04.boot       |   0
>  .../selftests/rcutorture/configs/{ => rcu}/TREE05  |   1 -
>  .../rcutorture/configs/{ => rcu}/TREE05.boot       |   0
>  .../selftests/rcutorture/configs/{ => rcu}/TREE06  |   1 -
>  .../selftests/rcutorture/configs/{ => rcu}/TREE07  |   1 -
>  .../selftests/rcutorture/configs/{ => rcu}/TREE08  |   1 -
>  .../rcutorture/configs/{ => rcu}/TREE08-T          |   1 -
>  .../selftests/rcutorture/configs/{ => rcu}/TREE09  |   1 -
>  .../rcutorture/configs/{ => rcu}/v0.0/CFLIST       |   0
>  .../configs/{ => rcu}/v0.0/N1-S-T-NH-SD-SMP-HP     |   0
>  .../configs/{ => rcu}/v0.0/N2-2-t-nh-sd-SMP-hp     |   0
>  .../configs/{ => rcu}/v0.0/N3-3-T-nh-SD-SMP-hp     |   0
>  .../configs/{ => rcu}/v0.0/N4-A-t-NH-sd-SMP-HP     |   0
>  .../configs/{ => rcu}/v0.0/N5-U-T-NH-sd-SMP-hp     |   0
>  .../rcutorture/configs/{ => rcu}/v0.0/NT1-nh       |   0
>  .../rcutorture/configs/{ => rcu}/v0.0/NT3-NH       |   0
>  .../configs/{ => rcu}/v0.0/P1-S-T-NH-SD-SMP-HP     |   0
>  .../configs/{ => rcu}/v0.0/P2-2-t-nh-sd-SMP-hp     |   0
>  .../configs/{ => rcu}/v0.0/P3-3-T-nh-SD-SMP-hp     |   0
>  .../configs/{ => rcu}/v0.0/P4-A-t-NH-sd-SMP-HP     |   0
>  .../configs/{ => rcu}/v0.0/P5-U-T-NH-sd-SMP-hp     |   0
>  .../rcutorture/configs/{ => rcu}/v0.0/PT1-nh       |   0
>  .../rcutorture/configs/{ => rcu}/v0.0/PT2-NH       |   0
>  .../configs/{ => rcu}/v0.0/ver_functions.sh        |  22 +-
>  .../rcutorture/configs/{ => rcu}/v3.12/CFLIST      |   0
>  .../configs/{ => rcu}/v3.12/N1-S-T-NH-SD-SMP-HP    |   0
>  .../configs/{ => rcu}/v3.12/N2-2-t-nh-sd-SMP-hp    |   0
>  .../configs/{ => rcu}/v3.12/N3-3-T-nh-SD-SMP-hp    |   0
>  .../configs/{ => rcu}/v3.12/N4-A-t-NH-sd-SMP-HP    |   0
>  .../configs/{ => rcu}/v3.12/N5-U-T-NH-sd-SMP-hp    |   0
>  .../configs/{ => rcu}/v3.12/N6---t-nh-SD-smp-hp    |   0
>  .../configs/{ => rcu}/v3.12/N7-4-T-NH-SD-SMP-HP    |   0
>  .../configs/{ => rcu}/v3.12/N8-2-T-NH-SD-SMP-HP    |   0
>  .../rcutorture/configs/{ => rcu}/v3.12/NT1-nh      |   0
>  .../rcutorture/configs/{ => rcu}/v3.12/NT3-NH      |   0
>  .../configs/{ => rcu}/v3.12/P1-S-T-NH-SD-SMP-HP    |   0
>  .../configs/{ => rcu}/v3.12/P2-2-t-nh-sd-SMP-hp    |   0
>  .../configs/{ => rcu}/v3.12/P3-3-T-nh-SD-SMP-hp    |   0
>  .../configs/{ => rcu}/v3.12/P4-A-t-NH-sd-SMP-HP    |   0
>  .../configs/{ => rcu}/v3.12/P5-U-T-NH-sd-SMP-hp    |   0
>  .../configs/{ => rcu}/v3.12/P6---t-nh-SD-smp-hp    |   0
>  .../configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP    |   0
>  .../{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-all        |   0
>  .../{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-none       |   0
>  .../configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-hp    |   0
>  .../rcutorture/configs/{ => rcu}/v3.12/PT1-nh      |   0
>  .../rcutorture/configs/{ => rcu}/v3.12/PT2-NH      |   0
>  .../rcutorture/configs/{ => rcu}/v3.3/CFLIST       |   0
>  .../configs/{ => rcu}/v3.3/N1-S-T-NH-SD-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.3/N2-2-t-nh-sd-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.3/N3-3-T-nh-SD-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.3/N4-A-t-NH-sd-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.3/N5-U-T-NH-sd-SMP-hp     |   0
>  .../rcutorture/configs/{ => rcu}/v3.3/NT1-nh       |   0
>  .../rcutorture/configs/{ => rcu}/v3.3/NT3-NH       |   0
>  .../configs/{ => rcu}/v3.3/P1-S-T-NH-SD-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.3/P2-2-t-nh-sd-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.3/P3-3-T-nh-SD-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.3/P4-A-t-NH-sd-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.3/P5-U-T-NH-sd-SMP-hp     |   0
>  .../rcutorture/configs/{ => rcu}/v3.3/PT1-nh       |   0
>  .../rcutorture/configs/{ => rcu}/v3.3/PT2-NH       |   0
>  .../configs/{ => rcu/v3.3}/ver_functions.sh        |  28 +-
>  .../rcutorture/configs/{ => rcu}/v3.5/CFLIST       |   0
>  .../configs/{ => rcu}/v3.5/N1-S-T-NH-SD-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.5/N2-2-t-nh-sd-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.5/N3-3-T-nh-SD-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.5/N4-A-t-NH-sd-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.5/N5-U-T-NH-sd-SMP-hp     |   0
>  .../rcutorture/configs/{ => rcu}/v3.5/NT1-nh       |   0
>  .../rcutorture/configs/{ => rcu}/v3.5/NT3-NH       |   0
>  .../configs/{ => rcu}/v3.5/P1-S-T-NH-SD-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.5/P2-2-t-nh-sd-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.5/P3-3-T-nh-SD-SMP-hp     |   0
>  .../configs/{ => rcu}/v3.5/P4-A-t-NH-sd-SMP-HP     |   0
>  .../configs/{ => rcu}/v3.5/P5-U-T-NH-sd-SMP-hp     |   0
>  .../rcutorture/configs/{ => rcu}/v3.5/PT1-nh       |   0
>  .../rcutorture/configs/{ => rcu}/v3.5/PT2-NH       |   0
>  .../configs/{ => rcu}/v3.5/ver_functions.sh        |  23 +-
>  .../configs/{v3.3 => rcu}/ver_functions.sh         |  26 +-
>  .../{TREE_RCU-Kconfig.txt => TREE_RCU-kconfig.txt} |   0
>  137 files changed, 2384 insertions(+), 1074 deletions(-)
>  create mode 100644 include/linux/torture.h
>  create mode 100644 kernel/locking/locktorture.c
>  rename kernel/rcu/{torture.c => rcutorture.c} (59%)
>  create mode 100644 kernel/torture.c
>  create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
>  create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
>  rename tools/testing/selftests/rcutorture/bin/{kvm-test-1-rcu.sh => kvm-test-1-run.sh} (79%)
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/BUSTED
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/CFLIST
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/CFcommon
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK01
>  create mode 100644 tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/BUSTED
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/CFLIST (100%)
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/CFcommon
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-N (75%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-N.boot (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-P (86%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/SRCU-P.boot (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TINY01 (92%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TINY02 (92%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE01 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE01.boot (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE02 (92%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE03 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE04 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE04.boot (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE05 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE05.boot (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE06 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE07 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE08 (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE08-T (96%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/TREE09 (95%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/CFLIST (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/N5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/NT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/NT3-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/P5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/PT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/PT2-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v0.0/ver_functions.sh (70%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/CFLIST (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N6---t-nh-SD-smp-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N7-4-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/N8-2-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/NT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/NT3-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P6---t-nh-SD-smp-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-all (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-HP-none (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/P7-4-T-NH-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/PT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.12/PT2-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/CFLIST (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/N5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/NT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/NT3-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/P5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/PT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.3/PT2-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu/v3.3}/ver_functions.sh (72%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/CFLIST (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/N5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/NT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/NT3-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P1-S-T-NH-SD-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P2-2-t-nh-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P3-3-T-nh-SD-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P4-A-t-NH-sd-SMP-HP (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/P5-U-T-NH-sd-SMP-hp (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/PT1-nh (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/PT2-NH (100%)
>  rename tools/testing/selftests/rcutorture/configs/{ => rcu}/v3.5/ver_functions.sh (69%)
>  rename tools/testing/selftests/rcutorture/configs/{v3.3 => rcu}/ver_functions.sh (66%)
>  rename tools/testing/selftests/rcutorture/doc/{TREE_RCU-Kconfig.txt => TREE_RCU-kconfig.txt} (100%)

Pulled, thanks a lot Paul!

	Ingo
