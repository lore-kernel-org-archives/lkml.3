Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaH1NQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:16:32 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:51744 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaH1NOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/11] mfd: htc-i2cpld: Use '!variable' instead of 'variable == NULL'
Date: Thu, 28 Aug 2014 14:14:11 +0100
Message-Id: <1409231657-18294-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This aids in consistency, as the rest of the checks in the file use this
notation.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/htc-i2cpld.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index 8e3ea07..073e180 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -232,7 +232,7 @@ static void htcpld_chip_set(struct gpio_chip *chip, unsigned offset, int val)
 	unsigned long flags;
 
 	client = chip_data->client;
-	if (client == NULL)
+	if (!client)
 		return;
 
 	spin_lock_irqsave(&chip_data->lock, flags);
@@ -373,7 +373,7 @@ static int htcpld_register_chip_i2c(
 	plat_chip_data = &pdata->chip[chip_index];
 
 	adapter = i2c_get_adapter(pdata->i2c_adapter_id);
-	if (adapter == NULL) {
+	if (!adapter) {
 		/* Eek, no such I2C adapter!  Bail out. */
 		dev_warn(dev, "Chip at i2c address 0x%x: Invalid i2c adapter %d\n",
 			 plat_chip_data->addr, pdata->i2c_adapter_id);
-- 
1.9.1

