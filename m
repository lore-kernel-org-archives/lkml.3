Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaBKQ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:26:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46670 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaBKQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/8] bus: mvebu-mbus: make use of of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:24:00 -0600
Message-Id: <1392135847-30791-3-git-send-email-joshc@codeaurora.org>
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
 drivers/bus/mvebu-mbus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 725c461..31f2c80 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -890,13 +890,12 @@ int __init mvebu_mbus_dt_init(void)
 	const __be32 *prop;
 	int ret;
 
-	np = of_find_matching_node(NULL, of_mvebu_mbus_ids);
+	np = of_find_matching_node_and_match(NULL, of_mvebu_mbus_ids, &of_id);
 	if (!np) {
 		pr_err("could not find a matching SoC family\n");
 		return -ENODEV;
 	}
 
-	of_id = of_match_node(of_mvebu_mbus_ids, np);
 	mbus_state.soc = of_id->data;
 
 	prop = of_get_property(np, "controller", NULL);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

