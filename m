Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3KPAjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:39:41 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58286 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3KPAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 22/28] rcutorture: Add --kmake-arg argument to kvm.sh
Date: Fri, 15 Nov 2013 16:35:35 -0800
Message-Id: <1384562141-32446-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DDF41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the --kmake-arg to kvm.sh, which allows passing in
things like "V=1" to see the build commands, as well as enabling the
CROSS_COMPILE= make macro used for cross-building.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm-build.sh | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh       | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index 618ef2c543fd..8c4aa7d63394 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -60,7 +60,7 @@ then
 	exit 2
 fi
 ncpus=`cpus2use.sh`
-make O=$builddir -j$ncpus > $builddir/Make.out 2>&1
+make O=$builddir -j$ncpus $RCU_KMAKE_ARG > $builddir/Make.out 2>&1
 retval=$?
 if test $retval -ne 0 || grep "rcu[^/]*": < $builddir/Make.out | egrep -q "Stop|Error|error:|warning:" || egrep -q "Stop|Error|error:" < $builddir/Make.out
 then
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index a833160dcdc3..69b6523bb854 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -34,6 +34,7 @@ dur=30
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 builddir="${KVM}/b1"
 RCU_INITRD="$KVM/initrd"; export RCU_INITRD
+RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
 resdir=""
 configs=""
 ds=`date +%Y.%m.%d-%H:%M:%S`
@@ -48,6 +49,7 @@ usage () {
 	echo "       --datestamp string"
 	echo "       --duration minutes"
 	echo "       --interactive"
+	echo "       --kmake-arg kernel-make-arguments"
 	echo "       --kversion vN.NN"
 	echo "       --mac nn:nn:nn:nn:nn:nn"
 	echo "       --no-initrd"
@@ -114,6 +116,11 @@ do
 	--interactive)
 		RCU_QEMU_INTERACTIVE=1; export RCU_QEMU_INTERACTIVE
 		;;
+	--kmake-arg)
+		checkarg --kmake-arg "(kernel make arguments)" $# "$2" '.*' '^error$'
+		RCU_KMAKE_ARG="$2"; export RCU_KMAKE_ARG
+		shift
+		;;
 	--kversion)
 		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' '^error'
 		kversion=$2
-- 
1.8.1.5

