Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaH1TMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:12:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42980 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaH1TMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:12:10 -0400
Date: Thu, 28 Aug 2014 12:12:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/11] Torture-test changes for 3.18
Message-ID: <20140828191203.GA26955@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-1542-0000-0000-0000045FBE2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains torture-test updates:

1.	Fix sparse warning by making boost_mutex static, courtesy of
	Pranith Kumar.

2.	Use bash shell for all torture test scripts, courtesy of Pranith
	Kumar.

3.	Set executable flags on scripts and invoke by name, courtesy
	of Pranith Kumar.

4.	Add "cd" step to initrd documentation.

5.	Test partial nohz_full= configuration to increased test coverage.

6.	Specify MAXSMP=y for TREE01 to increase test coverage.

7.	Specify CONFIG_CPUMASK_OFFSTACK=y for TREE07 to increase test
	coverage.

8.	Use pr_alert/pr_cont when printing to avoid large buffers,
	courtesy of Joe Perches.

9.	Add a callback-flood test to increase test coverage.

10.	Print PID in hung-kernel diagnostic message.

11.	Check for nul bytes in console output.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-parameters.txt                        |   18 
 b/include/linux/torture.h                                    |    2 
 b/kernel/rcu/rcutorture.c                                    |  215 +++++++----
 b/kernel/torture.c                                           |   16 
 b/tools/testing/selftests/rcutorture/bin/config2frag.sh      |    6 
 b/tools/testing/selftests/rcutorture/bin/configcheck.sh      |    6 
 b/tools/testing/selftests/rcutorture/bin/configinit.sh       |    6 
 b/tools/testing/selftests/rcutorture/bin/functions.sh        |   20 +
 b/tools/testing/selftests/rcutorture/bin/kvm-build.sh        |    4 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh |    4 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh  |    4 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh      |    4 
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh   |    7 
 b/tools/testing/selftests/rcutorture/bin/kvm.sh              |    8 
 b/tools/testing/selftests/rcutorture/bin/parse-build.sh      |    7 
 b/tools/testing/selftests/rcutorture/bin/parse-console.sh    |   11 
 b/tools/testing/selftests/rcutorture/bin/parse-torture.sh    |    7 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01      |    4 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07      |    3 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot |    1 
 b/tools/testing/selftests/rcutorture/doc/initrd.txt          |    1 
 22 files changed, 233 insertions(+), 123 deletions(-)

