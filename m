Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaH1NOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:14:39 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:54134 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaH1NOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/11] mfd: htc-i2cpld: container_of() cannot return NULL
Date: Thu, 28 Aug 2014 14:14:10 +0100
Message-Id: <1409231657-18294-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logically dead code (DEADCODE)

dead_error_line: Execution cannot reach this statement: return;

Remove the check for NULL.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/htc-i2cpld.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index b44f020..8e3ea07 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -227,13 +227,10 @@ static irqreturn_t htcpld_handler(int irq, void *dev)
 static void htcpld_chip_set(struct gpio_chip *chip, unsigned offset, int val)
 {
 	struct i2c_client *client;
-	struct htcpld_chip *chip_data;
+	struct htcpld_chip *chip_data =
+		container_of(chip, struct htcpld_chip, chip_out);
 	unsigned long flags;
 
-	chip_data = container_of(chip, struct htcpld_chip, chip_out);
-	if (!chip_data)
-		return;
-
 	client = chip_data->client;
 	if (client == NULL)
 		return;
-- 
1.9.1

