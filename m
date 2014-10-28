Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaJ1Wdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:33:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36855 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbaJ1Wd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:33:27 -0400
Date: Tue, 28 Oct 2014 15:29:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/6] Torture-test changes for 3.19
Message-ID: <20141028222929.GA29476@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F0706C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides torture-testing updates:

1.	Run the Linux-kernel binary out of the results directory,
	easing re-runs.

2.	Add early-boot callback-posting self-tests for RCU, courtesy
	of Pranith Kumar.

3.	Enable early-boot callback-posting self-tests in rcutorture,
	courtesy of Pranith Kumar.

4.	Remove old-version rcutorture configuration files, courtesy
	of Pranith Kumar.

5.	Remove the --kversion parameter to kvm.sh, courtesy of Pranith
	Kumar.

6.	Fix rcu_torture_cbflood() memory leak.

							Thanx, Paul

------------------------------------------------------------------------

 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST                    |   14 -
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP       |   18 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP       |   18 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh                    |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH                    |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP       |   19 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp       |   27 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh                    |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH                    |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh          |   33 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST                   |   17 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP      |   19 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp      |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp      |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP      |   18 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp      |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp      |   19 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP      |   26 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP      |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh                   |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH                   |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP      |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp      |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp      |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP      |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp      |   27 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp      |   18 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP      |   30 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all  |   30 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none |   30 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp      |   30 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh                   |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH                   |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST                    |   14 -
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP       |   19 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP       |   18 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh                    |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH                    |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp       |   27 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh                    |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH                    |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh          |   44 -----
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST                    |   14 -
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP       |   19 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP       |   18 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh                    |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH                    |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp       |   20 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP       |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp       |   27 ---
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh                    |   23 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH                    |   22 --
 a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh          |   57 ------
 b/kernel/rcu/rcu.h                                                              |    2 
 b/kernel/rcu/rcutorture.c                                                       |    1 
 b/kernel/rcu/tiny.c                                                             |    4 
 b/kernel/rcu/tree.c                                                             |    2 
 b/kernel/rcu/update.c                                                           |   84 ++++++++++
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh                      |    6 
 b/tools/testing/selftests/rcutorture/bin/kvm.sh                                 |   19 --
 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02                         |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot                    |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot                    |    3 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08                         |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot                    |    2 
 84 files changed, 112 insertions(+), 1606 deletions(-)

