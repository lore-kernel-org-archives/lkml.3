Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3AVQ4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:56:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54122 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab3AVQw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:52:29 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 03/12] video: da8xx-fb: enable sync lost intr for v2 ip
Date: Tue, 22 Jan 2013 22:22:19 +0530
Message-ID: <25c3f28d978cca6396f8eab953a07a70383bb4d7.1358871750.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358871750.git.afzal@ti.com>
References: <cover.1358871750.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt handler is checking for sync lost interrupt, but it was not
enabled, enable it.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 7f92f37..ca69e01 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -318,7 +318,7 @@ static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
 			reg_int = lcdc_read(LCD_INT_ENABLE_SET_REG) |
 				LCD_V2_END_OF_FRAME0_INT_ENA |
 				LCD_V2_END_OF_FRAME1_INT_ENA |
-				LCD_FRAME_DONE;
+				LCD_FRAME_DONE | LCD_SYNC_LOST;
 			lcdc_write(reg_int, LCD_INT_ENABLE_SET_REG);
 		}
 		reg_dma |= LCD_DUAL_FRAME_BUFFER_ENABLE;
-- 
1.7.12

