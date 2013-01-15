Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3AONlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:41:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59975 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab3AONlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:41:06 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sekhar Nori <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v2 02/12] video: da8xx-fb: fix 24bpp raster configuration
Date: Tue, 15 Jan 2013 19:11:59 +0530
Message-ID: <dcc13ae0bf67edc805f74e63226b50af98818189.1358251447.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358251447.git.afzal@ti.com>
References: <cover.1358251447.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Manjunathappa, Prakash" <prakash.pm@ti.com>

Set only LCD_V2_TFT_24BPP_MODE bit for 24bpp and LCD_V2_TFT_24BPP_UNPACK
bit along with LCD_V2_TFT_24BPP_MODE for 32bpp configuration.

Patch is tested on am335x-evm for 24bpp and da850-evm for 16bpp
configurations.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 35a33ca..7f92f37 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -550,10 +550,10 @@ static int lcd_cfg_frame_buffer(struct da8xx_fb_par *par, u32 width, u32 height,
 	case 4:
 	case 16:
 		break;
-	case 24:
-		reg |= LCD_V2_TFT_24BPP_MODE;
 	case 32:
 		reg |= LCD_V2_TFT_24BPP_UNPACK;
+	case 24:
+		reg |= LCD_V2_TFT_24BPP_MODE;
 		break;
 
 	case 8:
-- 
1.7.9.5

