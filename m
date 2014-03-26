Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaCZXGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:06:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37657 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaCZXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:06:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] clk: Ignore error and NULL pointers passed to clk_{unprepare,disable}()
Date: Wed, 26 Mar 2014 16:06:37 -0700
Message-Id: <1395875197-16816-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
References: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error paths in drivers that use optional clocks
by allowing the NULL or error pointer to be passed
unconditionally.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index e924401c0030..d7d359b0f76d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -818,6 +818,9 @@ void __clk_unprepare(struct clk *clk)
  */
 void clk_unprepare(struct clk *clk)
 {
+	if (IS_ERR_OR_NULL(clk))
+		return;
+
 	clk_prepare_lock();
 	__clk_unprepare(clk);
 	clk_prepare_unlock();
@@ -879,9 +882,6 @@ static void __clk_disable(struct clk *clk)
 	if (!clk)
 		return;
 
-	if (WARN_ON(IS_ERR(clk)))
-		return;
-
 	if (WARN_ON(clk->enable_count == 0))
 		return;
 
@@ -910,6 +910,9 @@ void clk_disable(struct clk *clk)
 {
 	unsigned long flags;
 
+	if (IS_ERR_OR_NULL(clk))
+		return;
+
 	flags = clk_enable_lock();
 	__clk_disable(clk);
 	clk_enable_unlock(flags);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

