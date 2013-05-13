Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3EMVhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:37:34 -0400
Received: from mout.gmx.net ([212.227.15.19]:63082 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab3EMVh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:37:29 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/gry5d15ngh1tMHFNn19jstQq8u2Y5Nea6R+jT14
	uB31vRBTyFnh7o
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging/xgifb: Remove unnecessary binary calculation in GetXG27FPBits
Date: Mon, 13 May 2013 23:41:48 +0200
Message-Id: <1368481309-4883-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
References: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If temp <= 2 no other bits than the lowest two (0x03) can be set anyway
-> this operation can be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index ba8796f..090c424 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1177,9 +1177,7 @@ static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 	/* enable GPIOA/B/C read */
 	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03);
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
-	if (temp <= 2)
-		temp &= 0x03;
-	else
+	if (temp > 2)
 		temp = ((temp & 0x04) >> 1) | ((~temp) & 0x01);
 
 	xgifb_reg_set(pVBInfo->P3d4, 0x4A, CR4A);
-- 
1.8.1.5

