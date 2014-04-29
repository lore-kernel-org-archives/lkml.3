Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbaD2Aay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48577 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 23/45] torture: Permit multi-word qemu and boot arguments
Date: Mon, 28 Apr 2014 17:25:11 -0700
Message-Id: <1398731133-18925-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1542-0000-0000-00000169D314
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies quotes to permit multi-word --qemu-args and
--bootargs arguments.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 93a6c5a8517d..9b838c372698 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -277,8 +277,8 @@ awk < $T/cfgcpu.pack \
 	-v ncpus=$cpus \
 	-v rd=$resdir/$ds/ \
 	-v dur=$dur \
-	-v TORTURE_QEMU_ARG=$TORTURE_QEMU_ARG \
-	-v TORTURE_BOOTARGS=$TORTURE_BOOTARGS \
+	-v TORTURE_QEMU_ARG="$TORTURE_QEMU_ARG" \
+	-v TORTURE_BOOTARGS="$TORTURE_BOOTARGS" \
 'BEGIN {
 	i = 0;
 }
-- 
1.8.1.5

