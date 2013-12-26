Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3LZKXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:23:14 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54024 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3LZKWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:22:39 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, lee.jones@linaro.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH RESEND 2/4] clk: clk-s2mps11: Add support for clocks in S5M8767 MFD
Date: Thu, 26 Dec 2013 15:48:59 +0530
Message-Id: <1388053141-30085-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388053141-30085-1-git-send-email-tushar.behera@linaro.org>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since clock operation within S2MPS11 and S5M8767 are similar, we can
support both the devices within a single driver.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Kconfig       |    6 ++++--
 drivers/clk/clk-s2mps11.c |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 3089f05..87e6c56 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -75,10 +75,12 @@ config COMMON_CLK_SI570
 	  clock generators.
 
 config COMMON_CLK_S2MPS11
-	tristate "Clock driver for S2MPS11 MFD"
+	tristate "Clock driver for S2MPS11/S5M8767 MFD"
 	depends on MFD_SEC_CORE
 	---help---
-	  This driver supports S2MPS11 crystal oscillator clock.
+	  This driver supports S2MPS11/S5M8767 crystal oscillator clock. These
+	  multi-function devices have 3 fixed-rate oscillators, clocked at
+	  32KHz each.
 
 config CLK_TWL6040
 	tristate "External McPDM functional clock from twl6040"
diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 43e25bb..f4c1f08 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -27,6 +27,7 @@
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s5m8767.h>
 #include <linux/mfd/samsung/core.h>
 
 #define s2mps11_name(a) (a->hw.init->name)
@@ -175,6 +176,9 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	case S2MPS11X:
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
 		break;
+	case S5M8767X:
+		s2mps11_reg = S5M8767_REG_CTRL1;
+		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device type\n");
 		return -EINVAL;
@@ -254,6 +258,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 
 static const struct platform_device_id s2mps11_clk_id[] = {
 	{ "s2mps11-clk", S2MPS11X},
+	{ "s5m8767-clk", S5M8767X},
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, s2mps11_clk_id);
-- 
1.7.9.5

