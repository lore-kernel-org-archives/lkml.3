Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaJGPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:25:57 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62926 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaJGPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:22:46 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] clk: Remove unused function __clk_get_prepare_count
Date: Tue,  7 Oct 2014 17:21:47 +0200
Message-Id: <1412695334-2608-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c            | 5 -----
 include/linux/clk-provider.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bacc06f..c4b39ce 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -586,11 +586,6 @@ unsigned int __clk_get_enable_count(struct clk *clk)
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
index 411dd7e..94c491e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -512,7 +512,6 @@ u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
 struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
 unsigned int __clk_get_enable_count(struct clk *clk);
-unsigned int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_accuracy(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
-- 
1.9.3

