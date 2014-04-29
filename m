Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaD2A0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:26:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52008 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaD2AZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/45] torture: Rename RCU_KMAKE_ARG to TORTURE_KMAKE_ARG
Date: Mon, 28 Apr 2014 17:24:56 -0700
Message-Id: <1398731133-18925-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-8236-0000-0000-000001E64A7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit makes the torture scripts a bit more RCU-independent.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-build.sh | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index d8e68a5e4411..e838c775f709 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -60,7 +60,7 @@ then
 	exit 2
 fi
 ncpus=`cpus2use.sh`
-make O=$builddir -j$ncpus $RCU_KMAKE_ARG > $builddir/Make.out 2>&1
+make O=$builddir -j$ncpus $TORTURE_KMAKE_ARG > $builddir/Make.out 2>&1
 retval=$?
 if test $retval -ne 0 || grep "rcu[^/]*": < $builddir/Make.out | egrep -q "Stop|Error|error:|warning:" || egrep -q "Stop|Error|error:" < $builddir/Make.out
 then
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 59945b7793d9..04ad1f980dfe 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -40,7 +40,7 @@ KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
 TORTURE_DEFCONFIG=defconfig
 TORTURE_INITRD="$KVM/initrd"; export TORTURE_INITRD
-RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
+TORTURE_KMAKE_ARG=""
 TORTURE_SUITE=rcu
 resdir=""
 configs=""
@@ -118,7 +118,7 @@ do
 		;;
 	--kmake-arg)
 		checkarg --kmake-arg "(kernel make arguments)" $# "$2" '.*' '^error$'
-		RCU_KMAKE_ARG="$2"; export RCU_KMAKE_ARG
+		TORTURE_KMAKE_ARG="$2"
 		shift
 		;;
 	--kversion)
@@ -376,7 +376,7 @@ then
 	echo PATH="$PATH; export PATH"
 	echo RCU_BUILDONLY="$RCU_BUILDONLY; export RCU_BUILDONLY"
 	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
-	echo RCU_KMAKE_ARG="$RCU_KMAKE_ARG; export RCU_KMAKE_ARG"
+	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
 	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
 	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
 	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
-- 
1.8.1.5

