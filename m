Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaD2AZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:25:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52531 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbaD2AZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/45] torture: Add batch headers "--dryrun sched"
Date: Mon, 28 Apr 2014 17:24:51 -0700
Message-Id: <1398731133-18925-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1344-0000-0000-00000134E87D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit makes the output of "--dryrun sched" more user-friendly,
clearly indicating the batch starts.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 37a60ef70df3..740676255c6a 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -379,7 +379,8 @@ then
 elif test "$dryrun" = sched
 then
 	# Extract the test run schedule from the script.
-	egrep 'start batch|Starting build\.' $T/script |
+	egrep 'Start batch|Starting build\.' $T/script |
+		grep -v ">>" |
 		sed -e 's/:.*$//' -e 's/^echo //'
 	exit 0
 else
-- 
1.8.1.5

