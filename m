Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbaLBIBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:01:37 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59925 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780AbaLBH4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:56:01 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v7 1/7] clk: Remove unused function __clk_get_prepare_count
Date: Tue,  2 Dec 2014 08:54:18 +0100
Message-Id: <1417506933-8915-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
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
index 5307225..42f940f 100644
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

