Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaFJS70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:59:26 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57912 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFJS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:59:24 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH] of/platform: Fix microblaze build failure
Date: Tue, 10 Jun 2014 11:59:14 -0700
Message-Id: <1402426754-7328-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bf5db2f (microblaze: Use generic device.h) removes the
microblaze specific pdev_archdata and dma_mask.

At the same time, commit 591c1ee (of: configure the platform
device dma parameters) initializes the just removed field.
This causes all microblaze builds to fail.

Drop the unnecessary initialization.

Cc: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/of/platform.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 6c48d73..500436f 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -166,10 +166,6 @@ static void of_dma_configure(struct platform_device *pdev)
 	int ret;
 	struct device *dev = &pdev->dev;
 
-#if defined(CONFIG_MICROBLAZE)
-	pdev->archdata.dma_mask = 0xffffffffUL;
-#endif
-
 	/*
 	 * Set default dma-mask to 32 bit. Drivers are expected to setup
 	 * the correct supported dma_mask.
-- 
1.9.1

