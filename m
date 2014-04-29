Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaD2A17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:27:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36951 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaD2AZw (ORCPT
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
Subject: [PATCH tip/core/rcu 39/45] rcutorture: Note diffs from git commits
Date: Mon, 28 Apr 2014 17:25:27 -0700
Message-Id: <1398731133-18925-39-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-000001809EFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current scripting only keeps track of the git SHA-1 of the current
HEAD.  This can cause confusion in cases where testing ran in a git
tree where changes had not yet been checked in.  This commit therefore
also records the output of "git diff HEAD" to provide the information
needed to reconstruct the source tree that was tested.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 4eed2a4f42c7..91661845fdec 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -277,6 +277,11 @@ if test -d .git
 then
 	git status >> $resdir/$ds/testid.txt
 	git rev-parse HEAD >> $resdir/$ds/testid.txt
+	git diff HEAD > $T/git-diff 2>&1
+	if test -s $T/git-diff
+	then
+		cp $T/git-diff $resdir/$ds
+	fi
 fi
 ___EOF___
 awk < $T/cfgcpu.pack \
-- 
1.8.1.5

