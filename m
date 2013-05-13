Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3EMVh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:37:28 -0400
Received: from mout.gmx.net ([212.227.17.22]:56454 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab3EMVhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:37:23 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19w5FQW5HBwBCEG9hBD7cCxg3it7qC4D0fML4MxKX
	97k3igX7o9p9so
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging/xgifb: Remove uneccessary/simply if in XGINew_GetXG20DRAMType
Date: Mon, 13 May 2013 23:41:45 +0200
Message-Id: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of storing the value in a temp variable, anding it with 1 and
assign data conditionally we can assign the value directly.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 19ce5a9..9caf12a 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -54,14 +54,12 @@ XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 		udelay(800);
 		xgifb_reg_or(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
 		/* GPIOF 0:DVI 1:DVO */
-		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
+		data = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 		/* HOTPLUG_SUPPORT */
 		/* for current XG20 & XG21, GPIOH is floating, driver will
 		 * fix DDR temporarily */
-		if (temp & 0x01) /* DVI read GPIOH */
-			data = 1; /* DDRII */
-		else
-			data = 0; /* DDR */
+		/* DVI read GPIOH */
+		data &= 0x01; /* 1=DDRII, 0=DDR */
 		/* ~HOTPLUG_SUPPORT */
 		xgifb_reg_or(pVBInfo->P3d4, 0xB4, 0x02);
 		return data;
-- 
1.8.1.5

