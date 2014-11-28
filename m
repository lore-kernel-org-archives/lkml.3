Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaK1OE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:04:59 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35979 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaK1OE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:04:56 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        sboyd@codeaurora.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/7] clk: Remove unused function __clk_get_prepare_count
Date: Fri, 28 Nov 2014 15:03:22 +0100
Message-Id: <1417183461-8210-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417183461-8210-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417183461-8210-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 5 -----
 include/linux/clk-provider.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9..d0712b7 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -574,11 +574,6 @@ unsigned int __clk_get_enable_count(struct clk *clk)
 	return !clk ? 0 : clk->enable_count;
 }
 
-unsigned int __clk_get_prepare_count(struct clk *clk)
-{
-	return !clk ? 0 : clk->prepare_count;
-}
-
 unsigned long __clk_get_rate(struct clk *clk)
 {
 	unsigned long ret;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 2839c63..fcf3252 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -544,7 +544,6 @@ u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
 struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
 unsigned int __clk_get_enable_count(struct clk *clk);
-unsigned int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_accuracy(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
-- 
1.9.3

