Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaBQWOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:33 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51124 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 53/55] rcutorture: Place kvm-test-1-run.sh output into res directory
Date: Mon, 17 Feb 2014 14:12:57 -0800
Message-Id: <1392675179-11560-53-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1344-0000-0000-000005D5BE43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The output of each kvm-test-1-run.sh script is placed into a file
whose name parallels that of the build directory.  This means that
the kvm-test-1-run.sh output is overwritten by later run.  This
commit therefore places the kvm-test-1-run.sh output into the
per-test-case directory in the "res" hierarchy.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 8d3a6e916811..48b27e9716ae 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -318,7 +318,7 @@ function dump(first, pastlast)
 		print "touch " builddir ".wait";
 		print "mkdir " builddir " > /dev/null 2>&1 || :";
 		print "mkdir " rd cfr[jn] " || :";
-		print "kvm-test-1-run.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
+		print "kvm-test-1-run.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " rd cfr[jn]  "/kvm-test-1-run.sh.out 2>&1 &"
 		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date`"
 		print "while test -f " builddir ".wait"
 		print "do"
@@ -337,7 +337,7 @@ function dump(first, pastlast)
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results:"
-		print "cat " builddir ".out"
+		print "cat " rd cfr[j]  "/kvm-test-1-run.sh.out"
 	}
 }
 
-- 
1.8.1.5

