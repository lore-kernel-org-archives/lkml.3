Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3FQRpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:45:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41501 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3FQRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:43:23 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH/RESEND 08/12] ARM: msm: Remove custom clk_set_{max,min}_rate() API
Date: Mon, 17 Jun 2013 10:43:15 -0700
Message-Id: <1371490999-15501-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users of this API anymore so let's just remove it.
If a need arises in the future we can extend the common clock API
to handle it.

Acked-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-debug.c      |  9 +--------
 arch/arm/mach-msm/clock.c            | 12 ------------
 arch/arm/mach-msm/include/mach/clk.h |  6 ------
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 4886404..c4b34d7 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -25,14 +25,7 @@ static int clock_debug_rate_set(void *data, u64 val)
 	struct clk *clock = data;
 	int ret;
 
-	/* Only increases to max rate will succeed, but that's actually good
-	 * for debugging purposes so we don't check for error. */
-	if (clock->flags & CLK_MAX)
-		clk_set_max_rate(clock, val);
-	if (clock->flags & CLK_MIN)
-		ret = clk_set_min_rate(clock, val);
-	else
-		ret = clk_set_rate(clock, val);
+	ret = clk_set_rate(clock, val);
 	if (ret != 0)
 		printk(KERN_ERR "clk_set%s_rate failed (%d)\n",
 			(clock->flags & CLK_MIN) ? "_min" : "", ret);
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 5fac2df..8d07b25 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -97,18 +97,6 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 }
 EXPORT_SYMBOL(clk_round_rate);
 
-int clk_set_min_rate(struct clk *clk, unsigned long rate)
-{
-	return clk->ops->set_min_rate(clk->id, rate);
-}
-EXPORT_SYMBOL(clk_set_min_rate);
-
-int clk_set_max_rate(struct clk *clk, unsigned long rate)
-{
-	return clk->ops->set_max_rate(clk->id, rate);
-}
-EXPORT_SYMBOL(clk_set_max_rate);
-
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	return -ENOSYS;
diff --git a/arch/arm/mach-msm/include/mach/clk.h b/arch/arm/mach-msm/include/mach/clk.h
index 5f1c37d..fd4f4a7 100644
--- a/arch/arm/mach-msm/include/mach/clk.h
+++ b/arch/arm/mach-msm/include/mach/clk.h
@@ -25,12 +25,6 @@ enum clk_reset_action {
 
 struct clk;
 
-/* Rate is minimum clock rate in Hz */
-int clk_set_min_rate(struct clk *clk, unsigned long rate);
-
-/* Rate is maximum clock rate in Hz */
-int clk_set_max_rate(struct clk *clk, unsigned long rate);
-
 /* Assert/Deassert reset to a hardware block associated with a clock */
 int clk_reset(struct clk *clk, enum clk_reset_action action);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

