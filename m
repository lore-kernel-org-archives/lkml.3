Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbbAOTFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:05:45 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37667 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbAOTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:05:42 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] fbdev: ssd1307fb: return proper error code if write command fails
Date: Thu, 15 Jan 2015 19:05:37 +0000
Message-Id: <1421348737-4606-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prabhakar Lad <prabhakar.csengg@gmail.com>

this patch fixes ssd1307fb_ssd1306_init() function to return
proper error codes in case of failures.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
 a: Added new line as per Maxime's suggestion.

 drivers/video/fbdev/ssd1307fb.c | 67 ++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index f4daa59..0ea6345 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -320,7 +320,10 @@ static int ssd1307fb_ssd1306_init(struct ssd1307fb_par *par)
 
 	/* Set initial contrast */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_CONTRAST);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x7f);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x7f);
 	if (ret < 0)
 		return ret;
 
@@ -336,63 +339,99 @@ static int ssd1307fb_ssd1306_init(struct ssd1307fb_par *par)
 
 	/* Set multiplex ratio value */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_MULTIPLEX_RATIO);
-	ret = ret & ssd1307fb_write_cmd(par->client, par->height - 1);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, par->height - 1);
 	if (ret < 0)
 		return ret;
 
 	/* set display offset value */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_DISPLAY_OFFSET);
+	if (ret < 0)
+		return ret;
+
 	ret = ssd1307fb_write_cmd(par->client, 0x20);
 	if (ret < 0)
 		return ret;
 
 	/* Set clock frequency */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_CLOCK_FREQ);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0xf0);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0xf0);
 	if (ret < 0)
 		return ret;
 
 	/* Set precharge period in number of ticks from the internal clock */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_PRECHARGE_PERIOD);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x22);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x22);
 	if (ret < 0)
 		return ret;
 
 	/* Set COM pins configuration */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_COM_PINS_CONFIG);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x22);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x22);
 	if (ret < 0)
 		return ret;
 
 	/* Set VCOMH */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_VCOMH);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x49);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x49);
 	if (ret < 0)
 		return ret;
 
 	/* Turn on the DC-DC Charge Pump */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_CHARGE_PUMP);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x14);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x14);
 	if (ret < 0)
 		return ret;
 
 	/* Switch to horizontal addressing mode */
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_ADDRESS_MODE);
-	ret = ret & ssd1307fb_write_cmd(par->client,
-					SSD1307FB_SET_ADDRESS_MODE_HORIZONTAL);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client,
+				  SSD1307FB_SET_ADDRESS_MODE_HORIZONTAL);
 	if (ret < 0)
 		return ret;
 
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_COL_RANGE);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x0);
-	ret = ret & ssd1307fb_write_cmd(par->client, par->width - 1);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x0);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, par->width - 1);
 	if (ret < 0)
 		return ret;
 
 	ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_PAGE_RANGE);
-	ret = ret & ssd1307fb_write_cmd(par->client, 0x0);
-	ret = ret & ssd1307fb_write_cmd(par->client,
-					par->page_offset + (par->height / 8) - 1);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client, 0x0);
+	if (ret < 0)
+		return ret;
+
+	ret = ssd1307fb_write_cmd(par->client,
+				  par->page_offset + (par->height / 8) - 1);
 	if (ret < 0)
 		return ret;
 
-- 
1.9.1

