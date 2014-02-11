Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBKQeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:34:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46715 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaBKQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:28 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/8] ARM: l2x0: make use of of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:24:04 -0600
Message-Id: <1392135847-30791-7-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the of_find_matching_node()/of_match_node() pair, which requires two
iterations through the match table, make use of of_find_matching_node_and_match(),
which only iterates through the table once.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 arch/arm/mm/cache-l2x0.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 7abde2c..e35fff3 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -970,11 +970,12 @@ static const struct of_device_id l2x0_ids[] __initconst = {
 
 int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
 {
+	const struct of_device_id *match;
 	struct device_node *np;
 	const struct l2x0_of_data *data;
 	struct resource res;
 
-	np = of_find_matching_node(NULL, l2x0_ids);
+	np = of_find_matching_node_and_match(NULL, l2x0_ids, &match);
 	if (!np)
 		return -ENODEV;
 
@@ -987,7 +988,7 @@ int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
 
 	l2x0_saved_regs.phy_base = res.start;
 
-	data = of_match_node(l2x0_ids, np)->data;
+	data = match->data;
 
 	/* L2 configuration can only be changed if the cache is disabled */
 	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & L2X0_CTRL_EN)) {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

