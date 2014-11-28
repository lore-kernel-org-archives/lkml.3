Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaK1OGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:06:38 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42147 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaK1OFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:05:01 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        sboyd@codeaurora.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/7] clk: Don't expose __clk_get_accuracy
Date: Fri, 28 Nov 2014 15:03:24 +0100
Message-Id: <1417183461-8210-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417183461-8210-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417183461-8210-1-git-send-email-tomeu.vizoso@collabora.com>
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
index d2f0fb6..99cb0a1 100644
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

