Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbaD2AgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:36:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52566 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbaD2AZs (ORCPT
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
Subject: [PATCH tip/core/rcu 11/45] torture: Rename RCU_QEMU_INTERACTIVE to TORTURE_QEMU_INTERACTIVE
Date: Mon, 28 Apr 2014 17:24:59 -0700
Message-Id: <1398731133-18925-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1344-0000-0000-00000134E892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit makes the torture scripts a bit more RCU-independent.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/functions.sh | 12 ++++++------
 tools/testing/selftests/rcutorture/bin/kvm.sh       |  5 +++--
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 9b17e810ddc3..623939cf814e 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -107,14 +107,14 @@ identify_qemu () {
 # identify_qemu_append qemu-cmd
 #
 # Output arguments for the qemu "-append" string based on CPU type
-# and the RCU_QEMU_INTERACTIVE environment variable.
+# and the TORTURE_QEMU_INTERACTIVE environment variable.
 identify_qemu_append () {
 	case "$1" in
 	qemu-system-x86_64|qemu-system-i386)
 		echo noapic selinux=0 initcall_debug debug
 		;;
 	esac
-	if test -n "$RCU_QEMU_INTERACTIVE"
+	if test -n "$TORTURE_QEMU_INTERACTIVE"
 	then
 		echo root=/dev/sda
 	else
@@ -125,7 +125,7 @@ identify_qemu_append () {
 # identify_qemu_args qemu-cmd serial-file
 #
 # Output arguments for qemu arguments based on the RCU_QEMU_MAC
-# and RCU_QEMU_INTERACTIVE environment variables.
+# and TORTURE_QEMU_INTERACTIVE environment variables.
 identify_qemu_args () {
 	case "$1" in
 	qemu-system-x86_64|qemu-system-i386)
@@ -133,17 +133,17 @@ identify_qemu_args () {
 	qemu-system-ppc64)
 		echo -enable-kvm -M pseries -cpu POWER7 -nodefaults
 		echo -device spapr-vscsi
-		if test -n "$RCU_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
+		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
 		then
 			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
 			echo -netdev bridge,br=br0,id=net0
-		elif test -n "$RCU_QEMU_INTERACTIVE"
+		elif test -n "$TORTURE_QEMU_INTERACTIVE"
 		then
 			echo -net nic -net user
 		fi
 		;;
 	esac
-	if test -n "$RCU_QEMU_INTERACTIVE"
+	if test -n "$TORTURE_QEMU_INTERACTIVE"
 	then
 		echo -monitor stdio -serial pty -S
 	else
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 73c586f6bdf6..2f9605ed5b58 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -114,7 +114,7 @@ do
 		shift
 		;;
 	--interactive)
-		RCU_QEMU_INTERACTIVE=1; export RCU_QEMU_INTERACTIVE
+		TORTURE_QEMU_INTERACTIVE=1; export TORTURE_QEMU_INTERACTIVE
 		;;
 	--kmake-arg)
 		checkarg --kmake-arg "(kernel make arguments)" $# "$2" '.*' '^error$'
@@ -378,7 +378,8 @@ then
 	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
 	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
 	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
-	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
+	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
+		export TORTURE_QEMU_INTERACTIVE"
 	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
 	echo "mkdir -p "$resdir" || :"
 	echo "mkdir $resdir/$ds"
-- 
1.8.1.5

