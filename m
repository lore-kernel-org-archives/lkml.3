Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaBQWNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44638 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaBQWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:12 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/55] rcutorture: Print script and arguments to standard output
Date: Mon, 17 Feb 2014 14:12:06 -0800
Message-Id: <1392675179-11560-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34EAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although the script name and arguments are logged in the results directory,
it is more convenient to see it in the output.  This commit therefore
adds the output of this information.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-recheck.sh | 7 +++++++
 tools/testing/selftests/rcutorture/bin/kvm.sh         | 1 +
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index e3b1af3677e3..eb2850935c26 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -27,9 +27,16 @@
 PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
 for rd in "$@"
 do
+	firsttime=1
 	dirs=`find $rd -name Make.defconfig.out -print | sort | sed -e 's,/[^/]*$,,' | sort -u`
 	for i in $dirs
 	do
+		if test $firsttime
+		then
+			firsttime=0
+			resdir=`echo $i | sed -e 's,/$,,' -e 's,/[^/]*$,,'`
+			head -1 $resdir/log
+		fi
 		configfile=`echo $i | sed -e 's/^.*\///'`
 		ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
 		if test -z "$ngps"
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 1b7923bf6a70..f60f98415f13 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -169,6 +169,7 @@ else
 fi
 mkdir $resdir/$ds
 touch $resdir/$ds/log
+echo $scriptname $args
 echo $scriptname $args >> $resdir/$ds/log
 
 pwd > $resdir/$ds/testid.txt
-- 
1.8.1.5

