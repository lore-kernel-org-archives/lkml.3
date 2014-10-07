Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaJGPYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:24:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54645 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaJGPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:22:51 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] clk: Don't expose __clk_get_accuracy
Date: Tue,  7 Oct 2014 17:21:49 +0200
Message-Id: <1412695334-2608-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it's only used internally, in drivers/clk/clk.c.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c            | 2 +-
 include/linux/clk-provider.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 55d2368..1dcd81a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -608,7 +608,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_get_rate);
 
-unsigned long __clk_get_accuracy(struct clk *clk)
+static unsigned long __clk_get_accuracy(struct clk *clk)
 {
 	if (!clk)
 		return 0;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 94c491e..eef1778 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -513,7 +513,6 @@ struct clk *__clk_get_parent(struct clk *clk);
 struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
 unsigned int __clk_get_enable_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
-unsigned long __clk_get_accuracy(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
 bool __clk_is_prepared(struct clk *clk);
 bool __clk_is_enabled(struct clk *clk);
-- 
1.9.3

