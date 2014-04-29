Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaD2Aa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37431 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/45] torture: Rename RCU_BUILDONLY to TORTURE_BUILDONLY
Date: Mon, 28 Apr 2014 17:24:58 -0700
Message-Id: <1398731133-18925-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit makes the torture scripts a bit more RCU-independent.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh            | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index e82f4f201c8c..86e6ffe6df45 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -152,7 +152,7 @@ boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
 echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
-if test -n "$RCU_BUILDONLY"
+if test -n "$TORTURE_BUILDONLY"
 then
 	echo Build-only run specified, boot/test omitted.
 	exit 0
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 08c90cba79d2..73c586f6bdf6 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -81,7 +81,7 @@ do
 		shift
 		;;
 	--buildonly)
-		RCU_BUILDONLY=1; export RCU_BUILDONLY
+		TORTURE_BUILDONLY=1
 		;;
 	--configs)
 		checkarg --configs "(list of config files)" "$#" "$2" '^[^/]*$' '^--'
@@ -374,7 +374,7 @@ then
 	echo KVM="$KVM; export KVM"
 	echo KVPATH="$KVPATH; export KVPATH"
 	echo PATH="$PATH; export PATH"
-	echo RCU_BUILDONLY="$RCU_BUILDONLY; export RCU_BUILDONLY"
+	echo TORTURE_BUILDONLY="$TORTURE_BUILDONLY; export TORTURE_BUILDONLY"
 	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
 	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
 	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
@@ -402,4 +402,7 @@ echo
 echo
 echo " --- `date` Test summary:"
 echo Results directory: $resdir/$ds
-kvm-recheck.sh $resdir/$ds
+if test -n "$TORTURE_BUILDONLY"
+then
+	kvm-recheck.sh $resdir/$ds
+fi
-- 
1.8.1.5

