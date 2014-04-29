Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaD2Ahw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:37:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37365 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960AbaD2AZq (ORCPT
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
Subject: [PATCH tip/core/rcu 05/45] torture: Rename RCU_INITRD to TORTURE_INITRD
Date: Mon, 28 Apr 2014 17:24:53 -0700
Message-Id: <1398731133-18925-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2CD
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
index 197901ec10bf..d8e68a5e4411 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -47,7 +47,7 @@ mkdir $T
 
 cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
 cat << ___EOF___ >> $T/config
-CONFIG_INITRAMFS_SOURCE="$RCU_INITRD"
+CONFIG_INITRAMFS_SOURCE="$TORTURE_INITRD"
 CONFIG_VIRTIO_PCI=y
 CONFIG_VIRTIO_CONSOLE=y
 ___EOF___
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 740676255c6a..a52a077ee258 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -38,7 +38,7 @@ dur=30
 dryrun=""
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
-RCU_INITRD="$KVM/initrd"; export RCU_INITRD
+TORTURE_INITRD="$KVM/initrd"; export TORTURE_INITRD
 RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
 TORTURE_SUITE=rcu
 resdir=""
@@ -125,7 +125,7 @@ do
 		shift
 		;;
 	--no-initrd)
-		RCU_INITRD=""; export RCU_INITRD
+		TORTURE_INITRD=""; export TORTURE_INITRD
 		;;
 	--qemu-args)
 		checkarg --qemu-args "-qemu args" $# "$2" '^-' '^error'
@@ -367,7 +367,7 @@ then
 	echo KVPATH="$KVPATH; export KVPATH"
 	echo PATH="$PATH; export PATH"
 	echo RCU_BUILDONLY="$RCU_BUILDONLY; export RCU_BUILDONLY"
-	echo RCU_INITRD="$RCU_INITRD; export RCU_INITRD"
+	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
 	echo RCU_KMAKE_ARG="$RCU_KMAKE_ARG; export RCU_KMAKE_ARG"
 	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
 	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
-- 
1.8.1.5

