Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaJSWcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:32:07 -0400
Received: from mx.culm.net ([79.188.239.84]:43172 "EHLO centaur.culm.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751544AbaJSWcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:32:04 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 18:32:04 EDT
From: Witold Krecicki <wpk+lkml@culm.net>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk+lkml@culm.net>
Subject: [PATCH 1/1] em28xx: add support for Leadtek VC100 USB capture device
Date: Mon, 20 Oct 2014 00:25:59 +0200
Message-Id: <1413757559-12268-1-git-send-email-wpk+lkml@culm.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leadtek VC100 is a simple USB capture stick, similar to
Yakumo Movie Mixer.

Signed-off-by: Witold Krecicki <wpk+lkml@culm.net>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 16 ++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 71fa51e..3c97bf1 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2243,6 +2243,20 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
+	[EM2861_BOARD_LEADTEK_VC100] = {
+		.name          = "Leadtek VC100",
+		.tuner_type    = TUNER_ABSENT,	/* Capture only device */
+		.decoder       = EM28XX_TVP5150,
+		.input         = { {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.vmux     = TVP5150_COMPOSITE1,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = TVP5150_SVIDEO,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		} },
+	},
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
@@ -2424,6 +2438,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_PCTV_461E },
 	{ USB_DEVICE(0x2013, 0x025f),
 			.driver_info = EM28178_BOARD_PCTV_292E },
+	{ USB_DEVICE(0x0413, 0x6f07),
+			.driver_info = EM2861_BOARD_LEADTEK_VC100 },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a21a746..05e7f7c 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -141,6 +141,7 @@
 #define EM28178_BOARD_PCTV_461E                   92
 #define EM2874_BOARD_KWORLD_UB435Q_V3		  93
 #define EM28178_BOARD_PCTV_292E                   94
+#define EM2861_BOARD_LEADTEK_VC100                95
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.9.1

