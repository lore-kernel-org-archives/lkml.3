Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBKRNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:13:53 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25372 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752121AbaBKRKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:49 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/12] GPIO: gpio-generic: Add label to platform data
Date: Tue, 11 Feb 2014 17:10:29 +0000
Message-Id: <1392138636-29240-6-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering more than one platform device, it is
useful to set the gpio chip label in the platform data.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
This patch has been already merged by Linux; it has been included
for completeness only.

 drivers/gpio/gpio-generic.c     | 2 ++
 include/linux/basic_mmio_gpio.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index d2196bf..8c778af 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -531,6 +531,8 @@ static int bgpio_pdev_probe(struct platform_device *pdev)
 		return err;
 
 	if (pdata) {
+		if (pdata->label)
+			bgc->gc.label = pdata->label;
 		bgc->gc.base = pdata->base;
 		if (pdata->ngpio > 0)
 			bgc->gc.ngpio = pdata->ngpio;
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index d8a97ec..0e97856 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -19,6 +19,7 @@
 #include <linux/spinlock_types.h>
 
 struct bgpio_pdata {
+	const char *label;
 	int base;
 	int ngpio;
 };
-- 
1.8.3.2

