Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaJZUAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 16:00:55 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50739 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaJZUAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 16:00:53 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Subject: [PATCH] staging: rtl8723au: create macro get_max_rate
Date: Sun, 26 Oct 2014 20:00:48 +0000
Message-Id: <1414353648-6651-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create marco for max_rate values

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 75 ++++++++++++--------------
 1 file changed, 34 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 6274cb3..1592eaf 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -13,6 +13,8 @@
  *
  ******************************************************************************/
 #define _IEEE80211_C
+#define get_max_rate(r1, r2, r3, r4)					\
+	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))
 
 #include <drv_types.h>
 #include <linux/ieee80211.h>
@@ -794,65 +796,56 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
 
 	if (rf_type == RF_1T1R) {
 		if (mcs->rx_mask[0] & BIT(7))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
-				((short_GI_20)?722:650);
+			max_rate = get_max_rate(1500, 1350, 722, 650);
 		else if (mcs->rx_mask[0] & BIT(6))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):
-				((short_GI_20)?650:585);
+			max_rate = get_max_rate(1350, 1215, 650, 585);
 		else if (mcs->rx_mask[0] & BIT(5))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):
-				((short_GI_20)?578:520);
+			max_rate = get_max_rate(1200, 1080, 578, 520);
 		else if (mcs->rx_mask[0] & BIT(4))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):
-				((short_GI_20)?433:390);
+			max_rate = get_max_rate(900, 810, 433, 390);
 		else if (mcs->rx_mask[0] & BIT(3))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):
-				((short_GI_20)?289:260);
+			max_rate = get_max_rate(600, 540, 289, 260);
 		else if (mcs->rx_mask[0] & BIT(2))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):
-				((short_GI_20)?217:195);
+			max_rate = get_max_rate(450, 405, 217, 195);
 		else if (mcs->rx_mask[0] & BIT(1))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):
-				((short_GI_20)?144:130);
+			max_rate = get_max_rate(300, 270, 144, 130);
 		else if (mcs->rx_mask[0] & BIT(0))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):
-				((short_GI_20)?72:65);
+			max_rate = get_max_rate(150, 135, 72, 65);
 	} else {
 		if (mcs->rx_mask[1]) {
 			if (mcs->rx_mask[1] & BIT(7))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?3000:2700):((short_GI_20)?1444:1300);
+				max_rate = get_max_rate(3000, 2700, 1444, 1300);
 			else if (mcs->rx_mask[1] & BIT(6))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?2700:2430):((short_GI_20)?1300:1170);
+				max_rate = get_max_rate(2700, 2430, 1300, 1170);
 			else if (mcs->rx_mask[1] & BIT(5))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?2400:2160):((short_GI_20)?1156:1040);
+				max_rate = get_max_rate(2400, 2160, 1156, 1040);
 			else if (mcs->rx_mask[1] & BIT(4))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1800:1620):((short_GI_20)?867:780);
+				max_rate = get_max_rate(1800, 1620, 867, 780);
 			else if (mcs->rx_mask[1] & BIT(3))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):((short_GI_20)?578:520);
+				max_rate = get_max_rate(1200, 1080, 578, 520);
 			else if (mcs->rx_mask[1] & BIT(2))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):((short_GI_20)?433:390);
+				max_rate = get_max_rate(900, 810, 433, 390);
 			else if (mcs->rx_mask[1] & BIT(1))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):((short_GI_20)?289:260);
+				max_rate = get_max_rate(600, 540, 289, 260);
 			else if (mcs->rx_mask[1] & BIT(0))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):((short_GI_20)?144:130);
+				max_rate = get_max_rate(300, 270, 144, 130);
 		} else {
-			if (mcs->rx_mask[0] & BIT(7))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):((short_GI_20)?722:650);
-			else if (mcs->rx_mask[0] & BIT(6))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):((short_GI_20)?650:585);
-			else if (mcs->rx_mask[0] & BIT(5))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):((short_GI_20)?578:520);
-			else if (mcs->rx_mask[0] & BIT(4))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):((short_GI_20)?433:390);
-			else if (mcs->rx_mask[0] & BIT(3))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):((short_GI_20)?289:260);
-			else if (mcs->rx_mask[0] & BIT(2))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):((short_GI_20)?217:195);
-			else if (mcs->rx_mask[0] & BIT(1))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):((short_GI_20)?144:130);
-			else if (mcs->rx_mask[0] & BIT(0))
-				max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):((short_GI_20)?72:65);
-		}
+		if (mcs->rx_mask[0] & BIT(7))
+			max_rate = get_max_rate(1500, 1350, 722, 650);
+		else if (mcs->rx_mask[0] & BIT(6))
+			max_rate = get_max_rate(1350, 1215, 650, 585);
+		else if (mcs->rx_mask[0] & BIT(5))
+			max_rate = get_max_rate(1200, 1080, 578, 520);
+		else if (mcs->rx_mask[0] & BIT(4))
+			max_rate = get_max_rate(900, 810, 433, 390);
+		else if (mcs->rx_mask[0] & BIT(3))
+			max_rate = get_max_rate(600, 540, 289, 260);
+		else if (mcs->rx_mask[0] & BIT(2))
+			max_rate = get_max_rate(450, 405, 217, 195);
+		else if (mcs->rx_mask[0] & BIT(1))
+			max_rate = get_max_rate(300, 270, 144, 130);
+		else if (mcs->rx_mask[0] & BIT(0))
+			max_rate = get_max_rate(150, 135, 72, 65);
 	}
 	return max_rate;
 }
-- 
1.9.1

