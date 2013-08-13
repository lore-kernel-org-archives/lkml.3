Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3HMQlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:41:19 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38788 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab3HMQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:41:02 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH] mfd: ti_am335x_tscadc: Update reg_cache variable in clr function
Date: Tue, 13 Aug 2013 17:40:56 +0100
Message-Id: <1376412056-20736-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376412056-20736-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1376412056-20736-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reg_cache variable should be updated with current
steps in the reg_se register. Then the mask should
apply and clear the register. Previously, the reg_cache
can be an old redundant value that isn't updated.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/mfd/ti_am335x_tscadc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 9f3f07a..baaf5a8 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -67,10 +67,10 @@ EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	spin_lock(&tsadc->reg_lock);
+	tsadc->reg_se_cache = tscadc_readl(tsadc, REG_SE);
 	tsadc->reg_se_cache &= ~val;
-	spin_unlock(&tsadc->reg_lock);
-
 	am335x_tsc_se_update(tsadc);
+	spin_unlock(&tsadc->reg_lock);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_clr);
 
-- 
1.7.9.5

