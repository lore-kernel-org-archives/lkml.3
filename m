Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbaGBV4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:56:16 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53875 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGBV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:56:00 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sh_mipi_dsi.c:  Cleaning up Boolean used in bitwise operation
Date: Wed,  2 Jul 2014 23:57:12 +0200
Message-Id: <1404338232-6708-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404338232-6708-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404338232-6708-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boolean variable is used in bitwise operation.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/sh_mipi_dsi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sh_mipi_dsi.c b/drivers/video/fbdev/sh_mipi_dsi.c
index 8f6e8ff..39417ab 100644
--- a/drivers/video/fbdev/sh_mipi_dsi.c
+++ b/drivers/video/fbdev/sh_mipi_dsi.c
@@ -113,11 +113,18 @@ static int sh_mipi_dcs_param(int handle, u8 cmd, u8 param)
 
 static void sh_mipi_dsi_enable(struct sh_mipi *mipi, bool enable)
 {
+	unsigned int enable_value;
+
+	if (enable)
+		enable_value = 0x00000003;
+	else
+		enable_value = 0x00000002;
+
 	/*
 	 * enable LCDC data tx, transition to LPS after completion of each HS
 	 * packet
 	 */
-	iowrite32(0x00000002 | enable, mipi->linkbase + DTCTR);
+	iowrite32(enable_value, mipi->linkbase + DTCTR);
 }
 
 static void sh_mipi_shutdown(struct platform_device *pdev)
-- 
1.7.10.4

