Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaBQW30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:29:26 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35093 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaBQWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/55] rcutorture: Don't create results directory for dryruns
Date: Mon, 17 Feb 2014 14:12:20 -0800
Message-Id: <1392675179-11560-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F37C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit prevents the results directory from being created for
dryruns.  However, a script generated from a dryrun will create
the results directory should it be run.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 34 +++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index cde25d8546da..521f9e01074d 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -175,31 +175,29 @@ fi
 if test -z "$resdir"
 then
 	resdir=$KVM/res
-	if ! test -e $resdir
-	then
-		mkdir $resdir || :
-	fi
-else
+fi
+
+if test "$dryrun" = ""
+then
 	if ! test -e $resdir
 	then
 		mkdir -p "$resdir" || :
 	fi
-fi
-mkdir $resdir/$ds
-if test "$dryrun" = ""
-then
+	mkdir $resdir/$ds
+
 	# Be noisy only if running the script.
 	echo Results directory: $resdir/$ds
 	echo $scriptname $args
-fi
-touch $resdir/$ds/log
-echo $scriptname $args >> $resdir/$ds/log
 
-pwd > $resdir/$ds/testid.txt
-if test -d .git
-then
-	git status >> $resdir/$ds/testid.txt
-	git rev-parse HEAD >> $resdir/$ds/testid.txt
+	touch $resdir/$ds/log
+	echo $scriptname $args >> $resdir/$ds/log
+
+	pwd > $resdir/$ds/testid.txt
+	if test -d .git
+	then
+		git status >> $resdir/$ds/testid.txt
+		git rev-parse HEAD >> $resdir/$ds/testid.txt
+	fi
 fi
 
 # Create a file of test-name/#cpus pairs, sorted by decreasing #cpus.
@@ -371,6 +369,8 @@ then
 	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
 	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
 	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
+	echo "mkdir -p "$resdir" || :"
+	echo "mkdir $resdir/$ds"
 	cat $T/script
 	exit 0
 elif test "$dryrun" = sched
-- 
1.8.1.5

