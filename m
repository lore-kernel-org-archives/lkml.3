Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbbAGSU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:20:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53626 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbbAGSTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/12] rcutorture: Handle different mpstat versions
Date: Wed,  7 Jan 2015 10:19:35 -0800
Message-Id: <1420654779-11213-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-8236-0000-0000-0000086A7734
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The mpstat command recently added the %gnice column, which messes up
the cpu2use.sh script's idle-CPU calculations.  This commit therefore
uses $NF instead of $12 to select the last (%idle) column.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/cpus2use.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/cpus2use.sh b/tools/testing/selftests/rcutorture/bin/cpus2use.sh
index abe14b7f36e9..bb99cde3f5f9 100755
--- a/tools/testing/selftests/rcutorture/bin/cpus2use.sh
+++ b/tools/testing/selftests/rcutorture/bin/cpus2use.sh
@@ -24,7 +24,7 @@
 
 ncpus=`grep '^processor' /proc/cpuinfo | wc -l`
 idlecpus=`mpstat | tail -1 | \
-	awk -v ncpus=$ncpus '{ print ncpus * ($7 + $12) / 100 }'`
+	awk -v ncpus=$ncpus '{ print ncpus * ($7 + $NF) / 100 }'`
 awk -v ncpus=$ncpus -v idlecpus=$idlecpus < /dev/null '
 BEGIN {
 	cpus2use = idlecpus;
-- 
1.8.1.5

