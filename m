Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaAFN0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:26:16 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64170 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAFN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:26:13 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/2] video: mxsfb: convert pr_debug()/dev_dbg() to pr_err()/dev_err() for error messages
Date: Mon,  6 Jan 2014 14:17:57 +0100
Message-Id: <1389014278-4903-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389014278-4903-1-git-send-email-LW@KARO-electronics.de>
References: <1389014278-4903-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the messages that are printed in case of fatal errors actually
visible to the user without having to recompile the driver with
debugging enabled.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/video/mxsfb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 27197a8..d11c35c 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -297,7 +297,7 @@ static int mxsfb_check_var(struct fb_var_screeninfo *var,
 		}
 		break;
 	default:
-		pr_debug("Unsupported colour depth: %u\n", var->bits_per_pixel);
+		pr_err("Unsupported colour depth: %u\n", var->bits_per_pixel);
 		return -EINVAL;
 	}
 
@@ -426,7 +426,7 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 		ctrl |= CTRL_SET_WORD_LENGTH(3);
 		switch (host->ld_intf_width) {
 		case STMLCDIF_8BIT:
-			dev_dbg(&host->pdev->dev,
+			dev_err(&host->pdev->dev,
 					"Unsupported LCD bus width mapping\n");
 			return -EINVAL;
 		case STMLCDIF_16BIT:
@@ -439,7 +439,7 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 		writel(CTRL1_SET_BYTE_PACKAGING(0x7), host->base + LCDC_CTRL1);
 		break;
 	default:
-		dev_dbg(&host->pdev->dev, "Unhandled color depth of %u\n",
+		dev_err(&host->pdev->dev, "Unhandled color depth of %u\n",
 				fb_info->var.bits_per_pixel);
 		return -EINVAL;
 	}
-- 
1.7.2.5

