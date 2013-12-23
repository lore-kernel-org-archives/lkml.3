Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3LWQ3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:29:46 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39280 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab3LWQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:04 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [RFC 03/18] GPIO: gpio-generic: Add label to platform data
Date: Mon, 23 Dec 2013 16:23:35 +0000
Message-Id: <1387815830-8794-4-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:01.0447 (UTC) FILETIME=[63ACDB70:01CEFFFB]
X-MC-Unique: 113122316240300101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGU8MG026688

When registering more than one platform device, it is
useful to set the gpio chip label in the platform data.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>
---
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


