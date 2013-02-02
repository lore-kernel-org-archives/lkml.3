Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3BBOmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:42:19 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63511 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3BBOmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:42:03 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dirk Opfer <dirk@opfer-online.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] arm: pxa: tosa: do not use gpiochip_reserve()
Date: Sat,  2 Feb 2013 23:44:05 +0900
Message-Id: <1359816246-3979-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
References: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO address space reservation during early platform initialization is
not needed anymore for Tosa. Remove the calls to gpiochip_reserve()
which is due to be removed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/mach-pxa/tosa.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 9e7998d..3d91d2e 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -927,8 +927,6 @@ static void tosa_restart(char mode, const char *cmd)
 
 static void __init tosa_init(void)
 {
-	int dummy;
-
 	pxa2xx_mfp_config(ARRAY_AND_SIZE(tosa_pin_config));
 
 	pxa_set_ffuart_info(NULL);
@@ -947,10 +945,6 @@ static void __init tosa_init(void)
 	/* enable batt_fault */
 	PMCR = 0x01;
 
-	dummy = gpiochip_reserve(TOSA_SCOOP_GPIO_BASE, 12);
-	dummy = gpiochip_reserve(TOSA_SCOOP_JC_GPIO_BASE, 12);
-	dummy = gpiochip_reserve(TOSA_TC6393XB_GPIO_BASE, 16);
-
 	pxa_set_mci_info(&tosa_mci_platform_data);
 	pxa_set_ficp_info(&tosa_ficp_platform_data);
 	pxa_set_i2c_info(NULL);
-- 
1.8.1.1

