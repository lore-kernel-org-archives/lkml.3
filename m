Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527Ab3CZPgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:36:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26462 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163Ab3CZPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:36:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] rcu: don't allocate bootmem from rcu_init
Date: Tue, 26 Mar 2013 11:35:16 -0400
Message-Id: <1364312116-11641-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rcu_init is called we already have slab working, allocating bootmem
at that point results in warnings and an allocation from slab.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/rcutree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index d084ae3..73bac82 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -87,7 +87,7 @@ static void __init rcu_bootup_announce_oddness(void)
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

