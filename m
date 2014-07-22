Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbaGVLPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:15:45 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34405 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbaGVLLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/19] mfd: wm8350-irq: Fix 'line over 80 chars' warning
Date: Tue, 22 Jul 2014 12:11:11 +0100
Message-Id: <1406027485-15657-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: line over 80 characters
+       wm8350->irq_base = irq_alloc_descs(irq_base, 0, ARRAY_SIZE(wm8350_irqs), 0);

total: 0 errors, 1 warnings, 552 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm8350-irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index cd01f79..813ff50 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -497,7 +497,8 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 	if (pdata && pdata->irq_base > 0)
 		irq_base = pdata->irq_base;
 
-	wm8350->irq_base = irq_alloc_descs(irq_base, 0, ARRAY_SIZE(wm8350_irqs), 0);
+	wm8350->irq_base =
+		irq_alloc_descs(irq_base, 0, ARRAY_SIZE(wm8350_irqs), 0);
 	if (wm8350->irq_base < 0) {
 		dev_warn(wm8350->dev, "Allocating irqs failed with %d\n",
 			wm8350->irq_base);
-- 
1.8.3.2

