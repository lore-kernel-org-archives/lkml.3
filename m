Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbaD2Ahz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:37:55 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59671 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbaD2AZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/45] torture: Remove obsolete builddir options
Date: Mon, 28 Apr 2014 17:24:50 -0700
Message-Id: <1398731133-18925-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D1356
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The --builddir and --relbuilddir options were initially intended to handle
parallel tests.  However, since commit 43e38ab3d518 (Enable concurrent
rcutorture runs), the script manages multiple build directories as
needed for parallel testing.  This commit therefore removes these two
obsolete options.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 5a78cbf55f06..37a60ef70df3 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -38,7 +38,6 @@ dur=30
 dryrun=""
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
-builddir="${KVM}/b1"
 RCU_INITRD="$KVM/initrd"; export RCU_INITRD
 RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
 TORTURE_SUITE=rcu
@@ -53,7 +52,6 @@ kversion=""
 usage () {
 	echo "Usage: $scriptname optional arguments:"
 	echo "       --bootargs kernel-boot-arguments"
-	echo "       --builddir absolute-pathname"
 	echo "       --buildonly"
 	echo "       --configs \"config-file list\""
 	echo "       --cpus N"
@@ -67,7 +65,6 @@ usage () {
 	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
 	echo "       --qemu-cmd qemu-system-..."
-	echo "       --relbuilddir relative-pathname"
 	echo "       --results absolute-pathname"
 	echo "       --torture rcu"
 	exit 1
@@ -81,12 +78,6 @@ do
 		RCU_BOOTARGS="$2"
 		shift
 		;;
-	--builddir)
-		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' '^error'
-		builddir=$2
-		gotbuilddir=1
-		shift
-		;;
 	--buildonly)
 		RCU_BUILDONLY=1; export RCU_BUILDONLY
 		;;
@@ -146,13 +137,6 @@ do
 		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
 		shift
 		;;
-	--relbuilddir)
-		checkarg --relbuilddir "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
-		relbuilddir=$2
-		gotrelbuilddir=1
-		builddir=${KVM}/${relbuilddir}
-		shift
-		;;
 	--results)
 		checkarg --results "(absolute pathname)" "$#" "$2" '^/' '^error'
 		resdir=$2
-- 
1.8.1.5

