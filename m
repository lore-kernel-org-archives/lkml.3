Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab3CNNNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:13:46 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46028 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3CNNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:12:12 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 08/10] drivers: mfd: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 14:11:29 +0100
Message-Id: <1363266691-15757-10-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/mfd/davinci_voicecodec.c | 12 +-----------
 drivers/mfd/htc-pasic3.c         | 13 +------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index c0bcc87..c60ab0c 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -177,17 +177,7 @@ static struct platform_driver davinci_vc_driver = {
 	.remove	= davinci_vc_remove,
 };
 
-static int __init davinci_vc_init(void)
-{
-	return platform_driver_probe(&davinci_vc_driver, davinci_vc_probe);
-}
-module_init(davinci_vc_init);
-
-static void __exit davinci_vc_exit(void)
-{
-	platform_driver_unregister(&davinci_vc_driver);
-}
-module_exit(davinci_vc_exit);
+module_platform_driver_probe(davinci_vc_driver, davinci_vc_probe);
 
 MODULE_AUTHOR("Miguel Aguilar");
 MODULE_DESCRIPTION("Texas Instruments DaVinci Voice Codec Core Interface");
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 9e5453d..0285fce 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -208,18 +208,7 @@ static struct platform_driver pasic3_driver = {
 	.remove		= pasic3_remove,
 };
 
-static int __init pasic3_base_init(void)
-{
-	return platform_driver_probe(&pasic3_driver, pasic3_probe);
-}
-
-static void __exit pasic3_base_exit(void)
-{
-	platform_driver_unregister(&pasic3_driver);
-}
-
-module_init(pasic3_base_init);
-module_exit(pasic3_base_exit);
+module_platform_driver_probe(pasic3_driver, pasic3_probe);
 
 MODULE_AUTHOR("Philipp Zabel <philipp.zabel@gmail.com>");
 MODULE_DESCRIPTION("Core driver for HTC PASIC3");
-- 
1.8.1.5

