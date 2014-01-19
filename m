Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaASFzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 00:55:16 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48421 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaASFzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 00:55:11 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: mturquette@linaro.org, gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] clk: export __clk_get_hw for re-use in others
Date: Sun, 19 Jan 2014 14:55:07 +0900
Message-Id: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following build comes while modprobe process:
> ERROR: "__clk_get_hw" [drivers/clk/clk-max77686.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2

Export the symbol to fix it and for other part's usecase.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/clk/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2b38dc9..3883fba 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -575,6 +575,7 @@ struct clk_hw *__clk_get_hw(struct clk *clk)
 {
 	return !clk ? NULL : clk->hw;
 }
+EXPORT_SYMBOL_GPL(__clk_get_hw);
 
 u8 __clk_get_num_parents(struct clk *clk)
 {
-- 
1.8.3.2

