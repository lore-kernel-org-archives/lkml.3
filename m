Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaERP0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:26:31 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63727 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaERP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:26:29 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 24/28] staging: rtl8188eu: Remove unused function ConvertTo_dB()
Date: Sun, 18 May 2014 20:49:17 +0530
Message-Id: <1400426361-19596-25-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 4442181..425c50a4 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1394,28 +1394,3 @@ dm_CheckEdcaTurbo_EXIT:
 	pxmitpriv->last_tx_bytes = pxmitpriv->tx_bytes;
 	precvpriv->last_rx_bytes = precvpriv->rx_bytes;
 }
-
-u32 ConvertTo_dB(u32 Value)
-{
-	u8 i;
-	u8 j;
-	u32 dB;
-
-	Value = Value & 0xFFFF;
-	for (i = 0; i < 8; i++) {
-		if (Value <= dB_Invert_Table[i][11])
-			break;
-	}
-
-	if (i >= 8)
-		return 96;	/*  maximum 96 dB */
-
-	for (j = 0; j < 12; j++) {
-		if (Value <= dB_Invert_Table[i][j])
-			break;
-	}
-
-	dB = i*12 + j + 1;
-
-	return dB;
-}
-- 
1.7.10.4

