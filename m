Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3KPAkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:40:18 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59612 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab3KPAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 21/28] rcutorture: Add --no-initrd argument to kvm.sh
Date: Fri, 15 Nov 2013 16:35:34 -0800
Message-Id: <1384562141-32446-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-0000035637BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the --no-initrd argument to kvm.sh, which permits
initrd to be contained in a root partition specified by the --bootargs
argument.  Without --no-initrd, the kernel build expects an initrd
directory in the same rcutorture directory that contains bin and configs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm-build.sh | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh       | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index 07bbeccb5a28..618ef2c543fd 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -47,7 +47,7 @@ mkdir $T
 
 cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
 cat << ___EOF___ >> $T/config
-CONFIG_INITRAMFS_SOURCE="$KVM/initrd"
+CONFIG_INITRAMFS_SOURCE="$RCU_INITRD"
 CONFIG_VIRTIO_PCI=y
 CONFIG_VIRTIO_CONSOLE=y
 ___EOF___
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 7d6ca337d1fd..a833160dcdc3 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -31,8 +31,9 @@ scriptname=$0
 args="$*"
 
 dur=30
-KVM=`pwd`/tools/testing/selftests/rcutorture; export KVM
-builddir=${KVM}/b1
+KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
+builddir="${KVM}/b1"
+RCU_INITRD="$KVM/initrd"; export RCU_INITRD
 resdir=""
 configs=""
 ds=`date +%Y.%m.%d-%H:%M:%S`
@@ -49,6 +50,7 @@ usage () {
 	echo "       --interactive"
 	echo "       --kversion vN.NN"
 	echo "       --mac nn:nn:nn:nn:nn:nn"
+	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
 	echo "       --qemu-cmd qemu-system-..."
 	echo "       --results absolute-pathname"
@@ -122,6 +124,9 @@ do
 		RCU_QEMU_MAC=$2; export RCU_QEMU_MAC
 		shift
 		;;
+	--no-initrd)
+		RCU_INITRD=""; export RCU_INITRD
+		;;
 	--qemu-args)
 		checkarg --qemu-args "-qemu args" $# "$2" '^-' '^error'
 		RCU_QEMU_ARG="$2"
-- 
1.8.1.5

