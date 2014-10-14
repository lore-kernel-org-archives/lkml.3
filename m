Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaJNMZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:25:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37209 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaJNMZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:25:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-ff-543d16496c4e
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: max77693: Fix a truncate warning
Date: Tue, 14 Oct 2014 14:25:37 +0200
Message-id: <1413289537-10951-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4ZV1PMdsQg1NLmCxevzC0uP/1KKPF
	5V1z2CxOd7M6sHjcubaHzWPeyUCPvi2rGD0+b5ILYInisklJzcksSy3St0vgyrjYaFnwgL1i
	79xVLA2Mu9m6GDk5JARMJH7O2ssCYYtJXLi3HijOxSEksJRRomvZCbAEr4CgxI/J94BsDg5m
	AXmJI5eyQcLMAuoSk+YtYoao72OSuHxlPytIgk3AWGLz8iVgC0QEsiR+TFvNAtFgKPHz3R92
	EFtYwEzizPMZYDaLgKrEhl+NTCDzeQXcJR59FIK4R07i5LHJrBMY+WYhuWIWwhWzkFyxgJF5
	FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIAH7Zwbj4mNUhRgEORiUe3oJImxAh1sSy4src
	Q4wSHMxKIrwKHLYhQrwpiZVVqUX58UWlOanFhxiZODilGhh5vWe9XJHMunuT/4Rnor2dFy99
	WcmiJM70snFpxE0Hz/eGsux3jX71qE/f4HH5przlES71j3H7X5YtYIus/KKVFn5LouuYMkP+
	xZoHf0Vfbv29aGLc1909x+ZMSW4/9lZUnUXDicOHLY1Dz/Dm0bWPeWs7F3x4wrtj+bvNCjuW
	1KywF7tou7NBiaU4I9FQi7moOBEAj3MuJB4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning on x86_64, make allyesconfig:

drivers/mfd/max77693.c: In function ‘max77693_i2c_probe’:
drivers/mfd/max77693.c:259:5: warning: large integer implicitly truncated to unsigned type [-Woverflow]
     SRC_IRQ_ALL, ~SRC_IRQ_ALL);
     ^

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 4e4e6a1a6301..0c9ec6bae022 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -256,7 +256,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	/* Unmask interrupts from all blocks in interrupt source register */
 	ret = regmap_update_bits(max77693->regmap,
 				MAX77693_PMIC_REG_INTSRC_MASK,
-				SRC_IRQ_ALL, ~SRC_IRQ_ALL);
+				SRC_IRQ_ALL, (unsigned int)~SRC_IRQ_ALL);
 	if (ret < 0) {
 		dev_err(max77693->dev,
 			"Could not unmask interrupts in INTSRC: %d\n",
-- 
1.9.1

