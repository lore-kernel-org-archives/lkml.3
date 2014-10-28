Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaJ1WeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:34:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37386 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbaJ1WeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/6] torture: Run Linux-kernel binary out of results directory
Date: Tue, 28 Oct 2014 15:30:00 -0700
Message-Id: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20141028222929.GA29476@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F0724C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcutorture scripts create a qemu-cmd script containing the actual
qemu command.  However, this command references the build directory,
which will be overwritten by later builds.  This commit therefore runs
the kernel out of the results directory so that less hand-editing is
required to re-run a previous test.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index f6b2b4771b78..e0f896999d6b 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -168,8 +168,8 @@ then
 	touch $resdir/buildonly
 	exit 0
 fi
-echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
-( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
+echo $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+( $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
-- 
1.8.1.5

