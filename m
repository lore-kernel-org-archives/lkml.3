Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3CJNfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:35:54 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38836 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:35:53 -0400
From: Mihai Stirbat <mihai.stirbat@gmail.com>
To: linux@arm.linux.org.uk
Cc: vincent.guittot@linaro.org, namhyung@kernel.org, lorenzo.pieralisi@arm.com,
        a.p.zijlstra@chello.nl, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mihai Stirbat <mihai.stirbat@gmail.com>
Subject: [PATCH] topology: removed kzalloc return value cast
Date: Sun, 10 Mar 2013 15:35:35 +0200
Message-Id: <1362922535-25172-1-git-send-email-mihai.stirbat@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihai Stirbat <mihai.stirbat@gmail.com>
---
 arch/arm/kernel/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 79282eb..f10316b 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -100,7 +100,7 @@ static void __init parse_dt_topology(void)
 	int alloc_size, cpu = 0;
 
 	alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
-	cpu_capacity = (struct cpu_capacity *)kzalloc(alloc_size, GFP_NOWAIT);
+	cpu_capacity = kzalloc(alloc_size, GFP_NOWAIT);
 
 	while ((cn = of_find_node_by_type(cn, "cpu"))) {
 		const u32 *rate, *reg;
-- 
1.7.10.4

