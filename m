Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaATLmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:42:22 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46884 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaATLmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:42:15 -0500
Date: Mon, 20 Jan 2014 12:42:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU updates for v3.14
Message-ID: <20140120114210.GA9951@gmail.com>
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

   # HEAD: 73a7ac2808fa52bdab1781646568b6f90c3d7034 Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The main RCU changes in this cycle are:
    
   * Add RCU torture scripts/tooling.
   
   * Static analysis improvements.

   * Update RCU documentation.
    
   * Miscellaneous fixes.
    
 Thanks,

	Ingo

------------------>
Chen Gang (1):
      rcu/torture: Dynamically allocate SRCU output buffer to avoid overflow

Fengguang Wu (1):
      rcu: Fix coccinelle warnings

Josh Triplett (1):
      rcu: Make rcu_assign_pointer's assignment volatile and type-safe

Lai Jiangshan (1):
      rcu: Warn on allegedly impossible rcu_read_unlock_special() from irq

Paul E. McKenney (46):
      rcu: Fix typo in Documentation/RCU/trace.txt
      rcu: Fix formatting blows in kernel-parameters.txt
      documentation: Fix circular-buffer example.
      documentation: Update circular buffer for load-acquire/store-release
      rcu: Kick CPU halfway to RCU CPU stall warning
      rcu: Fix and comment ordering around wait_event()
      rcu: Break call_rcu() deadlock involving scheduler and perf
      rcu: Allow task-level idle entry/exit nesting
      rcu: Fix srcu_barrier() docbook header
      rcu: Let the world know when RCU adjusts its geometry
      rcutorture: Add KVM-based test framework
      rcutorture: Add datestamp argument to kvm.sh
      rcutorture: Add kernel-version argument
      rcutorture: Add per-version default Kconfig fragments and module parameters
      rcutorture: Add per-Kconfig fragment boot parameters
      rcutorture: Add v3.12 version, which adds sysidle testing
      rcutorture: Add SRCU Kconfig-fragment files
      rcutorture: Refactor TREE_RCU test cases
      rcutorture: Refactor TINY_RCU test cases
      rcutorture: Make test output less chatty
      rcutorture: Eliminate duplicate .config-check code
      rcutorture: Abstract qemu-flavor identification
      rcutorture: Remove decorative qemu argument
      rcutorture: Eliminate --rcu-kvm argument
      rcutorture: Refactor to enable non-x86 architectures
      rcutorture: Allow Kconfig-related boot parameters to override
      rcutorture: Eliminate configdir argument from kvm-recheck.sh script
      rcutorture: Add --buildonly dry-run capability
      rcutorture: Add --bootargs argument to specify additional boot arguments
      rcutorture: Add --qemu-args argument to kvm.sh
      rcutorture: Add --no-initrd argument to kvm.sh
      rcutorture: Add --kmake-arg argument to kvm.sh
      rcutorture: Add tracing-enabled version of TREE08
      rcutorture: Update comment in kvm.sh listing typical RCU trace events
      rcutorture: Test summary at end of run with less chattiness
      rcutorture: Record results from repeated runs of the same test scenario
      rcutorture: Flag errors and warnings with color coding
      rcutorture: Move checkarg to functions.sh
      rcutorture: Stop tracking FSF's postal address
      rcu: Fix CONFIG_RCU_FANOUT_EXACT for odd fanout/leaf values
      rcu: Improve SRCU's grace-period comments
      rcu: Provide better diagnostics for blocking in RCU callback functions
      rcu: Add comment on evaluate-once properties of rcu_assign_pointer().
      bonding: Use RCU_INIT_POINTER() for better overhead and for sparse
      rcu: Add an RCU_INITIALIZER for global RCU-protected pointers
      rcu: Don't activate RCU core on NO_HZ_FULL CPUs

Teodora Baluta (2):
      rcu: Remove "extern" from function declarations in include/linux/*rcu*.h
      rcu: Remove "extern" from function declarations in kernel/rcu/rcu.h


 Documentation/RCU/trace.txt                        |  22 ++-
 Documentation/circular-buffers.txt                 |  45 +++--
 Documentation/kernel-parameters.txt                |   9 +-
 MAINTAINERS                                        |   6 +
 drivers/net/bonding/bond_main.c                    |   2 +-
 include/linux/rculist.h                            |   4 +-
 include/linux/rcupdate.h                           | 153 ++++++++-------
 include/linux/rcutiny.h                            |   2 +-
 include/linux/rcutree.h                            |  36 ++--
 kernel/rcu/rcu.h                                   |   5 +-
 kernel/rcu/srcu.c                                  |  57 +++++-
 kernel/rcu/torture.c                               |  75 ++++----
 kernel/rcu/tree.c                                  |  79 ++++++--
 kernel/rcu/tree.h                                  |  12 +-
 kernel/rcu/tree_plugin.h                           |  89 +++++++--
 kernel/rcu/tree_trace.c                            |   3 +-
 kernel/rcu/update.c                                |   5 +
 tools/testing/selftests/rcutorture/.gitignore      |   6 +
 .../selftests/rcutorture/bin/config2frag.sh        |  25 +++
 .../selftests/rcutorture/bin/configNR_CPUS.sh      |  45 +++++
 .../selftests/rcutorture/bin/configcheck.sh        |  54 ++++++
 .../testing/selftests/rcutorture/bin/configinit.sh |  74 ++++++++
 tools/testing/selftests/rcutorture/bin/cpus2use.sh |  41 ++++
 .../testing/selftests/rcutorture/bin/functions.sh  | 198 +++++++++++++++++++
 .../testing/selftests/rcutorture/bin/kvm-build.sh  |  71 +++++++
 .../selftests/rcutorture/bin/kvm-recheck.sh        |  44 +++++
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     | 192 +++++++++++++++++++
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 210 +++++++++++++++++++++
 .../selftests/rcutorture/bin/parse-build.sh        |  57 ++++++
 .../selftests/rcutorture/bin/parse-console.sh      |  41 ++++
 .../selftests/rcutorture/bin/parse-rcutorture.sh   | 106 +++++++++++
 tools/testing/selftests/rcutorture/configs/CFLIST  |  13 ++
 tools/testing/selftests/rcutorture/configs/SRCU-N  |   8 +
 .../selftests/rcutorture/configs/SRCU-N.boot       |   1 +
 tools/testing/selftests/rcutorture/configs/SRCU-P  |   8 +
 .../selftests/rcutorture/configs/SRCU-P.boot       |   1 +
 tools/testing/selftests/rcutorture/configs/TINY01  |  13 ++
 tools/testing/selftests/rcutorture/configs/TINY02  |  13 ++
 tools/testing/selftests/rcutorture/configs/TREE01  |  23 +++
 .../selftests/rcutorture/configs/TREE01.boot       |   1 +
 tools/testing/selftests/rcutorture/configs/TREE02  |  26 +++
 tools/testing/selftests/rcutorture/configs/TREE03  |  23 +++
 tools/testing/selftests/rcutorture/configs/TREE04  |  25 +++
 .../selftests/rcutorture/configs/TREE04.boot       |   1 +
 tools/testing/selftests/rcutorture/configs/TREE05  |  25 +++
 .../selftests/rcutorture/configs/TREE05.boot       |   1 +
 tools/testing/selftests/rcutorture/configs/TREE06  |  26 +++
 tools/testing/selftests/rcutorture/configs/TREE07  |  24 +++
 tools/testing/selftests/rcutorture/configs/TREE08  |  26 +++
 .../testing/selftests/rcutorture/configs/TREE08-T  |  26 +++
 tools/testing/selftests/rcutorture/configs/TREE09  |  21 +++
 .../selftests/rcutorture/configs/v0.0/CFLIST       |  14 ++
 .../rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP    |  18 ++
 .../rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp    |  20 ++
 .../rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp    |  22 +++
 .../rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP    |  18 ++
 .../rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp    |  22 +++
 .../selftests/rcutorture/configs/v0.0/NT1-nh       |  23 +++
 .../selftests/rcutorture/configs/v0.0/NT3-NH       |  20 ++
 .../rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP    |  19 ++
 .../rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp    |  20 ++
 .../rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp    |  20 ++
 .../rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP    |  22 +++
 .../rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp    |  28 +++
 .../selftests/rcutorture/configs/v0.0/PT1-nh       |  23 +++
 .../selftests/rcutorture/configs/v0.0/PT2-NH       |  22 +++
 .../rcutorture/configs/v0.0/ver_functions.sh       |  35 ++++
 .../selftests/rcutorture/configs/v3.12/CFLIST      |  17 ++
 .../rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP   |  19 ++
 .../rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp   |  20 ++
 .../rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp   |  22 +++
 .../rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP   |  18 ++
 .../rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp   |  22 +++
 .../rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp   |  19 ++
 .../rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP   |  26 +++
 .../rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP   |  22 +++
 .../selftests/rcutorture/configs/v3.12/NT1-nh      |  23 +++
 .../selftests/rcutorture/configs/v3.12/NT3-NH      |  20 ++
 .../rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP   |  20 ++
 .../rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp   |  20 ++
 .../rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp   |  20 ++
 .../rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP   |  22 +++
 .../rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp   |  28 +++
 .../rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp   |  18 ++
 .../rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP   |  30 +++
 .../configs/v3.12/P7-4-T-NH-SD-SMP-HP-all          |  30 +++
 .../configs/v3.12/P7-4-T-NH-SD-SMP-HP-none         |  30 +++
 .../rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp   |  30 +++
 .../selftests/rcutorture/configs/v3.12/PT1-nh      |  23 +++
 .../selftests/rcutorture/configs/v3.12/PT2-NH      |  22 +++
 .../selftests/rcutorture/configs/v3.3/CFLIST       |  14 ++
 .../rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP    |  19 ++
 .../rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp    |  20 ++
 .../rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp    |  22 +++
 .../rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP    |  18 ++
 .../rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp    |  22 +++
 .../selftests/rcutorture/configs/v3.3/NT1-nh       |  23 +++
 .../selftests/rcutorture/configs/v3.3/NT3-NH       |  20 ++
 .../rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP    |  20 ++
 .../rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp    |  20 ++
 .../rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp    |  20 ++
 .../rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP    |  22 +++
 .../rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp    |  28 +++
 .../selftests/rcutorture/configs/v3.3/PT1-nh       |  23 +++
 .../selftests/rcutorture/configs/v3.3/PT2-NH       |  22 +++
 .../rcutorture/configs/v3.3/ver_functions.sh       |  41 ++++
 .../selftests/rcutorture/configs/v3.5/CFLIST       |  14 ++
 .../rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP    |  19 ++
 .../rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp    |  20 ++
 .../rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp    |  22 +++
 .../rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP    |  18 ++
 .../rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp    |  22 +++
 .../selftests/rcutorture/configs/v3.5/NT1-nh       |  23 +++
 .../selftests/rcutorture/configs/v3.5/NT3-NH       |  20 ++
 .../rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP    |  20 ++
 .../rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp    |  20 ++
 .../rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp    |  20 ++
 .../rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP    |  22 +++
 .../rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp    |  28 +++
 .../selftests/rcutorture/configs/v3.5/PT1-nh       |  23 +++
 .../selftests/rcutorture/configs/v3.5/PT2-NH       |  22 +++
 .../rcutorture/configs/v3.5/ver_functions.sh       |  46 +++++
 .../selftests/rcutorture/configs/ver_functions.sh  |  46 +++++
 .../testing/selftests/rcutorture/doc/TINY_RCU.txt  |  40 ++++
 .../selftests/rcutorture/doc/TREE_RCU-Kconfig.txt  |  95 ++++++++++
 tools/testing/selftests/rcutorture/doc/initrd.txt  |  90 +++++++++
 .../selftests/rcutorture/doc/rcu-test-image.txt    |  42 +++++
 127 files changed, 3768 insertions(+), 198 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/.gitignore
 create mode 100644 tools/testing/selftests/rcutorture/bin/config2frag.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/configcheck.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/configinit.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/cpus2use.sh
 create mode 100644 tools/testing/selftests/rcutorture/bin/functions.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-build.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
 create mode 100644 tools/testing/selftests/rcutorture/bin/kvm.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-build.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-console.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-N
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-N.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-P
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-P.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TINY01
 create mode 100644 tools/testing/selftests/rcutorture/configs/TINY02
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE01
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE02
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE03
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE04
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE04.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE05
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE05.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE06
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE07
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE08
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE08-T
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE09
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
 create mode 100644 tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
 create mode 100644 tools/testing/selftests/rcutorture/doc/initrd.txt
 create mode 100644 tools/testing/selftests/rcutorture/doc/rcu-test-image.txt

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index f3778f8..910870b 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -396,14 +396,14 @@ o	Each element of the form "3/3 ..>. 0:7 ^0" represents one rcu_node
 
 The output of "cat rcu/rcu_sched/rcu_pending" looks as follows:
 
-  0!np=26111 qsp=29 rpq=5386 cbr=1 cng=570 gpc=3674 gps=577 nn=15903
-  1!np=28913 qsp=35 rpq=6097 cbr=1 cng=448 gpc=3700 gps=554 nn=18113
-  2!np=32740 qsp=37 rpq=6202 cbr=0 cng=476 gpc=4627 gps=546 nn=20889
-  3 np=23679 qsp=22 rpq=5044 cbr=1 cng=415 gpc=3403 gps=347 nn=14469
-  4!np=30714 qsp=4 rpq=5574 cbr=0 cng=528 gpc=3931 gps=639 nn=20042
-  5 np=28910 qsp=2 rpq=5246 cbr=0 cng=428 gpc=4105 gps=709 nn=18422
-  6!np=38648 qsp=5 rpq=7076 cbr=0 cng=840 gpc=4072 gps=961 nn=25699
-  7 np=37275 qsp=2 rpq=6873 cbr=0 cng=868 gpc=3416 gps=971 nn=25147
+  0!np=26111 qsp=29 rpq=5386 cbr=1 cng=570 gpc=3674 gps=577 nn=15903 ndw=0
+  1!np=28913 qsp=35 rpq=6097 cbr=1 cng=448 gpc=3700 gps=554 nn=18113 ndw=0
+  2!np=32740 qsp=37 rpq=6202 cbr=0 cng=476 gpc=4627 gps=546 nn=20889 ndw=0
+  3 np=23679 qsp=22 rpq=5044 cbr=1 cng=415 gpc=3403 gps=347 nn=14469 ndw=0
+  4!np=30714 qsp=4 rpq=5574 cbr=0 cng=528 gpc=3931 gps=639 nn=20042 ndw=0
+  5 np=28910 qsp=2 rpq=5246 cbr=0 cng=428 gpc=4105 gps=709 nn=18422 ndw=0
+  6!np=38648 qsp=5 rpq=7076 cbr=0 cng=840 gpc=4072 gps=961 nn=25699 ndw=0
+  7 np=37275 qsp=2 rpq=6873 cbr=0 cng=868 gpc=3416 gps=971 nn=25147 ndw=0
 
 The fields are as follows:
 
@@ -432,6 +432,10 @@ o	"gpc" is the number of times that an old grace period had
 o	"gps" is the number of times that a new grace period had started,
 	but this CPU was not yet aware of it.
 
+o	"ndw" is the number of times that a wakeup of an rcuo
+	callback-offload kthread had to be deferred in order to avoid
+	deadlock.
+
 o	"nn" is the number of times that this CPU needed nothing.
 
 
@@ -443,7 +447,7 @@ The output of "cat rcu/rcuboost" looks as follows:
     balk: nt=0 egt=6541 bt=0 nb=0 ny=126 nos=0
 
 This information is output only for rcu_preempt.  Each two-line entry
-corresponds to a leaf rcu_node strcuture.  The fields are as follows:
+corresponds to a leaf rcu_node structure.  The fields are as follows:
 
 o	"n:m" is the CPU-number range for the corresponding two-line
 	entry.  In the sample output above, the first entry covers
diff --git a/Documentation/circular-buffers.txt b/Documentation/circular-buffers.txt
index 8117e5b..88951b1 100644
--- a/Documentation/circular-buffers.txt
+++ b/Documentation/circular-buffers.txt
@@ -160,6 +160,7 @@ The producer will look something like this:
 	spin_lock(&producer_lock);
 
 	unsigned long head = buffer->head;
+	/* The spin_unlock() and next spin_lock() provide needed ordering. */
 	unsigned long tail = ACCESS_ONCE(buffer->tail);
 
 	if (CIRC_SPACE(head, tail, buffer->size) >= 1) {
@@ -168,9 +169,8 @@ The producer will look something like this:
 
 		produce_item(item);
 
-		smp_wmb(); /* commit the item before incrementing the head */
-
-		buffer->head = (head + 1) & (buffer->size - 1);
+		smp_store_release(buffer->head,
+				  (head + 1) & (buffer->size - 1));
 
 		/* wake_up() will make sure that the head is committed before
 		 * waking anyone up */
@@ -183,9 +183,14 @@ This will instruct the CPU that the contents of the new item must be written
 before the head index makes it available to the consumer and then instructs the
 CPU that the revised head index must be written before the consumer is woken.
 
-Note that wake_up() doesn't have to be the exact mechanism used, but whatever
-is used must guarantee a (write) memory barrier between the update of the head
-index and the change of state of the consumer, if a change of state occurs.
+Note that wake_up() does not guarantee any sort of barrier unless something
+is actually awakened.  We therefore cannot rely on it for ordering.  However,
+there is always one element of the array left empty.  Therefore, the
+producer must produce two elements before it could possibly corrupt the
+element currently being read by the consumer.  Therefore, the unlock-lock
+pair between consecutive invocations of the consumer provides the necessary
+ordering between the read of the index indicating that the consumer has
+vacated a given element and the write by the producer to that same element.
 
 
 THE CONSUMER
@@ -195,21 +200,20 @@ The consumer will look something like this:
 
 	spin_lock(&consumer_lock);
 
-	unsigned long head = ACCESS_ONCE(buffer->head);
+	/* Read index before reading contents at that index. */
+	unsigned long head = smp_load_acquire(buffer->head);
 	unsigned long tail = buffer->tail;
 
 	if (CIRC_CNT(head, tail, buffer->size) >= 1) {
-		/* read index before reading contents at that index */
-		smp_read_barrier_depends();
 
 		/* extract one item from the buffer */
 		struct item *item = buffer[tail];
 
 		consume_item(item);
 
-		smp_mb(); /* finish reading descriptor before incrementing tail */
-
-		buffer->tail = (tail + 1) & (buffer->size - 1);
+		/* Finish reading descriptor before incrementing tail. */
+		smp_store_release(buffer->tail,
+				  (tail + 1) & (buffer->size - 1));
 	}
 
 	spin_unlock(&consumer_lock);
@@ -218,12 +222,17 @@ This will instruct the CPU to make sure the index is up to date before reading
 the new item, and then it shall make sure the CPU has finished reading the item
 before it writes the new tail pointer, which will erase the item.
 
-
-Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
-This prevents the compiler from discarding and reloading its cached value -
-which some compilers will do across smp_read_barrier_depends().  This isn't
-strictly needed if you can be sure that the opposition index will _only_ be
-used the once.
+Note the use of ACCESS_ONCE() and smp_load_acquire() to read the
+opposition index.  This prevents the compiler from discarding and
+reloading its cached value - which some compilers will do across
+smp_read_barrier_depends().  This isn't strictly needed if you can
+be sure that the opposition index will _only_ be used the once.
+The smp_load_acquire() additionally forces the CPU to order against
+subsequent memory references.  Similarly, smp_store_release() is used
+in both algorithms to write the thread's index.  This documents the
+fact that we are writing to something that can be read concurrently,
+prevents the compiler from tearing the store, and enforces ordering
+against previous accesses.
 
 
 ===============
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..9063e74 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2625,7 +2625,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			for RCU-preempt, and "s" for RCU-sched, and "N"
 			is the CPU number.  This reduces OS jitter on the
 			offloaded CPUs, which can be useful for HPC and
-
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
@@ -2641,8 +2640,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			periodically wake up to do the polling.
 
 	rcutree.blimit=	[KNL]
-			Set maximum number of finished RCU callbacks to process
-			in one batch.
+			Set maximum number of finished RCU callbacks to
+			process in one batch.
 
 	rcutree.rcu_fanout_leaf= [KNL]
 			Increase the number of CPUs assigned to each
@@ -2661,8 +2660,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			value is one, and maximum value is HZ.
 
 	rcutree.qhimark= [KNL]
-			Set threshold of queued
-			RCU callbacks over which batch limiting is disabled.
+			Set threshold of queued RCU callbacks beyond which
+			batch limiting is disabled.
 
 	rcutree.qlowmark= [KNL]
 			Set threshold of queued RCU callbacks below which
diff --git a/MAINTAINERS b/MAINTAINERS
index 1344816..616b951 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7075,6 +7075,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcu/torture.c
 
+RCUTORTURE TEST FRAMEWORK
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
+F:	tools/testing/selftests/rcutorture
+
 RDC R-321X SoC
 M:	Florian Fainelli <florian@openwrt.org>
 S:	Maintained
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 398e299..698077b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1763,7 +1763,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	}
 
 	if (all) {
-		rcu_assign_pointer(bond->curr_active_slave, NULL);
+		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
 	} else if (oldcurrent == slave) {
 		/*
 		 * Note that we hold RTNL over this sequence, so there
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 45a0a9e..dbaf990 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -55,8 +55,8 @@ static inline void __list_add_rcu(struct list_head *new,
 	next->prev = new;
 }
 #else
-extern void __list_add_rcu(struct list_head *new,
-		struct list_head *prev, struct list_head *next);
+void __list_add_rcu(struct list_head *new,
+		    struct list_head *prev, struct list_head *next);
 #endif
 
 /**
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 39cbb88..3e355c6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -50,13 +50,13 @@ extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
-extern void rcutorture_record_test_transition(void);
-extern void rcutorture_record_progress(unsigned long vernum);
-extern void do_trace_rcu_torture_read(const char *rcutorturename,
-				      struct rcu_head *rhp,
-				      unsigned long secs,
-				      unsigned long c_old,
-				      unsigned long c);
+void rcutorture_record_test_transition(void);
+void rcutorture_record_progress(unsigned long vernum);
+void do_trace_rcu_torture_read(const char *rcutorturename,
+			       struct rcu_head *rhp,
+			       unsigned long secs,
+			       unsigned long c_old,
+			       unsigned long c);
 #else
 static inline void rcutorture_record_test_transition(void)
 {
@@ -65,11 +65,11 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 {
 }
 #ifdef CONFIG_RCU_TRACE
-extern void do_trace_rcu_torture_read(const char *rcutorturename,
-				      struct rcu_head *rhp,
-				      unsigned long secs,
-				      unsigned long c_old,
-				      unsigned long c);
+void do_trace_rcu_torture_read(const char *rcutorturename,
+			       struct rcu_head *rhp,
+			       unsigned long secs,
+			       unsigned long c_old,
+			       unsigned long c);
 #else
 #define do_trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
 	do { } while (0)
@@ -118,8 +118,8 @@ extern void do_trace_rcu_torture_read(const char *rcutorturename,
  * if CPU A and CPU B are the same CPU (but again only if the system has
  * more than one CPU).
  */
-extern void call_rcu(struct rcu_head *head,
-			      void (*func)(struct rcu_head *head));
+void call_rcu(struct rcu_head *head,
+	      void (*func)(struct rcu_head *head));
 
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
@@ -149,8 +149,8 @@ extern void call_rcu(struct rcu_head *head,
  * See the description of call_rcu() for more detailed information on
  * memory ordering guarantees.
  */
-extern void call_rcu_bh(struct rcu_head *head,
-			void (*func)(struct rcu_head *head));
+void call_rcu_bh(struct rcu_head *head,
+		 void (*func)(struct rcu_head *head));
 
 /**
  * call_rcu_sched() - Queue an RCU for invocation after sched grace period.
@@ -171,16 +171,16 @@ extern void call_rcu_bh(struct rcu_head *head,
  * See the description of call_rcu() for more detailed information on
  * memory ordering guarantees.
  */
-extern void call_rcu_sched(struct rcu_head *head,
-			   void (*func)(struct rcu_head *rcu));
+void call_rcu_sched(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu));
 
-extern void synchronize_sched(void);
+void synchronize_sched(void);
 
 #ifdef CONFIG_PREEMPT_RCU
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
-extern void rcu_read_unlock_special(struct task_struct *t);
+void __rcu_read_lock(void);
+void __rcu_read_unlock(void);
+void rcu_read_unlock_special(struct task_struct *t);
 void synchronize_rcu(void);
 
 /*
@@ -216,19 +216,19 @@ static inline int rcu_preempt_depth(void)
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
-extern void rcu_init(void);
-extern void rcu_sched_qs(int cpu);
-extern void rcu_bh_qs(int cpu);
-extern void rcu_check_callbacks(int cpu, int user);
+void rcu_init(void);
+void rcu_sched_qs(int cpu);
+void rcu_bh_qs(int cpu);
+void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
-extern void rcu_idle_enter(void);
-extern void rcu_idle_exit(void);
-extern void rcu_irq_enter(void);
-extern void rcu_irq_exit(void);
+void rcu_idle_enter(void);
+void rcu_idle_exit(void);
+void rcu_irq_enter(void);
+void rcu_irq_exit(void);
 
 #ifdef CONFIG_RCU_USER_QS
-extern void rcu_user_enter(void);
-extern void rcu_user_exit(void);
+void rcu_user_enter(void);
+void rcu_user_exit(void);
 #else
 static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
@@ -262,7 +262,7 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 	} while (0)
 
 #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
-extern bool __rcu_is_watching(void);
+bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
 
 /*
@@ -289,8 +289,8 @@ void wait_rcu_gp(call_rcu_func_t crf);
  * initialization.
  */
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
-extern void init_rcu_head_on_stack(struct rcu_head *head);
-extern void destroy_rcu_head_on_stack(struct rcu_head *head);
+void init_rcu_head_on_stack(struct rcu_head *head);
+void destroy_rcu_head_on_stack(struct rcu_head *head);
 #else /* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 static inline void init_rcu_head_on_stack(struct rcu_head *head)
 {
@@ -325,6 +325,7 @@ static inline void rcu_lock_release(struct lockdep_map *map)
 extern struct lockdep_map rcu_lock_map;
 extern struct lockdep_map rcu_bh_lock_map;
 extern struct lockdep_map rcu_sched_lock_map;
+extern struct lockdep_map rcu_callback_map;
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
@@ -362,7 +363,7 @@ static inline int rcu_read_lock_held(void)
  * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
  * hell.
  */
-extern int rcu_read_lock_bh_held(void);
+int rcu_read_lock_bh_held(void);
 
 /**
  * rcu_read_lock_sched_held() - might we be in RCU-sched read-side critical section?
@@ -448,7 +449,7 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
-extern int rcu_my_thread_group_empty(void);
+int rcu_my_thread_group_empty(void);
 
 /**
  * rcu_lockdep_assert - emit lockdep splat if specified condition not met
@@ -548,10 +549,48 @@ static inline void rcu_preempt_sleep_check(void)
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
-#define __rcu_assign_pointer(p, v, space) \
+
+/**
+ * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
+ * @v: The value to statically initialize with.
+ */
+#define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
+
+/**
+ * rcu_assign_pointer() - assign to RCU-protected pointer
+ * @p: pointer to assign to
+ * @v: value to assign (publish)
+ *
+ * Assigns the specified value to the specified RCU-protected
+ * pointer, ensuring that any concurrent RCU readers will see
+ * any prior initialization.
+ *
+ * Inserts memory barriers on architectures that require them
+ * (which is most of them), and also prevents the compiler from
+ * reordering the code that initializes the structure after the pointer
+ * assignment.  More importantly, this call documents which pointers
+ * will be dereferenced by RCU read-side code.
+ *
+ * In some special cases, you may use RCU_INIT_POINTER() instead
+ * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
+ * to the fact that it does not constrain either the CPU or the compiler.
+ * That said, using RCU_INIT_POINTER() when you should have used
+ * rcu_assign_pointer() is a very bad thing that results in
+ * impossible-to-diagnose memory corruption.  So please be careful.
+ * See the RCU_INIT_POINTER() comment header for details.
+ *
+ * Note that rcu_assign_pointer() evaluates each of its arguments only
+ * once, appearances notwithstanding.  One of the "extra" evaluations
+ * is in typeof() and the other visible only to sparse (__CHECKER__),
+ * neither of which actually execute the argument.  As with most cpp
+ * macros, this execute-arguments-only-once property is important, so
+ * please be careful when making changes to rcu_assign_pointer() and the
+ * other macros that it invokes.
+ */
+#define rcu_assign_pointer(p, v) \
 	do { \
 		smp_wmb(); \
-		(p) = (typeof(*v) __force space *)(v); \
+		ACCESS_ONCE(p) = RCU_INITIALIZER(v); \
 	} while (0)
 
 
@@ -890,32 +929,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 }
 
 /**
- * rcu_assign_pointer() - assign to RCU-protected pointer
- * @p: pointer to assign to
- * @v: value to assign (publish)
- *
- * Assigns the specified value to the specified RCU-protected
- * pointer, ensuring that any concurrent RCU readers will see
- * any prior initialization.
- *
- * Inserts memory barriers on architectures that require them
- * (which is most of them), and also prevents the compiler from
- * reordering the code that initializes the structure after the pointer
- * assignment.  More importantly, this call documents which pointers
- * will be dereferenced by RCU read-side code.
- *
- * In some special cases, you may use RCU_INIT_POINTER() instead
- * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
- * to the fact that it does not constrain either the CPU or the compiler.
- * That said, using RCU_INIT_POINTER() when you should have used
- * rcu_assign_pointer() is a very bad thing that results in
- * impossible-to-diagnose memory corruption.  So please be careful.
- * See the RCU_INIT_POINTER() comment header for details.
- */
-#define rcu_assign_pointer(p, v) \
-	__rcu_assign_pointer((p), (v), __rcu)
-
-/**
  * RCU_INIT_POINTER() - initialize an RCU protected pointer
  *
  * Initialize an RCU-protected pointer in special cases where readers
@@ -949,7 +962,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
-		p = (typeof(*v) __force __rcu *)(v); \
+		p = RCU_INITIALIZER(v); \
 	} while (0)
 
 /**
@@ -958,7 +971,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * GCC-style initialization for an RCU-protected pointer in a structure field.
  */
 #define RCU_POINTER_INITIALIZER(p, v) \
-		.p = (typeof(*v) __force __rcu *)(v)
+		.p = RCU_INITIALIZER(v)
 
 /*
  * Does the specified offset indicate that the corresponding rcu_head
@@ -1005,7 +1018,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
 #ifdef CONFIG_RCU_NOCB_CPU
-extern bool rcu_is_nocb_cpu(int cpu);
+bool rcu_is_nocb_cpu(int cpu);
 #else
 static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
@@ -1013,8 +1026,8 @@ static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
 
 /* Only for use by adaptive-ticks code. */
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
-extern bool rcu_sys_is_idle(void);
-extern void rcu_sysidle_force_exit(void);
+bool rcu_sys_is_idle(void);
+void rcu_sysidle_force_exit(void);
 #else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
 static inline bool rcu_sys_is_idle(void)
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 09ebcbe..6f01771 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -125,7 +125,7 @@ static inline void exit_rcu(void)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern int rcu_scheduler_active __read_mostly;
-extern void rcu_scheduler_starting(void);
+void rcu_scheduler_starting(void);
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 static inline void rcu_scheduler_starting(void)
 {
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 4b9c815..72137ee 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,9 +30,9 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-extern void rcu_note_context_switch(int cpu);
-extern int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
-extern void rcu_cpu_stall_reset(void);
+void rcu_note_context_switch(int cpu);
+int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
+void rcu_cpu_stall_reset(void);
 
 /*
  * Note a virtualization-based context switch.  This is simply a
@@ -44,9 +44,9 @@ static inline void rcu_virt_note_context_switch(int cpu)
 	rcu_note_context_switch(cpu);
 }
 
-extern void synchronize_rcu_bh(void);
-extern void synchronize_sched_expedited(void);
-extern void synchronize_rcu_expedited(void);
+void synchronize_rcu_bh(void);
+void synchronize_sched_expedited(void);
+void synchronize_rcu_expedited(void);
 
 void kfree_call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 
@@ -71,25 +71,25 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched_expedited();
 }
 
-extern void rcu_barrier(void);
-extern void rcu_barrier_bh(void);
-extern void rcu_barrier_sched(void);
+void rcu_barrier(void);
+void rcu_barrier_bh(void);
+void rcu_barrier_sched(void);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
-extern long rcu_batches_completed_sched(void);
+long rcu_batches_completed(void);
+long rcu_batches_completed_bh(void);
+long rcu_batches_completed_sched(void);
 
-extern void rcu_force_quiescent_state(void);
-extern void rcu_bh_force_quiescent_state(void);
-extern void rcu_sched_force_quiescent_state(void);
+void rcu_force_quiescent_state(void);
+void rcu_bh_force_quiescent_state(void);
+void rcu_sched_force_quiescent_state(void);
 
-extern void exit_rcu(void);
+void exit_rcu(void);
 
-extern void rcu_scheduler_starting(void);
+void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
-extern bool rcu_is_watching(void);
+bool rcu_is_watching(void);
 
 #endif /* __LINUX_RCUTREE_H */
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 7859a0a..79c3877 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -96,19 +96,22 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
-extern void kfree(const void *);
+void kfree(const void *);
 
 static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
+	rcu_lock_acquire(&rcu_callback_map);
 	if (__is_kfree_rcu_offset(offset)) {
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
+		rcu_lock_release(&rcu_callback_map);
 		return 1;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
+		rcu_lock_release(&rcu_callback_map);
 		return 0;
 	}
 }
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 01d5ccb..3318d82 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -363,6 +363,29 @@ static void srcu_flip(struct srcu_struct *sp)
 /*
  * Enqueue an SRCU callback on the specified srcu_struct structure,
  * initiating grace-period processing if it is not already running.
+ *
+ * Note that all CPUs must agree that the grace period extended beyond
+ * all pre-existing SRCU read-side critical section.  On systems with
+ * more than one CPU, this means that when "func()" is invoked, each CPU
+ * is guaranteed to have executed a full memory barrier since the end of
+ * its last corresponding SRCU read-side critical section whose beginning
+ * preceded the call to call_rcu().  It also means that each CPU executing
+ * an SRCU read-side critical section that continues beyond the start of
+ * "func()" must have executed a memory barrier after the call_rcu()
+ * but before the beginning of that SRCU read-side critical section.
+ * Note that these guarantees include CPUs that are offline, idle, or
+ * executing in user mode, as well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked call_rcu() and CPU B invoked the
+ * resulting SRCU callback function "func()", then both CPU A and CPU
+ * B are guaranteed to execute a full memory barrier during the time
+ * interval between the call to call_rcu() and the invocation of "func()".
+ * This guarantee applies even if CPU A and CPU B are the same CPU (but
+ * again only if the system has more than one CPU).
+ *
+ * Of course, these guarantees apply only for invocations of call_srcu(),
+ * srcu_read_lock(), and srcu_read_unlock() that are all passed the same
+ * srcu_struct structure.
  */
 void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
 		void (*func)(struct rcu_head *head))
@@ -459,7 +482,30 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  * Note that it is illegal to call synchronize_srcu() from the corresponding
  * SRCU read-side critical section; doing so will result in deadlock.
  * However, it is perfectly legal to call synchronize_srcu() on one
- * srcu_struct from some other srcu_struct's read-side critical section.
+ * srcu_struct from some other srcu_struct's read-side critical section,
+ * as long as the resulting graph of srcu_structs is acyclic.
+ *
+ * There are memory-ordering constraints implied by synchronize_srcu().
+ * On systems with more than one CPU, when synchronize_srcu() returns,
+ * each CPU is guaranteed to have executed a full memory barrier since
+ * the end of its last corresponding SRCU-sched read-side critical section
+ * whose beginning preceded the call to synchronize_srcu().  In addition,
+ * each CPU having an SRCU read-side critical section that extends beyond
+ * the return from synchronize_srcu() is guaranteed to have executed a
+ * full memory barrier after the beginning of synchronize_srcu() and before
+ * the beginning of that SRCU read-side critical section.  Note that these
+ * guarantees include CPUs that are offline, idle, or executing in user mode,
+ * as well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked synchronize_srcu(), which returned
+ * to its caller on CPU B, then both CPU A and CPU B are guaranteed
+ * to have executed a full memory barrier during the execution of
+ * synchronize_srcu().  This guarantee applies even if CPU A and CPU B
+ * are the same CPU, but again only if the system has more than one CPU.
+ *
+ * Of course, these memory-ordering guarantees apply only when
+ * synchronize_srcu(), srcu_read_lock(), and srcu_read_unlock() are
+ * passed the same srcu_struct structure.
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
@@ -476,12 +522,8 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  * Wait for an SRCU grace period to elapse, but be more aggressive about
  * spinning rather than blocking when waiting.
  *
- * Note that it is also illegal to call synchronize_srcu_expedited()
- * from the corresponding SRCU read-side critical section;
- * doing so will result in deadlock.  However, it is perfectly legal
- * to call synchronize_srcu_expedited() on one srcu_struct from some
- * other srcu_struct's read-side critical section, as long as
- * the resulting graph of srcu_structs is acyclic.
+ * Note that synchronize_srcu_expedited() has the same deadlock and
+ * memory-ordering properties as does synchronize_srcu().
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
@@ -491,6 +533,7 @@ EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
 /**
  * srcu_barrier - Wait until all in-flight call_srcu() callbacks complete.
+ * @sp: srcu_struct on which to wait for in-flight callbacks.
  */
 void srcu_barrier(struct srcu_struct *sp)
 {
diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 3929cd4..732f8ae 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -139,8 +139,6 @@ MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
 #define VERBOSE_PRINTK_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
-static char printk_buf[4096];
-
 static int nrealreaders;
 static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
@@ -376,7 +374,7 @@ struct rcu_torture_ops {
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
-	int (*stats)(char *page);
+	void (*stats)(char *page);
 	int irq_capable;
 	int can_boost;
 	const char *name;
@@ -578,21 +576,19 @@ static void srcu_torture_barrier(void)
 	srcu_barrier(&srcu_ctl);
 }
 
-static int srcu_torture_stats(char *page)
+static void srcu_torture_stats(char *page)
 {
-	int cnt = 0;
 	int cpu;
 	int idx = srcu_ctl.completed & 0x1;
 
-	cnt += sprintf(&page[cnt], "%s%s per-CPU(idx=%d):",
+	page += sprintf(page, "%s%s per-CPU(idx=%d):",
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
-		cnt += sprintf(&page[cnt], " %d(%lu,%lu)", cpu,
+		page += sprintf(page, " %d(%lu,%lu)", cpu,
 			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
 			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
 	}
-	cnt += sprintf(&page[cnt], "\n");
-	return cnt;
+	sprintf(page, "\n");
 }
 
 static void srcu_torture_synchronize_expedited(void)
@@ -1052,10 +1048,9 @@ rcu_torture_reader(void *arg)
 /*
  * Create an RCU-torture statistics message in the specified buffer.
  */
-static int
+static void
 rcu_torture_printk(char *page)
 {
-	int cnt = 0;
 	int cpu;
 	int i;
 	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
@@ -1071,8 +1066,8 @@ rcu_torture_printk(char *page)
 		if (pipesummary[i] != 0)
 			break;
 	}
-	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
-	cnt += sprintf(&page[cnt],
+	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
+	page += sprintf(page,
 		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
@@ -1080,53 +1075,52 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_alloc),
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free));
-	cnt += sprintf(&page[cnt], "rtmbe: %d rtbke: %ld rtbre: %ld ",
+	page += sprintf(page, "rtmbe: %d rtbke: %ld rtbre: %ld ",
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
 		       n_rcu_torture_boost_rterror);
-	cnt += sprintf(&page[cnt], "rtbf: %ld rtb: %ld nt: %ld ",
+	page += sprintf(page, "rtbf: %ld rtb: %ld nt: %ld ",
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	cnt += sprintf(&page[cnt],
+	page += sprintf(page,
 		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
 		       n_online_successes, n_online_attempts,
 		       n_offline_successes, n_offline_attempts,
 		       min_online, max_online,
 		       min_offline, max_offline,
 		       sum_online, sum_offline, HZ);
-	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
+	page += sprintf(page, "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
 		       n_rcu_torture_barrier_error);
-	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
+	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_barrier_error != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
 	    n_rcu_torture_boost_failure != 0 ||
 	    i > 1) {
-		cnt += sprintf(&page[cnt], "!!! ");
+		page += sprintf(page, "!!! ");
 		atomic_inc(&n_rcu_torture_error);
 		WARN_ON_ONCE(1);
 	}
-	cnt += sprintf(&page[cnt], "Reader Pipe: ");
+	page += sprintf(page, "Reader Pipe: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		cnt += sprintf(&page[cnt], " %ld", pipesummary[i]);
-	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
-	cnt += sprintf(&page[cnt], "Reader Batch: ");
+		page += sprintf(page, " %ld", pipesummary[i]);
+	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
+	page += sprintf(page, "Reader Batch: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		cnt += sprintf(&page[cnt], " %ld", batchsummary[i]);
-	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
-	cnt += sprintf(&page[cnt], "Free-Block Circulation: ");
+		page += sprintf(page, " %ld", batchsummary[i]);
+	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
+	page += sprintf(page, "Free-Block Circulation: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
-		cnt += sprintf(&page[cnt], " %d",
+		page += sprintf(page, " %d",
 			       atomic_read(&rcu_torture_wcount[i]));
 	}
-	cnt += sprintf(&page[cnt], "\n");
+	page += sprintf(page, "\n");
 	if (cur_ops->stats)
-		cnt += cur_ops->stats(&page[cnt]);
-	return cnt;
+		cur_ops->stats(page);
 }
 
 /*
@@ -1140,10 +1134,17 @@ rcu_torture_printk(char *page)
 static void
 rcu_torture_stats_print(void)
 {
-	int cnt;
+	int size = nr_cpu_ids * 200 + 8192;
+	char *buf;
 
-	cnt = rcu_torture_printk(printk_buf);
-	pr_alert("%s", printk_buf);
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		pr_err("rcu-torture: Out of memory, need: %d", size);
+		return;
+	}
+	rcu_torture_printk(buf);
+	pr_alert("%s", buf);
+	kfree(buf);
 }
 
 /*
@@ -1578,6 +1579,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 {
 	long myid = (long)arg;
 	bool lastphase = 0;
+	bool newphase;
 	struct rcu_head rcu;
 
 	init_rcu_head_on_stack(&rcu);
@@ -1585,10 +1587,11 @@ static int rcu_torture_barrier_cbs(void *arg)
 	set_user_nice(current, 19);
 	do {
 		wait_event(barrier_cbs_wq[myid],
-			   barrier_phase != lastphase ||
+			   (newphase =
+			    ACCESS_ONCE(barrier_phase)) != lastphase ||
 			   kthread_should_stop() ||
 			   fullstop != FULLSTOP_DONTSTOP);
-		lastphase = barrier_phase;
+		lastphase = newphase;
 		smp_mb(); /* ensure barrier_phase load before ->call(). */
 		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
 			break;
@@ -1625,7 +1628,7 @@ static int rcu_torture_barrier(void *arg)
 		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
 			break;
 		n_barrier_attempts++;
-		cur_ops->cb_barrier();
+		cur_ops->cb_barrier(); /* Implies smp_mb() for wait_event(). */
 		if (atomic_read(&barrier_cbs_invoked) != n_barrier_cbs) {
 			n_rcu_torture_barrier_error++;
 			WARN_ON_ONCE(1);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dd08198..e37bd56 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -369,6 +369,9 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 				bool user)
 {
+	struct rcu_state *rsp;
+	struct rcu_data *rdp;
+
 	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused =
@@ -380,6 +383,10 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	for_each_rcu_flavor(rsp) {
+		rdp = this_cpu_ptr(rsp->rda);
+		do_nocb_deferred_wakeup(rdp);
+	}
 	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
@@ -411,11 +418,12 @@ static void rcu_eqs_enter(bool user)
 	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
-	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
+	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
 		rdtp->dynticks_nesting = 0;
-	else
+		rcu_eqs_enter_common(rdtp, oldval, user);
+	} else {
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
-	rcu_eqs_enter_common(rdtp, oldval, user);
+	}
 }
 
 /**
@@ -533,11 +541,12 @@ static void rcu_eqs_exit(bool user)
 	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
-	if (oldval & DYNTICK_TASK_NEST_MASK)
+	if (oldval & DYNTICK_TASK_NEST_MASK) {
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
-	else
+	} else {
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-	rcu_eqs_exit_common(rdtp, oldval, user);
+		rcu_eqs_exit_common(rdtp, oldval, user);
+	}
 }
 
 /**
@@ -716,7 +725,7 @@ bool rcu_lockdep_current_cpu_online(void)
 	bool ret;
 
 	if (in_nmi())
-		return 1;
+		return true;
 	preempt_disable();
 	rdp = this_cpu_ptr(&rcu_sched_data);
 	rnp = rdp->mynode;
@@ -755,6 +764,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 }
 
 /*
+ * This function really isn't for public consumption, but RCU is special in
+ * that context switches can allow the state machine to make progress.
+ */
+extern void resched_cpu(int cpu);
+
+/*
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
  * idle state since the last call to dyntick_save_progress_counter()
@@ -812,16 +827,34 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 */
 	rcu_kick_nohz_cpu(rdp->cpu);
 
+	/*
+	 * Alternatively, the CPU might be running in the kernel
+	 * for an extended period of time without a quiescent state.
+	 * Attempt to force the CPU through the scheduler to gain the
+	 * needed quiescent state, but only if the grace period has gone
+	 * on for an uncommonly long time.  If there are many stuck CPUs,
+	 * we will beat on the first one until it gets unstuck, then move
+	 * to the next.  Only do this for the primary flavor of RCU.
+	 */
+	if (rdp->rsp == rcu_state &&
+	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
+		rdp->rsp->jiffies_resched += 5;
+		resched_cpu(rdp->cpu);
+	}
+
 	return 0;
 }
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	unsigned long j = ACCESS_ONCE(jiffies);
+	unsigned long j1;
 
 	rsp->gp_start = j;
 	smp_wmb(); /* Record start time before stall time. */
-	rsp->jiffies_stall = j + rcu_jiffies_till_stall_check();
+	j1 = rcu_jiffies_till_stall_check();
+	rsp->jiffies_stall = j + j1;
+	rsp->jiffies_resched = j + j1 / 2;
 }
 
 /*
@@ -1509,6 +1542,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
 			__note_gp_changes(rsp, rnp, rdp);
+		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
@@ -1553,6 +1587,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			wait_event_interruptible(rsp->gp_wq,
 						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
+			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
 			cond_resched();
@@ -1582,6 +1617,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					(!ACCESS_ONCE(rnp->qsmask) &&
 					 !rcu_preempt_blocked_readers_cgp(rnp)),
 					j);
+			/* Locking provides needed memory barriers. */
 			/* If grace period done, leave loop. */
 			if (!ACCESS_ONCE(rnp->qsmask) &&
 			    !rcu_preempt_blocked_readers_cgp(rnp))
@@ -1901,13 +1937,13 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
  * Adopt the RCU callbacks from the specified rcu_state structure's
  * orphanage.  The caller must hold the ->orphan_lock.
  */
-static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+static void rcu_adopt_orphan_cbs(struct rcu_state *rsp, unsigned long flags)
 {
 	int i;
 	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
 
 	/* No-CBs CPUs are handled specially. */
-	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp))
+	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp, flags))
 		return;
 
 	/* Do the accounting first. */
@@ -1986,7 +2022,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 
 	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
 	rcu_send_cbs_to_orphanage(cpu, rsp, rnp, rdp);
-	rcu_adopt_orphan_cbs(rsp);
+	rcu_adopt_orphan_cbs(rsp, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
@@ -2303,6 +2339,9 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	/* If there are callbacks ready, invoke them. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
 		invoke_rcu_callbacks(rsp, rdp);
+
+	/* Do any needed deferred wakeups of rcuo kthreads. */
+	do_nocb_deferred_wakeup(rdp);
 }
 
 /*
@@ -2437,7 +2476,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 
 		if (cpu != -1)
 			rdp = per_cpu_ptr(rsp->rda, cpu);
-		offline = !__call_rcu_nocb(rdp, head, lazy);
+		offline = !__call_rcu_nocb(rdp, head, lazy, flags);
 		WARN_ON_ONCE(offline);
 		/* _call_rcu() is illegal on offline CPU; leak the callback. */
 		local_irq_restore(flags);
@@ -2757,6 +2796,10 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
+	/* Is this CPU a NO_HZ_FULL CPU that should ignore RCU? */
+	if (rcu_nohz_full_cpu(rsp))
+		return 0;
+
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
@@ -2790,6 +2833,12 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		return 1;
 	}
 
+	/* Does this CPU need a deferred NOCB wakeup? */
+	if (rcu_nocb_need_deferred_wakeup(rdp)) {
+		rdp->n_rp_nocb_defer_wakeup++;
+		return 1;
+	}
+
 	/* nothing to do */
 	rdp->n_rp_need_nothing++;
 	return 0;
@@ -3214,9 +3263,9 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 {
 	int i;
 
-	for (i = rcu_num_lvls - 1; i > 0; i--)
+	rsp->levelspread[rcu_num_lvls - 1] = rcu_fanout_leaf;
+	for (i = rcu_num_lvls - 2; i >= 0; i--)
 		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
-	rsp->levelspread[0] = rcu_fanout_leaf;
 }
 #else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
 static void __init rcu_init_levelspread(struct rcu_state *rsp)
@@ -3346,6 +3395,8 @@ static void __init rcu_init_geometry(void)
 	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF &&
 	    nr_cpu_ids == NR_CPUS)
 		return;
+	pr_info("RCU: Adjusting geometry for rcu_fanout_leaf=%d, nr_cpu_ids=%d\n",
+		rcu_fanout_leaf, nr_cpu_ids);
 
 	/*
 	 * Compute number of nodes that can be handled an rcu_node tree
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 52be957..8c19873 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -317,6 +317,7 @@ struct rcu_data {
 	unsigned long n_rp_cpu_needs_gp;
 	unsigned long n_rp_gp_completed;
 	unsigned long n_rp_gp_started;
+	unsigned long n_rp_nocb_defer_wakeup;
 	unsigned long n_rp_need_nothing;
 
 	/* 6) _rcu_barrier() and OOM callbacks. */
@@ -335,6 +336,7 @@ struct rcu_data {
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
+	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* 8) RCU CPU stall data. */
@@ -453,6 +455,8 @@ struct rcu_state {
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
+	unsigned long jiffies_resched;		/* Time at which to resched */
+						/*  a reluctant CPU. */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	const char *name;			/* Name of structure. */
@@ -548,9 +552,12 @@ static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
-			    bool lazy);
+			    bool lazy, unsigned long flags);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
-				      struct rcu_data *rdp);
+				      struct rcu_data *rdp,
+				      unsigned long flags);
+static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
+static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void rcu_kick_nohz_cpu(int cpu);
@@ -564,6 +571,7 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj);
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 08a7652..3ca3273 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -361,10 +361,14 @@ void rcu_read_unlock_special(struct task_struct *t)
 	special = t->rcu_read_unlock_special;
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
 		rcu_preempt_qs(smp_processor_id());
+		if (!t->rcu_read_unlock_special) {
+			local_irq_restore(flags);
+			return;
+		}
 	}
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
+	/* Hardware IRQ handlers cannot block, complain if they get here. */
+	if (WARN_ON_ONCE(in_irq() || in_serving_softirq())) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -779,8 +783,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 		}
 		if (rnp->parent == NULL) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			if (wake)
+			if (wake) {
+				smp_mb(); /* EGP done before wake_up(). */
 				wake_up(&sync_rcu_preempt_exp_wq);
+			}
 			break;
 		}
 		mask = rnp->grpmask;
@@ -1852,6 +1858,7 @@ static int rcu_oom_notify(struct notifier_block *self,
 
 	/* Wait for callbacks from earlier instance to complete. */
 	wait_event(oom_callback_wq, atomic_read(&oom_callback_count) == 0);
+	smp_mb(); /* Ensure callback reuse happens after callback invocation. */
 
 	/*
 	 * Prevent premature wakeup: ensure that all increments happen
@@ -2101,7 +2108,8 @@ bool rcu_is_nocb_cpu(int cpu)
 static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 				    struct rcu_head *rhp,
 				    struct rcu_head **rhtp,
-				    int rhcount, int rhcount_lazy)
+				    int rhcount, int rhcount_lazy,
+				    unsigned long flags)
 {
 	int len;
 	struct rcu_head **old_rhpp;
@@ -2122,9 +2130,16 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 	}
 	len = atomic_long_read(&rdp->nocb_q_count);
 	if (old_rhpp == &rdp->nocb_head) {
-		wake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
+		if (!irqs_disabled_flags(flags)) {
+			wake_up(&rdp->nocb_wq); /* ... if queue was empty ... */
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("WakeEmpty"));
+		} else {
+			rdp->nocb_defer_wakeup = true;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("WakeEmptyIsDeferred"));
+		}
 		rdp->qlen_last_fqs_check = 0;
-		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeEmpty"));
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
 		wake_up_process(t); /* ... or if many callbacks queued. */
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
@@ -2145,12 +2160,12 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
  * "rcuo" kthread can find it.
  */
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
-			    bool lazy)
+			    bool lazy, unsigned long flags)
 {
 
 	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return 0;
-	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
+	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy, flags);
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
 		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
 					 (unsigned long)rhp->func,
@@ -2168,7 +2183,8 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
  * not a no-CBs CPU.
  */
 static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
-						     struct rcu_data *rdp)
+						     struct rcu_data *rdp,
+						     unsigned long flags)
 {
 	long ql = rsp->qlen;
 	long qll = rsp->qlen_lazy;
@@ -2182,14 +2198,14 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	/* First, enqueue the donelist, if any.  This preserves CB ordering. */
 	if (rsp->orphan_donelist != NULL) {
 		__call_rcu_nocb_enqueue(rdp, rsp->orphan_donelist,
-					rsp->orphan_donetail, ql, qll);
+					rsp->orphan_donetail, ql, qll, flags);
 		ql = qll = 0;
 		rsp->orphan_donelist = NULL;
 		rsp->orphan_donetail = &rsp->orphan_donelist;
 	}
 	if (rsp->orphan_nxtlist != NULL) {
 		__call_rcu_nocb_enqueue(rdp, rsp->orphan_nxtlist,
-					rsp->orphan_nxttail, ql, qll);
+					rsp->orphan_nxttail, ql, qll, flags);
 		ql = qll = 0;
 		rsp->orphan_nxtlist = NULL;
 		rsp->orphan_nxttail = &rsp->orphan_nxtlist;
@@ -2250,6 +2266,7 @@ static int rcu_nocb_kthread(void *arg)
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("Sleep"));
 			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
+			/* Memory barrier provide by xchg() below. */
 		} else if (firsttime) {
 			firsttime = 0;
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
@@ -2310,6 +2327,22 @@ static int rcu_nocb_kthread(void *arg)
 	return 0;
 }
 
+/* Is a deferred wakeup of rcu_nocb_kthread() required? */
+static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+{
+	return ACCESS_ONCE(rdp->nocb_defer_wakeup);
+}
+
+/* Do a deferred wakeup of rcu_nocb_kthread(). */
+static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+{
+	if (!rcu_nocb_need_deferred_wakeup(rdp))
+		return;
+	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
+	wake_up(&rdp->nocb_wq);
+	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
+}
+
 /* Initialize per-rcu_data variables for no-CBs CPUs. */
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
@@ -2365,13 +2398,14 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 }
 
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
-			    bool lazy)
+			    bool lazy, unsigned long flags)
 {
 	return 0;
 }
 
 static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
-						     struct rcu_data *rdp)
+						     struct rcu_data *rdp,
+						     unsigned long flags)
 {
 	return 0;
 }
@@ -2380,6 +2414,15 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 }
 
+static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+{
+	return false;
+}
+
+static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+{
+}
+
 static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 {
 }
@@ -2829,3 +2872,23 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 }
 
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+/*
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
+ * grace-period kthread will do force_quiescent_state() processing?
+ * The idea is to avoid waking up RCU core processing on such a
+ * CPU unless the grace period has extended for too long.
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * CONFIG_RCU_NOCB_CPUs.
+ */
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (!rcu_gp_in_progress(rsp) ||
+	     ULONG_CMP_LT(jiffies, ACCESS_ONCE(rsp->gp_start) + HZ)))
+		return 1;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index 3596797..4def475 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -364,9 +364,10 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_rp_report_qs,
 		   rdp->n_rp_cb_ready,
 		   rdp->n_rp_cpu_needs_gp);
-	seq_printf(m, "gpc=%ld gps=%ld nn=%ld\n",
+	seq_printf(m, "gpc=%ld gps=%ld nn=%ld ndw%ld\n",
 		   rdp->n_rp_gp_completed,
 		   rdp->n_rp_gp_started,
+		   rdp->n_rp_nocb_defer_wakeup,
 		   rdp->n_rp_need_nothing);
 }
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 6cb3dff..802365c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -128,6 +128,11 @@ struct lockdep_map rcu_sched_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 
+static struct lock_class_key rcu_callback_key;
+struct lockdep_map rcu_callback_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_callback", &rcu_callback_key);
+EXPORT_SYMBOL_GPL(rcu_callback_map);
+
 int notrace debug_lockdep_rcu_enabled(void)
 {
 	return rcu_scheduler_active && debug_locks &&
diff --git a/tools/testing/selftests/rcutorture/.gitignore b/tools/testing/selftests/rcutorture/.gitignore
new file mode 100644
index 0000000..05838f6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/.gitignore
@@ -0,0 +1,6 @@
+initrd
+linux-2.6
+b[0-9]*
+rcu-test-image
+res
+*.swp
diff --git a/tools/testing/selftests/rcutorture/bin/config2frag.sh b/tools/testing/selftests/rcutorture/bin/config2frag.sh
new file mode 100644
index 0000000..9f9ffcd
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/config2frag.sh
@@ -0,0 +1,25 @@
+#!/bin/sh
+# Usage: sh config2frag.sh < .config > configfrag
+#
+# Converts the "# CONFIG_XXX is not set" to "CONFIG_XXX=n" so that the
+# resulting file becomes a legitimate Kconfig fragment.
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+LANG=C sed -e 's/^# CONFIG_\([a-zA-Z0-9_]*\) is not set$/CONFIG_\1=n/'
diff --git a/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh b/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh
new file mode 100755
index 0000000..43540f1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+#
+# Extract the number of CPUs expected from the specified Kconfig-file
+# fragment by checking CONFIG_SMP and CONFIG_NR_CPUS.  If the specified
+# file gives no clue, base the number on the number of idle CPUs on
+# the system.
+#
+# Usage: configNR_CPUS.sh config-frag
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+cf=$1
+if test ! -r $cf
+then
+	echo Unreadable config fragment $cf 1>&2
+	exit -1
+fi
+if grep -q '^CONFIG_SMP=n$' $cf
+then
+	echo 1
+	exit 0
+fi
+if grep -q '^CONFIG_NR_CPUS=' $cf
+then
+	grep '^CONFIG_NR_CPUS=' $cf | 
+		sed -e 's/^CONFIG_NR_CPUS=\([0-9]*\).*$/\1/'
+	exit 0
+fi
+cpus2use.sh
diff --git a/tools/testing/selftests/rcutorture/bin/configcheck.sh b/tools/testing/selftests/rcutorture/bin/configcheck.sh
new file mode 100755
index 0000000..d686537
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/configcheck.sh
@@ -0,0 +1,54 @@
+#!/bin/sh
+# Usage: sh configcheck.sh .config .config-template
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/abat-chk-config.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
+cat $1 > $T/.config
+
+cat $2 | sed -e 's/\(.*\)=n/# \1 is not set/' -e 's/^#CHECK#//' |
+awk	'
+BEGIN	{
+		print "if grep -q \"" $0 "\" < '"$T/.config"'";
+		print "then";
+		print "\t:";
+		print "else";
+		if ($1 == "#") {
+			print "\tif grep -q \"" $2 "\" < '"$T/.config"'";
+			print "\tthen";
+			print "\t\tif test \"$firsttime\" = \"\""
+			print "\t\tthen"
+			print "\t\t\tfirsttime=1"
+			print "\t\tfi"
+			print "\t\techo \":" $2 ": improperly set\"";
+			print "\telse";
+			print "\t\t:";
+			print "\tfi";
+		} else {
+			print "\tif test \"$firsttime\" = \"\""
+			print "\tthen"
+			print "\t\tfirsttime=1"
+			print "\tfi"
+			print "\techo \":" $0 ": improperly set\"";
+		}
+		print "fi";
+	}' | sh
diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
new file mode 100755
index 0000000..a1be6e6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -0,0 +1,74 @@
+#!/bin/sh
+#
+# sh configinit.sh config-spec-file [ build output dir ]
+#
+# Create a .config file from the spec file.  Run from the kernel source tree.
+# Exits with 0 if all went well, with 1 if all went well but the config
+# did not match, and some other number for other failures.
+#
+# The first argument is the .config specification file, which contains
+# desired settings, for example, "CONFIG_NO_HZ=y".  For best results,
+# this should be a full pathname.
+#
+# The second argument is a optional path to a build output directory,
+# for example, "O=/tmp/foo".  If this argument is omitted, the .config
+# file will be generated directly in the current directory.
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/configinit.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
+# Capture config spec file.
+
+c=$1
+buildloc=$2
+builddir=
+if test -n $buildloc
+then
+	if echo $buildloc | grep -q '^O='
+	then
+		builddir=`echo $buildloc | sed -e 's/^O=//'`
+		if test ! -d $builddir
+		then
+			mkdir $builddir
+		fi
+	else
+		echo Bad build directory: \"$builddir\"
+		exit 2
+	fi
+fi
+
+sed -e 's/^\(CONFIG[0-9A-Z_]*\)=.*$/grep -v "^# \1" |/' < $c > $T/u.sh
+sed -e 's/^\(CONFIG[0-9A-Z_]*=\).*$/grep -v \1 |/' < $c >> $T/u.sh
+grep '^grep' < $T/u.sh > $T/upd.sh
+echo "cat - $c" >> $T/upd.sh
+make mrproper
+make $buildloc distclean > $builddir/Make.distclean 2>&1
+make $buildloc defconfig > $builddir/Make.defconfig.out 2>&1
+mv $builddir/.config $builddir/.config.sav
+sh $T/upd.sh < $builddir/.config.sav > $builddir/.config
+cp $builddir/.config $builddir/.config.new
+yes '' | make $buildloc oldconfig > $builddir/Make.modconfig.out 2>&1
+
+# verify new config matches specification.
+configcheck.sh $builddir/.config $c
+
+exit 0
diff --git a/tools/testing/selftests/rcutorture/bin/cpus2use.sh b/tools/testing/selftests/rcutorture/bin/cpus2use.sh
new file mode 100755
index 0000000..abe14b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/cpus2use.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+#
+# Get an estimate of how CPU-hoggy to be.
+#
+# Usage: cpus2use.sh
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+ncpus=`grep '^processor' /proc/cpuinfo | wc -l`
+idlecpus=`mpstat | tail -1 | \
+	awk -v ncpus=$ncpus '{ print ncpus * ($7 + $12) / 100 }'`
+awk -v ncpus=$ncpus -v idlecpus=$idlecpus < /dev/null '
+BEGIN {
+	cpus2use = idlecpus;
+	if (cpus2use < 1)
+		cpus2use = 1;
+	if (cpus2use < ncpus / 10)
+		cpus2use = ncpus / 10;
+	if (cpus2use == int(cpus2use))
+		cpus2use = int(cpus2use)
+	else
+		cpus2use = int(cpus2use) + 1
+	print cpus2use;
+}'
+
diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
new file mode 100644
index 0000000..587561d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -0,0 +1,198 @@
+#!/bin/bash
+#
+# Shell functions for the rest of the scripts.
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# bootparam_hotplug_cpu bootparam-string
+#
+# Returns 1 if the specified boot-parameter string tells rcutorture to
+# test CPU-hotplug operations.
+bootparam_hotplug_cpu () {
+	echo "$1" | grep -q "rcutorture\.onoff_"
+}
+
+# checkarg --argname argtype $# arg mustmatch cannotmatch
+#
+# Checks the specified argument "arg" against the mustmatch and cannotmatch
+# patterns.
+checkarg () {
+	if test $3 -le 1
+	then
+		echo $1 needs argument $2 matching \"$5\"
+		usage
+	fi
+	if echo "$4" | grep -q -e "$5"
+	then
+		:
+	else
+		echo $1 $2 \"$4\" must match \"$5\"
+		usage
+	fi
+	if echo "$4" | grep -q -e "$6"
+	then
+		echo $1 $2 \"$4\" must not match \"$6\"
+		usage
+	fi
+}
+
+# configfrag_boot_params bootparam-string config-fragment-file
+#
+# Adds boot parameters from the .boot file, if any.
+configfrag_boot_params () {
+	if test -r "$2.boot"
+	then
+		echo $1 `grep -v '^#' "$2.boot" | tr '\012' ' '`
+	else
+		echo $1
+	fi
+}
+
+# configfrag_hotplug_cpu config-fragment-file
+#
+# Returns 1 if the config fragment specifies hotplug CPU.
+configfrag_hotplug_cpu () {
+	if test ! -r "$1"
+	then
+		echo Unreadable config fragment "$1" 1>&2
+		exit -1
+	fi
+	grep -q '^CONFIG_HOTPLUG_CPU=y$' "$1"
+}
+
+# identify_qemu builddir
+#
+# Returns our best guess as to which qemu command is appropriate for
+# the kernel at hand.  Override with the RCU_QEMU_CMD environment variable.
+identify_qemu () {
+	local u="`file "$1"`"
+	if test -n "$RCU_QEMU_CMD"
+	then
+		echo $RCU_QEMU_CMD
+	elif echo $u | grep -q x86-64
+	then
+		echo qemu-system-x86_64
+	elif echo $u | grep -q "Intel 80386"
+	then
+		echo qemu-system-i386
+	elif uname -a | grep -q ppc64
+	then
+		echo qemu-system-ppc64
+	else
+		echo Cannot figure out what qemu command to use! 1>&2
+		# Usually this will be one of /usr/bin/qemu-system-*
+		# Use RCU_QEMU_CMD environment variable or appropriate
+		# argument to top-level script.
+		exit 1
+	fi
+}
+
+# identify_qemu_append qemu-cmd
+#
+# Output arguments for the qemu "-append" string based on CPU type
+# and the RCU_QEMU_INTERACTIVE environment variable.
+identify_qemu_append () {
+	case "$1" in
+	qemu-system-x86_64|qemu-system-i386)
+		echo noapic selinux=0 initcall_debug debug
+		;;
+	esac
+	if test -n "$RCU_QEMU_INTERACTIVE"
+	then
+		echo root=/dev/sda
+	else
+		echo console=ttyS0
+	fi
+}
+
+# identify_qemu_args qemu-cmd serial-file
+#
+# Output arguments for qemu arguments based on the RCU_QEMU_MAC
+# and RCU_QEMU_INTERACTIVE environment variables.
+identify_qemu_args () {
+	case "$1" in
+	qemu-system-x86_64|qemu-system-i386)
+		;;
+	qemu-system-ppc64)
+		echo -enable-kvm -M pseries -cpu POWER7 -nodefaults
+		echo -device spapr-vscsi
+		if test -n "$RCU_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
+		then
+			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
+			echo -netdev bridge,br=br0,id=net0
+		elif test -n "$RCU_QEMU_INTERACTIVE"
+		then
+			echo -net nic -net user
+		fi
+		;;
+	esac
+	if test -n "$RCU_QEMU_INTERACTIVE"
+	then
+		echo -monitor stdio -serial pty -S
+	else
+		echo -serial file:$2
+	fi
+}
+
+# identify_qemu_vcpus
+#
+# Returns the number of virtual CPUs available to the aggregate of the
+# guest OSes.
+identify_qemu_vcpus () {
+	lscpu | grep '^CPU(s):' | sed -e 's/CPU(s)://'
+}
+
+# print_bug
+#
+# Prints "BUG: " in red followed by remaining arguments
+print_bug () {
+	printf '\033[031mBUG: \033[m'
+	echo $*
+}
+
+# print_warning
+#
+# Prints "WARNING: " in yellow followed by remaining arguments
+print_warning () {
+	printf '\033[033mWARNING: \033[m'
+	echo $*
+}
+
+# specify_qemu_cpus qemu-cmd qemu-args #cpus
+#
+# Appends a string containing "-smp XXX" to qemu-args, unless the incoming
+# qemu-args already contains "-smp".
+specify_qemu_cpus () {
+	local nt;
+
+	if echo $2 | grep -q -e -smp
+	then
+		echo $2
+	else
+		case "$1" in
+		qemu-system-x86_64|qemu-system-i386)
+			echo $2 -smp $3
+			;;
+		qemu-system-ppc64)
+			nt="`lscpu | grep '^NUMA node0' | sed -e 's/^[^,]*,\([0-9]*\),.*$/\1/'`"
+			echo $2 -smp cores=`expr \( $3 + $nt - 1 \) / $nt`,threads=$nt
+			;;
+		esac
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
new file mode 100755
index 0000000..197901e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
+#
+# Build a kvm-ready Linux kernel from the tree in the current directory.
+#
+# Usage: sh kvm-build.sh config-template build-dir more-configs
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+config_template=${1}
+if test -z "$config_template" -o ! -f "$config_template" -o ! -r "$config_template"
+then
+	echo "kvm-build.sh :$config_template: Not a readable file"
+	exit 1
+fi
+builddir=${2}
+if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
+then
+	echo "kvm-build.sh :$builddir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+moreconfigs=${3}
+if test -z "$moreconfigs" -o ! -r "$moreconfigs"
+then
+	echo "kvm-build.sh :$moreconfigs: Not a readable file"
+	exit 1
+fi
+
+T=/tmp/test-linux.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
+cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
+cat << ___EOF___ >> $T/config
+CONFIG_INITRAMFS_SOURCE="$RCU_INITRD"
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_CONSOLE=y
+___EOF___
+cat $moreconfigs >> $T/config
+
+configinit.sh $T/config O=$builddir
+retval=$?
+if test $retval -gt 1
+then
+	exit 2
+fi
+ncpus=`cpus2use.sh`
+make O=$builddir -j$ncpus $RCU_KMAKE_ARG > $builddir/Make.out 2>&1
+retval=$?
+if test $retval -ne 0 || grep "rcu[^/]*": < $builddir/Make.out | egrep -q "Stop|Error|error:|warning:" || egrep -q "Stop|Error|error:" < $builddir/Make.out
+then
+	echo Kernel build error
+	egrep "Stop|Error|error:|warning:" < $builddir/Make.out
+	echo Run aborted.
+	exit 3
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
new file mode 100755
index 0000000..baef09f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -0,0 +1,44 @@
+#!/bin/bash
+#
+# Given the results directories for previous KVM runs of rcutorture,
+# check the build and console output for errors.  Given a directory
+# containing results directories, this recursively checks them all.
+#
+# Usage: sh kvm-recheck.sh resdir ...
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
+for rd in "$@"
+do
+	dirs=`find $rd -name Make.defconfig.out -print | sort | sed -e 's,/[^/]*$,,' | sort -u`
+	for i in $dirs
+	do
+		configfile=`echo $i | sed -e 's/^.*\///'`
+		echo $configfile
+		configcheck.sh $i/.config $i/ConfigFragment
+		parse-build.sh $i/Make.out $configfile
+		parse-rcutorture.sh $i/console.log $configfile
+		parse-console.sh $i/console.log $configfile
+		if test -r $i/Warnings
+		then
+			cat $i/Warnings
+		fi
+	done
+done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
new file mode 100755
index 0000000..151b237
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -0,0 +1,192 @@
+#!/bin/bash
+#
+# Run a kvm-based test of the specified tree on the specified configs.
+# Fully automated run and error checking, no graphics console.
+#
+# Execute this in the source tree.  Do not run it as a background task
+# because qemu does not seem to like that much.
+#
+# Usage: sh kvm-test-1-rcu.sh config builddir resdir minutes qemu-args bootargs
+#
+# qemu-args defaults to "" -- you will want "-nographic" if running headless.
+# bootargs defaults to	"root=/dev/sda noapic selinux=0 console=ttyS0"
+#			"initcall_debug debug rcutorture.stat_interval=15"
+#			"rcutorture.shutdown_secs=$((minutes * 60))"
+#			"rcutorture.rcutorture_runnable=1"
+#
+# Anything you specify for either qemu-args or bootargs is appended to
+# the default values.  The "-smp" value is deduced from the contents of
+# the config fragment.
+#
+# More sophisticated argument parsing is clearly needed.
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+grace=120
+
+T=/tmp/kvm-test-1-rcu.sh.$$
+trap 'rm -rf $T' 0
+
+. $KVM/bin/functions.sh
+. $KVPATH/ver_functions.sh
+
+config_template=${1}
+title=`echo $config_template | sed -e 's/^.*\///'`
+builddir=${2}
+if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
+then
+	echo "kvm-test-1-rcu.sh :$builddir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+resdir=${3}
+if test -z "$resdir" -o ! -d "$resdir" -o ! -w "$resdir"
+then
+	echo "kvm-test-1-rcu.sh :$resdir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+cp $config_template $resdir/ConfigFragment
+echo ' ---' `date`: Starting build
+echo ' ---' Kconfig fragment at: $config_template >> $resdir/log
+cat << '___EOF___' >> $T
+CONFIG_RCU_TORTURE_TEST=y
+___EOF___
+# Optimizations below this point
+# CONFIG_USB=n
+# CONFIG_SECURITY=n
+# CONFIG_NFS_FS=n
+# CONFIG_SOUND=n
+# CONFIG_INPUT_JOYSTICK=n
+# CONFIG_INPUT_TABLET=n
+# CONFIG_INPUT_TOUCHSCREEN=n
+# CONFIG_INPUT_MISC=n
+# CONFIG_INPUT_MOUSE=n
+# # CONFIG_NET=n # disables console access, so accept the slower build.
+# CONFIG_SCSI=n
+# CONFIG_ATA=n
+# CONFIG_FAT_FS=n
+# CONFIG_MSDOS_FS=n
+# CONFIG_VFAT_FS=n
+# CONFIG_ISO9660_FS=n
+# CONFIG_QUOTA=n
+# CONFIG_HID=n
+# CONFIG_CRYPTO=n
+# CONFIG_PCCARD=n
+# CONFIG_PCMCIA=n
+# CONFIG_CARDBUS=n
+# CONFIG_YENTA=n
+if kvm-build.sh $config_template $builddir $T
+then
+	cp $builddir/Make*.out $resdir
+	cp $builddir/.config $resdir
+	cp $builddir/arch/x86/boot/bzImage $resdir
+	parse-build.sh $resdir/Make.out $title
+else
+	cp $builddir/Make*.out $resdir
+	echo Build failed, not running KVM, see $resdir.
+	exit 1
+fi
+minutes=$4
+seconds=$(($minutes * 60))
+qemu_args=$5
+boot_args=$6
+
+cd $KVM
+kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
+echo ' ---' `date`: Starting kernel
+
+# Determine the appropriate flavor of qemu command.
+QEMU="`identify_qemu $builddir/vmlinux.o`"
+
+# Generate -smp qemu argument.
+cpu_count=`configNR_CPUS.sh $config_template`
+vcpus=`identify_qemu_vcpus`
+if test $cpu_count -gt $vcpus
+then
+	echo CPU count limited from $cpu_count to $vcpus
+	touch $resdir/Warnings
+	echo CPU count limited from $cpu_count to $vcpus >> $resdir/Warnings
+	cpu_count=$vcpus
+fi
+qemu_args="`specify_qemu_cpus "$QEMU" "$qemu_args" "$cpu_count"`"
+
+# Generate architecture-specific and interaction-specific qemu arguments
+qemu_args="$qemu_args `identify_qemu_args "$QEMU" "$builddir/console.log"`"
+
+# Generate qemu -append arguments
+qemu_append="`identify_qemu_append "$QEMU"`"
+
+# Pull in Kconfig-fragment boot parameters
+boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
+# Generate CPU-hotplug boot parameters
+boot_args="`rcutorture_param_onoff "$boot_args" $builddir/.config`"
+# Generate rcu_barrier() boot parameter
+boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
+# Pull in standard rcutorture boot arguments
+boot_args="$boot_args rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1"
+
+echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+if test -n "$RCU_BUILDONLY"
+then
+	echo Build-only run specified, boot/test omitted.
+	exit 0
+fi
+$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args" &
+qemu_pid=$!
+commandcompleted=0
+echo Monitoring qemu job at pid $qemu_pid
+for ((i=0;i<$seconds;i++))
+do
+	if kill -0 $qemu_pid > /dev/null 2>&1
+	then
+		sleep 1
+	else
+		commandcompleted=1
+		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
+		if test $kruntime -lt $seconds
+		then
+			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
+		else
+			echo ' ---' `date`: Kernel done
+		fi
+		break
+	fi
+done
+if test $commandcompleted -eq 0
+then
+	echo Grace period for qemu job at pid $qemu_pid
+	for ((i=0;i<=$grace;i++))
+	do
+		if kill -0 $qemu_pid > /dev/null 2>&1
+		then
+			sleep 1
+		else
+			break
+		fi
+		if test $i -eq $grace
+		then
+			kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }'`
+			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
+			kill -KILL $qemu_pid
+		fi
+	done
+fi
+
+cp $builddir/console.log $resdir
+parse-rcutorture.sh $resdir/console.log $title
+parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
new file mode 100644
index 0000000..1b7923b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -0,0 +1,210 @@
+#!/bin/bash
+#
+# Run a series of 14 tests under KVM.  These are not particularly
+# well-selected or well-tuned, but are the current set.  Run from the
+# top level of the source tree.
+#
+# Edit the definitions below to set the locations of the various directories,
+# as well as the test duration.
+#
+# Usage: sh kvm.sh [ options ]
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+scriptname=$0
+args="$*"
+
+dur=30
+KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
+PATH=${KVM}/bin:$PATH; export PATH
+builddir="${KVM}/b1"
+RCU_INITRD="$KVM/initrd"; export RCU_INITRD
+RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
+resdir=""
+configs=""
+ds=`date +%Y.%m.%d-%H:%M:%S`
+kversion=""
+
+. functions.sh
+
+usage () {
+	echo "Usage: $scriptname optional arguments:"
+	echo "       --bootargs kernel-boot-arguments"
+	echo "       --builddir absolute-pathname"
+	echo "       --buildonly"
+	echo "       --configs \"config-file list\""
+	echo "       --datestamp string"
+	echo "       --duration minutes"
+	echo "       --interactive"
+	echo "       --kmake-arg kernel-make-arguments"
+	echo "       --kversion vN.NN"
+	echo "       --mac nn:nn:nn:nn:nn:nn"
+	echo "       --no-initrd"
+	echo "       --qemu-args qemu-system-..."
+	echo "       --qemu-cmd qemu-system-..."
+	echo "       --results absolute-pathname"
+	echo "       --relbuilddir relative-pathname"
+	exit 1
+}
+
+while test $# -gt 0
+do
+	case "$1" in
+	--bootargs)
+		checkarg --bootargs "(list of kernel boot arguments)" "$#" "$2" '.*' '^--'
+		RCU_BOOTARGS="$2"
+		shift
+		;;
+	--builddir)
+		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' '^error'
+		builddir=$2
+		gotbuilddir=1
+		shift
+		;;
+	--buildonly)
+		RCU_BUILDONLY=1; export RCU_BUILDONLY
+		;;
+	--configs)
+		checkarg --configs "(list of config files)" "$#" "$2" '^[^/]*$' '^--'
+		configs="$2"
+		shift
+		;;
+	--datestamp)
+		checkarg --datestamp "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
+		ds=$2
+		shift
+		;;
+	--duration)
+		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' '^error'
+		dur=$2
+		shift
+		;;
+	--interactive)
+		RCU_QEMU_INTERACTIVE=1; export RCU_QEMU_INTERACTIVE
+		;;
+	--kmake-arg)
+		checkarg --kmake-arg "(kernel make arguments)" $# "$2" '.*' '^error$'
+		RCU_KMAKE_ARG="$2"; export RCU_KMAKE_ARG
+		shift
+		;;
+	--kversion)
+		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' '^error'
+		kversion=$2
+		shift
+		;;
+	--mac)
+		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
+		RCU_QEMU_MAC=$2; export RCU_QEMU_MAC
+		shift
+		;;
+	--no-initrd)
+		RCU_INITRD=""; export RCU_INITRD
+		;;
+	--qemu-args)
+		checkarg --qemu-args "-qemu args" $# "$2" '^-' '^error'
+		RCU_QEMU_ARG="$2"
+		shift
+		;;
+	--qemu-cmd)
+		checkarg --qemu-cmd "(qemu-system-...)" $# "$2" 'qemu-system-' '^--'
+		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
+		shift
+		;;
+	--relbuilddir)
+		checkarg --relbuilddir "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
+		relbuilddir=$2
+		gotrelbuilddir=1
+		builddir=${KVM}/${relbuilddir}
+		shift
+		;;
+	--results)
+		checkarg --results "(absolute pathname)" "$#" "$2" '^/' '^error'
+		resdir=$2
+		shift
+		;;
+	*)
+		echo Unknown argument $1
+		usage
+		;;
+	esac
+	shift
+done
+
+CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
+KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
+
+if test -z "$configs"
+then
+	configs="`cat $CONFIGFRAG/$kversion/CFLIST`"
+fi
+
+if test -z "$resdir"
+then
+	resdir=$KVM/res
+	if ! test -e $resdir
+	then
+		mkdir $resdir || :
+	fi
+else
+	if ! test -e $resdir
+	then
+		mkdir -p "$resdir" || :
+	fi
+fi
+mkdir $resdir/$ds
+touch $resdir/$ds/log
+echo $scriptname $args >> $resdir/$ds/log
+
+pwd > $resdir/$ds/testid.txt
+if test -d .git
+then
+	git status >> $resdir/$ds/testid.txt
+	git rev-parse HEAD >> $resdir/$ds/testid.txt
+fi
+builddir=$KVM/b1
+if ! test -e $builddir
+then
+	mkdir $builddir || :
+fi
+
+for CF in $configs
+do
+	# Running TREE01 multiple times creates TREE01, TREE01.2, TREE01.3, ...
+	rd=$resdir/$ds/$CF
+	if test -d "${rd}"
+	then
+		n="`ls -d "${rd}"* | grep '\.[0-9]\+$' |
+			sed -e 's/^.*\.\([0-9]\+\)/\1/' |
+			sort -k1n | tail -1`"
+		if test -z "$n"
+		then
+			rd="${rd}.2"
+		else
+			n="`expr $n + 1`"
+			rd="${rd}.${n}"
+		fi
+	fi
+	mkdir "${rd}"
+	echo Results directory: $rd
+	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1 $RCU_BOOTARGS"
+done
+# Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
+
+echo " --- `date` Test summary:"
+kvm-recheck.sh $resdir/$ds
diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
new file mode 100755
index 0000000..5432309
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
@@ -0,0 +1,57 @@
+#!/bin/sh
+#
+# Check the build output from an rcutorture run for goodness.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# The file must contain kernel build output.
+#
+# Usage:
+#	sh parse-build.sh file title
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=$1
+title=$2
+
+. functions.sh
+
+if grep -q CC < $T
+then
+	:
+else
+	print_bug $title no build
+	exit 1
+fi
+
+if grep -q "error:" < $T
+then
+	print_bug $title build errors:
+	grep "error:" < $T
+	exit 2
+fi
+exit 0
+
+if egrep -q "rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+then
+	print_warning $title build errors:
+	egrep "rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+	exit 2
+fi
+exit 0
diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
new file mode 100755
index 0000000..4185d4c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -0,0 +1,41 @@
+#!/bin/sh
+#
+# Check the console output from an rcutorture run for oopses.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# Usage:
+#	sh parse-console.sh file title
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/abat-chk-badness.sh.$$
+trap 'rm -f $T' 0
+
+file="$1"
+title="$2"
+
+. functions.sh
+
+egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
+if test -s $T
+then
+	print_warning Assertion failure in $file $title
+	cat $T
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
new file mode 100755
index 0000000..dd0a275
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
@@ -0,0 +1,106 @@
+#!/bin/sh
+#
+# Check the console output from an rcutorture run for goodness.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# The file must contain rcutorture output, but can be interspersed
+# with other dmesg text.
+#
+# Usage:
+#	sh parse-rcutorture.sh file title
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/parse-rcutorture.sh.$$
+file="$1"
+title="$2"
+
+trap 'rm -f $T.seq' 0
+
+. functions.sh
+
+# check for presence of rcutorture.txt file
+
+if test -f "$file" -a -r "$file"
+then
+	:
+else
+	echo $title unreadable rcutorture.txt file: $file
+	exit 1
+fi
+
+# check for abject failure
+
+if grep -q FAILURE $file || grep -q -e '-torture.*!!!' $file
+then
+	nerrs=`grep --binary-files=text '!!!' $file | tail -1 | awk '{for (i=NF-8;i<=NF;i++) sum+=$i; } END {print sum}'`
+	print_bug $title FAILURE, $nerrs instances
+	echo "   " $url
+	exit
+fi
+
+grep --binary-files=text 'torture:.*ver:' $file | grep --binary-files=text -v '(null)' | sed -e 's/^(initramfs)[^]]*] //' -e 's/^\[[^]]*] //' |
+awk '
+BEGIN	{
+	ver = 0;
+	badseq = 0;
+	}
+
+	{
+	if (!badseq && ($5 + 0 != $5 || $5 <= ver)) {
+		badseqno1 = ver;
+		badseqno2 = $5;
+		badseqnr = NR;
+		badseq = 1;
+	}
+	ver = $5
+	}
+
+END	{
+	if (badseq) {
+		if (badseqno1 == badseqno2 && badseqno2 == ver)
+			print "RCU GP HANG at " ver " rcutorture stat " badseqnr;
+		else
+			print "BAD SEQ " badseqno1 ":" badseqno2 " last:" ver " RCU version " badseqnr;
+	}
+	}' > $T.seq
+
+if grep -q SUCCESS $file
+then
+	if test -s $T.seq
+	then
+		print_warning $title $title `cat $T.seq`
+		echo "   " $file
+		exit 2
+	fi
+else
+	if grep -q RCU_HOTPLUG $file
+	then
+		print_warning HOTPLUG FAILURES $title `cat $T.seq`
+		echo "   " $file
+		exit 3
+	fi
+	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful RCU version messages
+	if test -s $T.seq
+	then
+		print_warning $title `cat $T.seq`
+	fi
+	exit 2
+fi
diff --git a/tools/testing/selftests/rcutorture/configs/CFLIST b/tools/testing/selftests/rcutorture/configs/CFLIST
new file mode 100644
index 0000000..cd3d29c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/CFLIST
@@ -0,0 +1,13 @@
+TREE01
+TREE02
+TREE03
+TREE04
+TREE05
+TREE06
+TREE07
+TREE08
+TREE09
+SRCU-N
+SRCU-P
+TINY01
+TINY02
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N b/tools/testing/selftests/rcutorture/configs/SRCU-N
new file mode 100644
index 0000000..10a0e27
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-N
@@ -0,0 +1,8 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N.boot b/tools/testing/selftests/rcutorture/configs/SRCU-N.boot
new file mode 100644
index 0000000..238bfe3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-N.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P b/tools/testing/selftests/rcutorture/configs/SRCU-P
new file mode 100644
index 0000000..6650e00
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-P
@@ -0,0 +1,8 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P.boot b/tools/testing/selftests/rcutorture/configs/SRCU-P.boot
new file mode 100644
index 0000000..238bfe3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-P.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/TINY01 b/tools/testing/selftests/rcutorture/configs/TINY01
new file mode 100644
index 0000000..0c2823f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TINY01
@@ -0,0 +1,13 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PREEMPT_COUNT=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TINY02 b/tools/testing/selftests/rcutorture/configs/TINY02
new file mode 100644
index 0000000..e5072d7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TINY02
@@ -0,0 +1,13 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PREEMPT_COUNT=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01 b/tools/testing/selftests/rcutorture/configs/TREE01
new file mode 100644
index 0000000..141119a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE01
@@ -0,0 +1,23 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01.boot b/tools/testing/selftests/rcutorture/configs/TREE01.boot
new file mode 100644
index 0000000..0fc8a34
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE01.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/TREE02 b/tools/testing/selftests/rcutorture/configs/TREE02
new file mode 100644
index 0000000..2d4d096
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE02
@@ -0,0 +1,26 @@
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
+CONFIG_RCU_TRACE=n
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
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE03 b/tools/testing/selftests/rcutorture/configs/TREE03
new file mode 100644
index 0000000..a47de5b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE03
@@ -0,0 +1,23 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=4
+CONFIG_RCU_FANOUT_LEAF=4
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04 b/tools/testing/selftests/rcutorture/configs/TREE04
new file mode 100644
index 0000000..8d839b8
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE04
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=2
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_CPU_STALL_VERBOSE=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04.boot b/tools/testing/selftests/rcutorture/configs/TREE04.boot
new file mode 100644
index 0000000..0fc8a34
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE04.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05 b/tools/testing/selftests/rcutorture/configs/TREE05
new file mode 100644
index 0000000..b5ba72e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE05
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=6
+CONFIG_RCU_FANOUT_LEAF=6
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05.boot b/tools/testing/selftests/rcutorture/configs/TREE05.boot
new file mode 100644
index 0000000..3b42b8b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE05.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=sched
diff --git a/tools/testing/selftests/rcutorture/configs/TREE06 b/tools/testing/selftests/rcutorture/configs/TREE06
new file mode 100644
index 0000000..7c95ab4
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE06
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=6
+CONFIG_RCU_FANOUT_LEAF=6
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE07 b/tools/testing/selftests/rcutorture/configs/TREE07
new file mode 100644
index 0000000..1467404
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE07
@@ -0,0 +1,24 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_NO_HZ_FULL_SYSIDLE=y
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=2
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08 b/tools/testing/selftests/rcutorture/configs/TREE08
new file mode 100644
index 0000000..7d097a6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE08
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08-T b/tools/testing/selftests/rcutorture/configs/TREE08-T
new file mode 100644
index 0000000..442c4e4
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE08-T
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
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
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE09 b/tools/testing/selftests/rcutorture/configs/TREE09
new file mode 100644
index 0000000..0d1ec0d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE09
@@ -0,0 +1,21 @@
+CONFIG_SMP=n
+CONFIG_NR_CPUS=1
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
new file mode 100644
index 0000000..1822394
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..d3ef873
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..02e4185
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b3100f6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..c56b445
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..90d924f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
new file mode 100644
index 0000000..023f312
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
new file mode 100644
index 0000000..6fd0235
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..f72402d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..0f3b667
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b035e14
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..3ccf6a9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..ef624ce
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
new file mode 100644
index 0000000..e3361c3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
new file mode 100644
index 0000000..64abfc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
new file mode 100644
index 0000000..e805253
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
@@ -0,0 +1,35 @@
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	echo $1
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	echo $1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
new file mode 100644
index 0000000..da4cbc66
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
@@ -0,0 +1,17 @@
+sysidleY.2013.06.19a
+sysidleN.2013.06.19a
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+P6---t-nh-SD-smp-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..d81e11d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..02e4185
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b3100f6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..c56b445
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..90d924f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
new file mode 100644
index 0000000..0ccc36d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=1
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..3f640cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,26 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..285da2d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=14
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
new file mode 100644
index 0000000..023f312
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
new file mode 100644
index 0000000..6fd0235
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..9647c44
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..0f3b667
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b035e14
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..3ccf6a9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..ef624ce
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
new file mode 100644
index 0000000..f4c9175
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=n
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..77a8c5b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
new file mode 100644
index 0000000..0eecebc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
new file mode 100644
index 0000000..0eecebc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
new file mode 100644
index 0000000..588bc70
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
new file mode 100644
index 0000000..e3361c3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
new file mode 100644
index 0000000..64abfc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
new file mode 100644
index 0000000..1822394
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..d81e11d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..02e4185
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b3100f6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..c56b445
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..90d924f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
new file mode 100644
index 0000000..023f312
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
new file mode 100644
index 0000000..6fd0235
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..9647c44
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..0f3b667
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b035e14
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..3ccf6a9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..ef624ce
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
new file mode 100644
index 0000000..e3361c3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
new file mode 100644
index 0000000..64abfc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
new file mode 100644
index 0000000..c37432f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
@@ -0,0 +1,41 @@
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	echo $1
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff.
+		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	else
+		echo $1
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
new file mode 100644
index 0000000..1822394
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..d81e11d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..02e4185
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b3100f6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..c56b445
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..90d924f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
new file mode 100644
index 0000000..023f312
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
new file mode 100644
index 0000000..6fd0235
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 0000000..9647c44
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 0000000..0f3b667
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 0000000..b035e14
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 0000000..3ccf6a9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 0000000..ef624ce
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
new file mode 100644
index 0000000..e3361c3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
new file mode 100644
index 0000000..64abfc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
new file mode 100644
index 0000000..6a5f13a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
@@ -0,0 +1,46 @@
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		echo $1
+	else
+		echo $1 rcutorture.n_barrier_cbs=4
+	fi
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff.
+		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	else
+		echo $1
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/configs/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
new file mode 100644
index 0000000..5e40ead
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
@@ -0,0 +1,46 @@
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
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		echo $1
+	else
+		echo $1 rcutorture.n_barrier_cbs=4
+	fi
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	else
+		echo $1
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
new file mode 100644
index 0000000..28db67b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
@@ -0,0 +1,40 @@
+This document gives a brief rationale for the TINY_RCU test cases.
+
+
+Kconfig Parameters:
+
+CONFIG_DEBUG_LOCK_ALLOC -- Do all three and none of the three.
+CONFIG_PREEMPT_COUNT
+CONFIG_RCU_TRACE
+
+The theory here is that randconfig testing will hit the other six possible
+combinations of these parameters.
+
+
+Kconfig Parameters Ignored:
+
+CONFIG_DEBUG_OBJECTS_RCU_HEAD
+CONFIG_PROVE_RCU
+
+	In common code tested by TREE_RCU test cases.
+
+CONFIG_NO_HZ_FULL_SYSIDLE
+CONFIG_RCU_NOCB_CPU
+CONFIG_RCU_USER_QS
+
+	Meaningless for TINY_RCU.
+
+CONFIG_RCU_STALL_COMMON
+CONFIG_RCU_TORTURE_TEST
+
+	Redundant with CONFIG_RCU_TRACE.
+
+CONFIG_HOTPLUG_CPU
+CONFIG_PREEMPT
+CONFIG_PREEMPT_RCU
+CONFIG_SMP
+CONFIG_TINY_RCU
+CONFIG_TREE_PREEMPT_RCU
+CONFIG_TREE_RCU
+
+	All forced by CONFIG_TINY_RCU.
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
new file mode 100644
index 0000000..adbb76c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
@@ -0,0 +1,95 @@
+This document gives a brief rationale for the TREE_RCU-related test
+cases, a group that includes TREE_PREEMPT_RCU.
+
+
+Kconfig Parameters:
+
+CONFIG_DEBUG_LOCK_ALLOC -- Do three, covering CONFIG_PROVE_LOCKING & not.
+CONFIG_DEBUG_OBJECTS_RCU_HEAD -- Do one.
+CONFIG_HOTPLUG_CPU -- Do half.  (Every second.)
+CONFIG_HZ_PERIODIC -- Do one.
+CONFIG_NO_HZ_IDLE -- Do those not otherwise specified. (Groups of two.)
+CONFIG_NO_HZ_FULL -- Do two, one with CONFIG_NO_HZ_FULL_SYSIDLE.
+CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
+CONFIG_PREEMPT -- Do half.  (First three and #8.)
+CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
+CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
+CONFIG_PROVE_RCU_DELAY -- Do one.
+CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
+CONFIG_RCU_BOOST_PRIO -- set to 2 for _BOOST testing.
+CONFIG_RCU_CPU_STALL_INFO -- do one with and without _VERBOSE.
+CONFIG_RCU_CPU_STALL_VERBOSE -- do one with and without _INFO.
+CONFIG_RCU_FANOUT -- Cover hierarchy as currently, but overlap with others.
+CONFIG_RCU_FANOUT_EXACT -- Do one.
+CONFIG_RCU_FANOUT_LEAF -- Do one non-default.
+CONFIG_RCU_FAST_NO_HZ -- Do one, but not with CONFIG_RCU_NOCB_CPU_ALL.
+CONFIG_RCU_NOCB_CPU -- Do three, see below.
+CONFIG_RCU_NOCB_CPU_ALL -- Do one.
+CONFIG_RCU_NOCB_CPU_NONE -- Do one.
+CONFIG_RCU_NOCB_CPU_ZERO -- Do one.
+CONFIG_RCU_TRACE -- Do half.
+CONFIG_SMP -- Need one !SMP for TREE_PREEMPT_RCU.
+RCU-bh: Do one with PREEMPT and one with !PREEMPT.
+RCU-sched: Do one with PREEMPT but not BOOST.
+
+
+Hierarchy:
+
+TREE01.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=8, CONFIG_RCU_FANOUT_EXACT=n.
+TREE02.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=3.
+TREE03.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=4, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=4.
+TREE04.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE05.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=n
+	CONFIG_RCU_FANOUT_LEAF=6.
+TREE06.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=y
+	CONFIG_RCU_FANOUT_LEAF=6.
+TREE07.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE08.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=y,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE09.	CONFIG_NR_CPUS=1.
+
+
+Kconfig Parameters Ignored:
+
+CONFIG_64BIT
+
+	Used only to check CONFIG_RCU_FANOUT value, inspection suffices.
+
+CONFIG_NO_HZ_FULL_SYSIDLE_SMALL
+
+	Defer until Frederic uses this.
+
+CONFIG_PREEMPT_COUNT
+CONFIG_PREEMPT_RCU
+
+	Redundant with CONFIG_PREEMPT, ignore.
+
+CONFIG_RCU_BOOST_DELAY
+
+	Inspection suffices, ignore.
+
+CONFIG_RCU_CPU_STALL_TIMEOUT
+
+	Inspection suffices, ignore.
+
+CONFIG_RCU_STALL_COMMON
+
+	Implied by TREE_RCU and TREE_PREEMPT_RCU.
+
+CONFIG_RCU_TORTURE_TEST
+CONFIG_RCU_TORTURE_TEST_RUNNABLE
+
+	Always used in KVM testing.
+
+CONFIG_RCU_USER_QS
+
+	Redundant with CONFIG_NO_HZ_FULL.
+
+CONFIG_TREE_PREEMPT_RCU
+CONFIG_TREE_RCU
+
+	These are controlled by CONFIG_PREEMPT.
diff --git a/tools/testing/selftests/rcutorture/doc/initrd.txt b/tools/testing/selftests/rcutorture/doc/initrd.txt
new file mode 100644
index 0000000..49d134c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/initrd.txt
@@ -0,0 +1,90 @@
+This document describes one way to create the initrd directory hierarchy
+in order to allow an initrd to be built into your kernel.  The trick
+here is to steal the initrd file used on your Linux laptop, Ubuntu in
+this case.  There are probably much better ways of doing this.
+
+That said, here are the commands:
+
+------------------------------------------------------------------------
+zcat /initrd.img > /tmp/initrd.img.zcat
+mkdir initrd
+cd initrd
+cpio -id < /tmp/initrd.img.zcat
+------------------------------------------------------------------------
+
+Interestingly enough, if you are running rcutorture, you don't really
+need userspace in many cases.  Running without userspace has the
+advantage of allowing you to test your kernel independently of the
+distro in place, the root-filesystem layout, and so on.  To make this
+happen, put the following script in the initrd's tree's "/init" file,
+with 0755 mode.
+
+------------------------------------------------------------------------
+#!/bin/sh
+
+[ -d /dev ] || mkdir -m 0755 /dev
+[ -d /root ] || mkdir -m 0700 /root
+[ -d /sys ] || mkdir /sys
+[ -d /proc ] || mkdir /proc
+[ -d /tmp ] || mkdir /tmp
+mkdir -p /var/lock
+mount -t sysfs -o nodev,noexec,nosuid sysfs /sys
+mount -t proc -o nodev,noexec,nosuid proc /proc
+# Some things don't work properly without /etc/mtab.
+ln -sf /proc/mounts /etc/mtab
+
+# Note that this only becomes /dev on the real filesystem if udev's scripts
+# are used; which they will be, but it's worth pointing out
+if ! mount -t devtmpfs -o mode=0755 udev /dev; then
+	echo "W: devtmpfs not available, falling back to tmpfs for /dev"
+	mount -t tmpfs -o mode=0755 udev /dev
+	[ -e /dev/console ] || mknod --mode=600 /dev/console c 5 1
+	[ -e /dev/kmsg ] || mknod --mode=644 /dev/kmsg c 1 11
+	[ -e /dev/null ] || mknod --mode=666 /dev/null c 1 3
+fi
+
+mkdir /dev/pts
+mount -t devpts -o noexec,nosuid,gid=5,mode=0620 devpts /dev/pts || true
+mount -t tmpfs -o "nosuid,size=20%,mode=0755" tmpfs /run
+mkdir /run/initramfs
+# compatibility symlink for the pre-oneiric locations
+ln -s /run/initramfs /dev/.initramfs
+
+# Export relevant variables
+export ROOT=
+export ROOTDELAY=
+export ROOTFLAGS=
+export ROOTFSTYPE=
+export IP=
+export BOOT=
+export BOOTIF=
+export UBIMTD=
+export break=
+export init=/sbin/init
+export quiet=n
+export readonly=y
+export rootmnt=/root
+export debug=
+export panic=
+export blacklist=
+export resume=
+export resume_offset=
+export recovery=
+
+for i in /sys/devices/system/cpu/cpu*/online
+do
+	case $i in
+	'/sys/devices/system/cpu/cpu0/online')
+		;;
+	'/sys/devices/system/cpu/cpu*/online')
+		;;
+	*)
+		echo 1 > $i
+		;;
+	esac
+done
+
+while :
+do
+	sleep 10
+done
diff --git a/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt b/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt
new file mode 100644
index 0000000..66efb59
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt
@@ -0,0 +1,42 @@
+This document describes one way to created the rcu-test-image file
+that contains the filesystem used by the guest-OS kernel.  There are
+probably much better ways of doing this, and this filesystem could no
+doubt be smaller.  It is probably also possible to simply download
+an appropriate image from any number of places.
+
+That said, here are the commands:
+
+------------------------------------------------------------------------
+dd if=/dev/zero of=rcu-test-image bs=400M count=1
+mkfs.ext3 ./rcu-test-image
+sudo mount -o loop ./rcu-test-image /mnt
+
+# Replace "precise" below with your favorite Ubuntu release.
+# Empirical evidence says this image will work for 64-bit, but...
+# Note that debootstrap does take a few minutes to run.  Or longer.
+sudo debootstrap --verbose --arch i386 precise /mnt http://archive.ubuntu.com/ubuntu
+cat << '___EOF___' | sudo dd of=/mnt/etc/fstab
+# UNCONFIGURED FSTAB FOR BASE SYSTEM
+#
+/dev/vda        /               ext3    defaults        1 1
+dev             /dev            tmpfs   rw              0 0
+tmpfs           /dev/shm        tmpfs   defaults        0 0
+devpts          /dev/pts        devpts  gid=5,mode=620  0 0
+sysfs           /sys            sysfs   defaults        0 0
+proc            /proc           proc    defaults        0 0
+___EOF___
+sudo umount /mnt
+------------------------------------------------------------------------
+
+
+References:
+
+	http://sripathikodi.blogspot.com/2010/02/creating-kvm-bootable-fedora-system.html
+	https://help.ubuntu.com/community/KVM/CreateGuests
+	https://help.ubuntu.com/community/JeOSVMBuilder
+	http://wiki.libvirt.org/page/UbuntuKVMWalkthrough
+	http://www.moe.co.uk/2011/01/07/pci_add_option_rom-failed-to-find-romfile-pxe-rtl8139-bin/ -- "apt-get install kvm-pxe"
+	http://www.landley.net/writing/rootfs-howto.html
+	http://en.wikipedia.org/wiki/Initrd
+	http://en.wikipedia.org/wiki/Cpio
+	http://wiki.libvirt.org/page/UbuntuKVMWalkthrough
