Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaFMXgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:36:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34146 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaFMXgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:36:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clkdev: Don't print errors on probe defer
Date: Fri, 13 Jun 2014 16:36:31 -0700
Message-Id: <1402702591-21087-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error message can spam the logs if you have lots of probe
deferals due to missing clocks. Just silence the error in this
case because the driver should try again later.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clkdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index f890b901c6bc..da4bda8b7fc7 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -101,8 +101,9 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 		if (!IS_ERR(clk))
 			break;
 		else if (name && index >= 0) {
-			pr_err("ERROR: could not get clock %s:%s(%i)\n",
-				np->full_name, name ? name : "", index);
+			if (PTR_ERR(clk) != -EPROBE_DEFER)
+				pr_err("ERROR: could not get clock %s:%s(%i)\n",
+					np->full_name, name ? name : "", index);
 			return clk;
 		}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

