Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbaFAMRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:17:55 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45912 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbaFAMRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:17:52 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/26] staging :rtl8188eu: Remove HalPhyRf.[h|c] files.
Date: Sun,  1 Jun 2014 17:46:28 +0530
Message-Id: <1401625013-11208-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ODM_GetRightChnlPlaceforIQK() from HalPhyRf.c to HalPhyRf_8188e.c.
Move ODM_TARGET_CHNL_NUM_2G_5G from HalPhyRf.h to HalPhyRf_8188e.h.
After the movement of function and macro HalPhyRf.[h|c] files are redundant.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile                 |    1 -
 drivers/staging/rtl8188eu/hal/HalPhyRf.c           |   41 --------------------
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   20 ++++++++++
 drivers/staging/rtl8188eu/include/HalPhyRf.h       |   28 -------------
 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h |    2 +-
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    1 -
 6 files changed, 21 insertions(+), 72 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalPhyRf.c
 delete mode 100644 drivers/staging/rtl8188eu/include/HalPhyRf.h

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 260c635..2ed35a0 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -25,7 +25,6 @@ r8188eu-y :=				\
 		hal/HalHWImg8188E_MAC.o	\
 		hal/HalHWImg8188E_BB.o	\
 		hal/HalHWImg8188E_RF.o	\
-		hal/HalPhyRf.o		\
 		hal/HalPhyRf_8188e.o	\
 		hal/HalPwrSeqCmd.o	\
 		hal/Hal8188EPwrSeq.o	\
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf.c b/drivers/staging/rtl8188eu/hal/HalPhyRf.c
deleted file mode 100644
index 5dd25e5..0000000
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf.c
+++ /dev/null
@@ -1,41 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-
- #include "odm_precomp.h"
-
-u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
-{
-	u8	channel_all[ODM_TARGET_CHNL_NUM_2G_5G] = {
-		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64,
-		100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122,
-		124, 126, 128, 130, 132, 134, 136, 138, 140, 149, 151, 153,
-		155, 157, 159, 161, 163, 165
-	};
-	u8	place = chnl;
-
-	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel_all); place++) {
-			if (channel_all[place] == chnl)
-				return place-13;
-		}
-	}
-	return 0;
-}
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 2bcb39f..fafb18c 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -27,6 +27,26 @@
 
 /*---------------------------Define Local Constant---------------------------*/
 
+u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
+{
+	u8	channel_all[ODM_TARGET_CHNL_NUM_2G_5G] = {
+		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
+		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64,
+		100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122,
+		124, 126, 128, 130, 132, 134, 136, 138, 140, 149, 151, 153,
+		155, 157, 159, 161, 163, 165
+	};
+	u8	place = chnl;
+
+	if (chnl > 14) {
+		for (place = 14; place < sizeof(channel_all); place++) {
+			if (channel_all[place] == chnl)
+				return place-13;
+		}
+	}
+	return 0;
+}
+
 /* 3============================================================ */
 /* 3 Tx Power Tracking */
 /* 3============================================================ */
diff --git a/drivers/staging/rtl8188eu/include/HalPhyRf.h b/drivers/staging/rtl8188eu/include/HalPhyRf.h
deleted file mode 100644
index 8ca6ce6..0000000
--- a/drivers/staging/rtl8188eu/include/HalPhyRf.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-
- #ifndef __HAL_PHY_RF_H__
- #define __HAL_PHY_RF_H__
-
-#define ODM_TARGET_CHNL_NUM_2G_5G	59
-
-u8 ODM_GetRightChnlPlaceforIQK(u8 chnl);
-
-#endif	/*  #ifndef __HAL_PHY_RF_H__ */
diff --git a/drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h b/drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h
index 287e9f9..90a26c1 100644
--- a/drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h
+++ b/drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h
@@ -25,7 +25,7 @@
 #define	IQK_DELAY_TIME_88E		10		/* ms */
 #define	index_mapping_NUM_88E	15
 #define AVG_THERMAL_NUM_88E	4
-
+#define ODM_TARGET_CHNL_NUM_2G_5G	59
 
 void ODM_TxPwrTrackAdjust88E(struct odm_dm_struct *pDM_Odm,
 			     u8 Type,	/* 0 = OFDM, 1 = CCK */
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 7cc2cc9..3839463 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -39,7 +39,6 @@
 #include "odm_RegDefine11AC.h"
 #include "odm_RegDefine11N.h"
 
-#include "HalPhyRf.h"
 #include "HalPhyRf_8188e.h"/* for IQK,LCK,Power-tracking */
 #include "Hal8188ERateAdaptive.h"/* for  RA,Power training */
 #include "rtl8188e_hal.h"
-- 
1.7.10.4

