Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3KPAlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:41:21 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52398 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3KPAfw (ORCPT
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
Subject: [PATCH tip/core/rcu 14/28] rcutorture: Eliminate --rcu-kvm argument
Date: Fri, 15 Nov 2013 16:35:27 -0800
Message-Id: <1384562141-32446-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-3532-0000-0000-000003112BEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The --rcu-kvm argument was intended to allow the scripts to live in
an alternate location.  Unfortunately, this prevents the kvm.sh script
from using common functions until after it finished parsing arguments,
because it doesn't know where to find them until then.  However, "cp -a"
and "ln -s" work pretty well, so lack of an --rcu-kvm argument can be
easily worked around.

This commit therefore removes this argument.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 89164c245ca1..2af549491f23 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -46,7 +46,6 @@ usage () {
 	echo "       --duration minutes"
 	echo "       --kversion vN.NN"
 	echo "       --qemu-cmd qemu-system-..."
-	echo "       --rcu-kvm absolute-pathname"
 	echo "       --results absolute-pathname"
 	echo "       --relbuilddir relative-pathname"
 	exit 1
@@ -107,19 +106,6 @@ do
 		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
 		shift
 		;;
-	--rcu-kvm)
-		checkarg --rcu-kvm "(absolute pathname)" "$#" "$2" '^/' error
-		KVM=$2; export KVM
-		if -z "$gotbuilddir"
-		then
-			builddir=${KVM}/b1
-		fi
-		if -n "$gotrelbuilddir"
-		then
-			builddir=${KVM}/${relbuilddir}
-		fi
-		shift
-		;;
 	--relbuilddir)
 		checkarg --relbuilddir "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
 		relbuilddir=$2
@@ -133,6 +119,7 @@ do
 		shift
 		;;
 	*)
+		echo Unknown argument $1
 		usage
 		;;
 	esac
-- 
1.8.1.5

