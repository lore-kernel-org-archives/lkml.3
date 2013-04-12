Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3DLXU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:20:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48187 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3DLXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:19:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/7] rcu: Don't allocate bootmem from rcu_init()
Date: Fri, 12 Apr 2013 16:19:11 -0700
Message-Id: <1365808754-20762-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-2876-0000-0000-000007687A23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

When rcu_init() is called we already have slab working, allocating
bootmem at that point results in warnings and an allocation from
slab.  This commit therefore changes alloc_bootmem_cpumask_var() to
alloc_cpumask_var() in rcu_bootup_announce_oddness(), which is called
from rcu_init().

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ca6e39c..44b0998 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -86,7 +86,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
-		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+		alloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO
-- 
1.8.1.5

