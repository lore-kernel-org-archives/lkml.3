Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBKQeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:34:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46722 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaBKQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:29 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 7/8] C6X: make use of of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:24:05 -0600
Message-Id: <1392135847-30791-8-git-send-email-joshc@codeaurora.org>
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
 arch/c6x/platforms/plldata.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/c6x/platforms/plldata.c b/arch/c6x/platforms/plldata.c
index 755359e..8fddc46 100644
--- a/arch/c6x/platforms/plldata.c
+++ b/arch/c6x/platforms/plldata.c
@@ -397,7 +397,7 @@ static void __init c6678_setup_clocks(struct device_node *node)
 }
 #endif /* CONFIG_SOC_TMS320C6678 */
 
-static struct of_device_id c6x_clkc_match[] __initdata = {
+static const struct of_device_id c6x_clkc_match[] __initdata = {
 #ifdef CONFIG_SOC_TMS320C6455
 	{ .compatible = "ti,c6455-pll", .data = c6455_setup_clocks },
 #endif
@@ -426,7 +426,7 @@ void __init c64x_setup_clocks(void)
 	int err;
 	u32 val;
 
-	node = of_find_matching_node(NULL, c6x_clkc_match);
+	node = of_find_matching_node_and_match(NULL, c6x_clkc_match, &id);
 	if (!node)
 		return;
 
@@ -458,8 +458,7 @@ void __init c64x_setup_clocks(void)
 	pll->lock_delay = val;
 
 	/* id->data is a pointer to SoC-specific setup */
-	id = of_match_node(c6x_clkc_match, node);
-	if (id && id->data) {
+	if (id->data) {
 		__setup_clocks = id->data;
 		__setup_clocks(node);
 	}
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

