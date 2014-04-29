Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbaD2AgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:36:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47133 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaD2AZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/45] torture: Rename RCU_QEMU_MAC to TORTURE_QEMU_MAC
Date: Mon, 28 Apr 2014 17:25:00 -0700
Message-Id: <1398731133-18925-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-9332-0000-0000-000000A24CF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit makes the torture scripts a bit more RCU-independent.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/functions.sh | 6 +++---
 tools/testing/selftests/rcutorture/bin/kvm.sh       | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 623939cf814e..41fb52b805e4 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -124,7 +124,7 @@ identify_qemu_append () {
 
 # identify_qemu_args qemu-cmd serial-file
 #
-# Output arguments for qemu arguments based on the RCU_QEMU_MAC
+# Output arguments for qemu arguments based on the TORTURE_QEMU_MAC
 # and TORTURE_QEMU_INTERACTIVE environment variables.
 identify_qemu_args () {
 	case "$1" in
@@ -133,9 +133,9 @@ identify_qemu_args () {
 	qemu-system-ppc64)
 		echo -enable-kvm -M pseries -cpu POWER7 -nodefaults
 		echo -device spapr-vscsi
-		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
+		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$TORTURE_QEMU_MAC"
 		then
-			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
+			echo -device spapr-vlan,netdev=net0,mac=$TORTURE_QEMU_MAC
 			echo -netdev bridge,br=br0,id=net0
 		elif test -n "$TORTURE_QEMU_INTERACTIVE"
 		then
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 2f9605ed5b58..1a4a68c76914 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -128,7 +128,7 @@ do
 		;;
 	--mac)
 		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
-		RCU_QEMU_MAC=$2; export RCU_QEMU_MAC
+		TORTURE_QEMU_MAC=$2; export TORTURE_QEMU_MAC
 		shift
 		;;
 	--no-initrd)
@@ -380,7 +380,7 @@ then
 	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
 	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
 		export TORTURE_QEMU_INTERACTIVE"
-	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
+	echo TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC; export TORTURE_QEMU_MAC"
 	echo "mkdir -p "$resdir" || :"
 	echo "mkdir $resdir/$ds"
 	cat $T/script
-- 
1.8.1.5

