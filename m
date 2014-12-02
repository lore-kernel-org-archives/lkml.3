Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaLBH4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:56:10 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:60260 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbaLBH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:56:06 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v7 3/7] clk: Don't expose __clk_get_accuracy
Date: Tue,  2 Dec 2014 08:54:20 +0100
Message-Id: <1417506933-8915-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it's only used internally, in drivers/clk/clk.c.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 2 +-
 include/linux/clk-provider.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 609e9db..73247e9 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -596,7 +596,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_get_rate);
 
-unsigned long __clk_get_accuracy(struct clk *clk)
+static unsigned long __clk_get_accuracy(struct clk *clk)
 {
 	if (!clk)
 		return 0;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index fcf3252..270137a 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -545,7 +545,6 @@ struct clk *__clk_get_parent(struct clk *clk);
 struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
 unsigned int __clk_get_enable_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
-unsigned long __clk_get_accuracy(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
 bool __clk_is_prepared(struct clk *clk);
 bool __clk_is_enabled(struct clk *clk);
-- 
1.9.3

