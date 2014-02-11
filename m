Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaBKQfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:35:02 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46692 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBKQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:27 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/8] ARM: mvebu: make use of of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:24:02 -0600
Message-Id: <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the of_find_matching_node()/of_match_node() pair, which requires two
iterations through the match table, make use of of_find_matching_node_and_match(),
which only iterates through the table once.

While we're here, mark the of_system_controller table const.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 arch/arm/mach-mvebu/system-controller.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-mvebu/system-controller.c b/arch/arm/mach-mvebu/system-controller.c
index a7fb89a..e6e300a 100644
--- a/arch/arm/mach-mvebu/system-controller.c
+++ b/arch/arm/mach-mvebu/system-controller.c
@@ -54,7 +54,7 @@ static const struct mvebu_system_controller orion_system_controller = {
 	.system_soft_reset = 0x1,
 };
 
-static struct of_device_id of_system_controller_table[] = {
+static const struct of_device_id of_system_controller_table[] = {
 	{
 		.compatible = "marvell,orion-system-controller",
 		.data = (void *) &orion_system_controller,
@@ -90,13 +90,12 @@ void mvebu_restart(enum reboot_mode mode, const char *cmd)
 
 static int __init mvebu_system_controller_init(void)
 {
+	const struct of_device_id *match;
 	struct device_node *np;
 
-	np = of_find_matching_node(NULL, of_system_controller_table);
+	np = of_find_matching_node_and_match(NULL, of_system_controller_table,
+					     &match);
 	if (np) {
-		const struct of_device_id *match =
-		    of_match_node(of_system_controller_table, np);
-		BUG_ON(!match);
 		system_controller_base = of_iomap(np, 0);
 		mvebu_sc = (struct mvebu_system_controller *)match->data;
 		of_node_put(np);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

