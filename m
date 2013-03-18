Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab3CRVlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:41:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58297 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113Ab3CRVhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/15] rcu: Add event tracing for no-CBs CPUs' callback registration
Date: Mon, 18 Mar 2013 14:36:39 -0700
Message-Id: <1363642610-21390-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-9360-0000-0000-000011601FFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 90a1914..7225a5a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2285,6 +2285,13 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 	if (!is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
+	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
+		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
+					 (unsigned long)rhp->func,
+					 rdp->qlen_lazy, rdp->qlen);
+	else
+		trace_rcu_callback(rdp->rsp->name, rhp,
+				   rdp->qlen_lazy, rdp->qlen);
 	return 1;
 }
 
-- 
1.8.1.5

