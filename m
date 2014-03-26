Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaCZXGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:06:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37664 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbaCZXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:06:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] clk: Don't check for missing ops in clk_set_parent()
Date: Wed, 26 Mar 2014 16:06:35 -0700
Message-Id: <1395875197-16816-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
References: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We dereference clk->ops during clock registration so this check
for NULL ops can't possibly ever be true.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index fb3c40b4fbe2..10e0afaefe2f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1712,9 +1712,6 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (!clk)
 		return 0;
 
-	if (!clk->ops)
-		return -EINVAL;
-
 	/* verify ops for for multi-parent clks */
 	if ((clk->num_parents > 1) && (!clk->ops->set_parent))
 		return -ENOSYS;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

