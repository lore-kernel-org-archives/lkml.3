Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbbAGSWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:22:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55736 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbbAGSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/12] torture: Flag console.log file to prevent holdovers from earlier runs
Date: Wed,  7 Jan 2015 10:19:37 -0800
Message-Id: <1420654779-11213-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0033-0000-0000-0000033D3B50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A system misconfiguration that prevents qemu from running at all (for
example, a missing dynamically linked library) will keep the console.log
file from the previous run.  This can fool the developer into thinking
that this failed run actually completed correctly.  This commit therefore
overwrites the console.log file just before launching qemu.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 35b8532ed053..5236e073919d 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -168,6 +168,7 @@ then
 	touch $resdir/buildonly
 	exit 0
 fi
+echo "NOTE: $QEMU either did not run or was interactive" > $builddir/console.log
 echo $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 ( $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
-- 
1.8.1.5

