Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3GXUUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:20:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50403 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXUUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:20:51 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>
Subject: [PATCH] gpio_msm: Fix build error due to missing err.h
Date: Wed, 24 Jul 2013 13:20:48 -0700
Message-Id: <1374697248-23401-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpio/gpio-msm-v1.c: In function 'gpio_msm_v1_probe':
drivers/gpio/gpio-msm-v1.c:656:2:
error: implicit declaration of function 'IS_ERR'
[-Werror=implicit-function-declaration]
drivers/gpio/gpio-msm-v1.c:657:3:
error: implicit declaration of function 'PTR_ERR'
[-Werror=implicit-function-declaration]

This driver failed to compile after commit 68515bb
(gpio_msm: Convert to use devm_ioremap_resource,
2013-06-10).

Cc: Tushar Behera <tushar.behera@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/gpio/gpio-msm-v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index e3ceaac..73b7396 100644
--- a/drivers/gpio/gpio-msm-v1.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/err.h>
 
 #include <mach/msm_gpiomux.h>
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

