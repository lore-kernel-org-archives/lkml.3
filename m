Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3BCVvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:38 -0500
Received: from mout.gmx.net ([212.227.17.20]:61167 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3BCVve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:34 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19VDrYKExBVPprT/q7OguHk6/GOZf08mVrv83Ru0+
	sjZQrMUvV/YE3t
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] staging/xgifb: rewrite XGIfb_get_cmap_len
Date: Sun,  3 Feb 2013 22:54:35 +0100
Message-Id: <1359928479-8484-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to use this switch-case here for a simple two case
if-else.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 106abc8..840b497 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1131,22 +1131,10 @@ static int XGIfb_release(struct fb_info *info, int user)
 	return 0;
 }
 
+/* similar to sisfb_get_cmap_len */
 static int XGIfb_get_cmap_len(const struct fb_var_screeninfo *var)
 {
-	int rc = 16;
-
-	switch (var->bits_per_pixel) {
-	case 8:
-		rc = 256;
-		break;
-	case 16:
-		rc = 16;
-		break;
-	case 32:
-		rc = 16;
-		break;
-	}
-	return rc;
+	return (var->bits_per_pixel == 8) ? 256 : 16;
 }
 
 static int XGIfb_setcolreg(unsigned regno, unsigned red, unsigned green,
-- 
1.7.8.6

