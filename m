Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3CNNMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:12:53 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:44853 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869Ab3CNNMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:12:15 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 09/10] drivers: video: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 14:11:30 +0100
Message-Id: <1363266691-15757-11-git-send-email-fabio.porcedda@gmail.com>
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
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/backlight/atmel-pwm-bl.c | 12 +-----------
 drivers/video/sh_mipi_dsi.c            | 12 +-----------
 drivers/video/sh_mobile_hdmi.c         | 12 +-----------
 3 files changed, 3 insertions(+), 33 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index de5e5e7..20b330d 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -225,17 +225,7 @@ static struct platform_driver atmel_pwm_bl_driver = {
 	.remove = __exit_p(atmel_pwm_bl_remove),
 };
 
-static int __init atmel_pwm_bl_init(void)
-{
-	return platform_driver_probe(&atmel_pwm_bl_driver, atmel_pwm_bl_probe);
-}
-module_init(atmel_pwm_bl_init);
-
-static void __exit atmel_pwm_bl_exit(void)
-{
-	platform_driver_unregister(&atmel_pwm_bl_driver);
-}
-module_exit(atmel_pwm_bl_exit);
+module_platform_driver_probe(atmel_pwm_bl_driver, atmel_pwm_bl_probe);
 
 MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Atmel PWM backlight driver");
diff --git a/drivers/video/sh_mipi_dsi.c b/drivers/video/sh_mipi_dsi.c
index 701b461..6cad530 100644
--- a/drivers/video/sh_mipi_dsi.c
+++ b/drivers/video/sh_mipi_dsi.c
@@ -581,17 +581,7 @@ static struct platform_driver sh_mipi_driver = {
 	},
 };
 
-static int __init sh_mipi_init(void)
-{
-	return platform_driver_probe(&sh_mipi_driver, sh_mipi_probe);
-}
-module_init(sh_mipi_init);
-
-static void __exit sh_mipi_exit(void)
-{
-	platform_driver_unregister(&sh_mipi_driver);
-}
-module_exit(sh_mipi_exit);
+module_platform_driver_probe(sh_mipi_driver, sh_mipi_probe);
 
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
 MODULE_DESCRIPTION("SuperH / ARM-shmobile MIPI DSI driver");
diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
index 930e550..bfe4728 100644
--- a/drivers/video/sh_mobile_hdmi.c
+++ b/drivers/video/sh_mobile_hdmi.c
@@ -1445,17 +1445,7 @@ static struct platform_driver sh_hdmi_driver = {
 	},
 };
 
-static int __init sh_hdmi_init(void)
-{
-	return platform_driver_probe(&sh_hdmi_driver, sh_hdmi_probe);
-}
-module_init(sh_hdmi_init);
-
-static void __exit sh_hdmi_exit(void)
-{
-	platform_driver_unregister(&sh_hdmi_driver);
-}
-module_exit(sh_hdmi_exit);
+module_platform_driver_probe(sh_hdmi_driver, sh_hdmi_probe);
 
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
 MODULE_DESCRIPTION("SuperH / ARM-shmobile HDMI driver");
-- 
1.8.1.5

