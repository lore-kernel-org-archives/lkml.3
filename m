Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750843AbaF1EH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 00:07:56 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:42887 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaF1EHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 00:07:55 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] FIXME of file toploogy.h for alpha cpus
Date: Sat, 28 Jun 2014 00:07:49 -0400
Message-Id: <1403928469-9452-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixs the FIXME message in the function *cpumask_of_node
for using this function multiple times and the issue with recaluting
the cpu node mask when reusing this function.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/alpha/include/asm/topology.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
index 9251e13..d301f66 100644
--- a/arch/alpha/include/asm/topology.h
+++ b/arch/alpha/include/asm/topology.h
@@ -31,6 +31,9 @@ static const struct cpumask *cpumask_of_node(int node)
 	if (node == -1)
 		return cpu_all_mask;
 
+	else if (node == &node_to_cpumask_map[node])
+		return &node_to_cpumask_map[node];
+
 	cpumask_clear(&node_to_cpumask_map[node]);
 
 	for_each_online_cpu(cpu) {
-- 
1.9.1
