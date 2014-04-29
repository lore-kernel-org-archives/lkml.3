Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbaD2A2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52047 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbaD2AZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 41/45] torture: Put qemu into the background
Date: Mon, 28 Apr 2014 17:25:29 -0700
Message-Id: <1398731133-18925-41-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-8236-0000-0000-000001E64AB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, qemu runs in the foreground, which prevents the script from
killing it in case the kernel locks up.  This commit therefore places
qemu into the background, allowing the script to recover from lockups.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index b1e85b049075..67e89f06e77f 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -157,7 +157,7 @@ then
 	echo Build-only run specified, boot/test omitted.
 	exit 0
 fi
-$QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval &
+( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
-- 
1.8.1.5

