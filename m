Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3KPAfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:35:31 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59460 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3KPAfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:24 -0500
Date: Fri, 15 Nov 2013 16:35:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/28] RCU torture scripting for 3.14
Message-ID: <20131116003517.GA31563@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-00000356371F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains scripting that I use to test RCU under KVM, including
different Kconfig combinations to test, automated launching and monitoring
of multiple tests scenarios, kernel-version adaptation, and automated
evaluation of test output.  This version works on x86 32- and 64-bit,
and limps on PowerPC.

This also contains refactored test scenarios that greatly improve RCU
test coverage (resulting in fixes) while also reducing test run time.
There is a fair amount of work remaining, particularly in the areas of
documentation, automating initrd generation, and general reduction in
user-hostility.  Nevertheless, a much-needed improvement in the kernel's
RCU-testing capabilities.

							Thanx, Paul

------------------------------------------------------------------------

 a/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP            |   19 
 a/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp            |   20 
 a/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp            |   22 
 a/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP            |   18 
 a/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp            |   22 
 a/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp            |   19 
 a/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP            |   26 
 a/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP            |   22 
 a/tools/testing/selftests/rcutorture/configs/NT1-nh                         |   23 
 a/tools/testing/selftests/rcutorture/configs/NT3-NH                         |   20 
 a/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP            |   20 
 a/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp            |   20 
 a/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp            |   20 
 a/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP            |   22 
 a/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp            |   28 
 a/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp            |   18 
 a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP            |   30 
 a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all        |   30 
 a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none       |   30 
 a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp            |   30 
 a/tools/testing/selftests/rcutorture/configs/PT1-nh                         |   23 
 a/tools/testing/selftests/rcutorture/configs/PT2-NH                         |   22 
 a/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a           |   23 
 a/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a           |   26 
 b/MAINTAINERS                                                               |    6 
 b/tools/testing/selftests/rcutorture/.gitignore                             |    6 
 b/tools/testing/selftests/rcutorture/bin/config2frag.sh                     |   25 
 b/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh                   |   45 +
 b/tools/testing/selftests/rcutorture/bin/configcheck.sh                     |   54 +
 b/tools/testing/selftests/rcutorture/bin/configinit.sh                      |  112 ++-
 b/tools/testing/selftests/rcutorture/bin/cpus2use.sh                        |   41 +
 b/tools/testing/selftests/rcutorture/bin/functions.sh                       |  206 +++++
 b/tools/testing/selftests/rcutorture/bin/kvm-build.sh                       |   75 +-
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh                     |   54 +
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh                  |  264 ++++++-
 b/tools/testing/selftests/rcutorture/bin/kvm.sh                             |  370 +++++++---
 b/tools/testing/selftests/rcutorture/bin/parse-build.sh                     |   65 +
 b/tools/testing/selftests/rcutorture/bin/parse-console.sh                   |   43 +
 b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh                |  114 ++-
 b/tools/testing/selftests/rcutorture/configs/CFLIST                         |   47 -
 b/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP            |   19 
 b/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp            |   20 
 b/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp            |   22 
 b/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP            |   18 
 b/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp            |   22 
 b/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp            |   19 
 b/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP            |   26 
 b/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP            |   22 
 b/tools/testing/selftests/rcutorture/configs/NT1-nh                         |   23 
 b/tools/testing/selftests/rcutorture/configs/NT3-NH                         |   20 
 b/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP            |   20 
 b/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp            |   20 
 b/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp            |   20 
 b/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP            |   22 
 b/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp            |   28 
 b/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp            |   18 
 b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP            |   30 
 b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all        |   30 
 b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none       |   30 
 b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp            |   30 
 b/tools/testing/selftests/rcutorture/configs/PT1-nh                         |   23 
 b/tools/testing/selftests/rcutorture/configs/PT2-NH                         |   22 
 b/tools/testing/selftests/rcutorture/configs/SRCU-N                         |    8 
 b/tools/testing/selftests/rcutorture/configs/SRCU-N.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/SRCU-P                         |    8 
 b/tools/testing/selftests/rcutorture/configs/SRCU-P.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/TINY01                         |   13 
 b/tools/testing/selftests/rcutorture/configs/TINY02                         |   13 
 b/tools/testing/selftests/rcutorture/configs/TREE01                         |   23 
 b/tools/testing/selftests/rcutorture/configs/TREE01.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE02                         |   26 
 b/tools/testing/selftests/rcutorture/configs/TREE03                         |   23 
 b/tools/testing/selftests/rcutorture/configs/TREE04                         |   25 
 b/tools/testing/selftests/rcutorture/configs/TREE04.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE05                         |   25 
 b/tools/testing/selftests/rcutorture/configs/TREE05.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE06                         |   26 
 b/tools/testing/selftests/rcutorture/configs/TREE07                         |   24 
 b/tools/testing/selftests/rcutorture/configs/TREE08                         |   26 
 b/tools/testing/selftests/rcutorture/configs/TREE08-T                       |   26 
 b/tools/testing/selftests/rcutorture/configs/TREE09                         |   21 
 b/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a           |   23 
 b/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a           |   26 
 b/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST                    |   14 
 b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP       |   20 
 b/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH                    |   20 
 b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP       |   21 
 b/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP       |   22 
 b/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp       |   28 
 b/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH                    |   22 
 b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh          |   35 
 b/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST                   |   17 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP      |   19 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp      |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp      |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP      |   18 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp      |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp      |   19 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP      |   26 
 b/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP      |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh                   |   23 
 b/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH                   |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP      |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp      |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp      |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP      |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp      |   28 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp      |   18 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP      |   30 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all  |   30 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none |   30 
 b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp      |   30 
 b/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh                   |   23 
 b/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH                   |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST                    |   14 
 b/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP       |   19 
 b/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH                    |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP       |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp       |   28 
 b/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH                    |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh          |   41 +
 b/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST                    |   14 
 b/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP       |   19 
 b/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH                    |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP       |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp       |   28 
 b/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH                    |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh          |   46 +
 b/tools/testing/selftests/rcutorture/configs/ver_functions.sh               |   46 +
 b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt                       |   40 +
 b/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt               |   95 ++
 b/tools/testing/selftests/rcutorture/doc/initrd.txt                         |   90 ++
 b/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt                 |   42 +
 159 files changed, 4086 insertions(+), 736 deletions(-)

