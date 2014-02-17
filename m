Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaBQWNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35103 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaBQWNO (ORCPT
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
Subject: [PATCH tip/core/rcu 26/55] rcutorture: Print dates when doing parallel rcutorture runs
Date: Mon, 17 Feb 2014 14:12:30 -0800
Message-Id: <1392675179-11560-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F37CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 521f9e01074d..242b52d11cf9 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -286,7 +286,7 @@ awk < $T/cfgcpu.pack \
 # Dump out the scripting required to run one test batch.
 function dump(first, pastlast)
 {
-	print "echo ----start batch----"
+	print "echo ----Start batch: `date`"
 	jn=1
 	for (j = first; j < pastlast; j++) {
 		builddir=KVM "/b" jn
@@ -302,27 +302,27 @@ function dump(first, pastlast)
 			ovf = "(!)";
 		else
 			ovf = "";
-		print "echo ", cfr[jn], cpusr[jn] ovf ": Starting build.";
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Starting build. `date`";
 		print "rm -f " builddir ".*";
 		print "touch " builddir ".wait";
 		print "mkdir " builddir " > /dev/null 2>&1 || :";
 		print "mkdir " rd cfr[jn] " || :";
 		print "kvm-test-1-rcu.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
-		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete."
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date`"
 		print "while test -f " builddir ".wait"
 		print "do"
 		print "\tsleep 1"
 		print "done"
-		print "echo ", cfr[jn], cpusr[jn] ovf ": Build complete."
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Build complete. `date`"
 		jn++;
 	}
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "rm -f " builddir ".ready"
-		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel"
+		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date`"
 	}
 	print "wait"
-	print "echo ---- All kernel runs complete"
+	print "echo ---- All kernel runs complete. `date`"
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results:"
-- 
1.8.1.5

