Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaD2AZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:25:58 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48565 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063AbaD2AZt (ORCPT
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
Subject: [PATCH tip/core/rcu 14/45] torture: Rename RCU_QEMU_CMD to TORTURE_QEMU_CMD
Date: Mon, 28 Apr 2014 17:25:02 -0700
Message-Id: <1398731133-18925-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1542-0000-0000-00000169D316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit makes the torture scripts a bit more RCU-independent.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/functions.sh | 8 ++++----
 tools/testing/selftests/rcutorture/bin/kvm.sh       | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 41fb52b805e4..6b2adb29b073 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -79,12 +79,12 @@ configfrag_hotplug_cpu () {
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
@@ -98,7 +98,7 @@ identify_qemu () {
 		echo Cannot figure out what qemu command to use! 1>&2
 		echo file $1 output: $u
 		# Usually this will be one of /usr/bin/qemu-system-*
-		# Use RCU_QEMU_CMD environment variable or appropriate
+		# Use TORTURE_QEMU_CMD environment variable or appropriate
 		# argument to top-level script.
 		exit 1
 	fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index d397ecc55293..ea59e2950f14 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -141,7 +141,7 @@ do
 		;;
 	--qemu-cmd)
 		checkarg --qemu-cmd "(qemu-system-...)" $# "$2" 'qemu-system-' '^--'
-		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
+		TORTURE_QEMU_CMD="$2"; export TORTURE_QEMU_CMD
 		shift
 		;;
 	--results)
@@ -377,7 +377,7 @@ then
 	echo TORTURE_BUILDONLY="$TORTURE_BUILDONLY; export TORTURE_BUILDONLY"
 	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
 	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
-	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
+	echo TORTURE_QEMU_CMD="$TORTURE_QEMU_CMD; export TORTURE_QEMU_CMD"
 	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
 		export TORTURE_QEMU_INTERACTIVE"
 	echo TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC; export TORTURE_QEMU_MAC"
-- 
1.8.1.5

