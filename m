Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHJOqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:46:20 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57696 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaHJOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:46:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/22] staging: rtl8188eu: Remove odm_RegConfig8188E.[h,c] files
Date: Sun, 10 Aug 2014 20:14:21 +0530
Message-Id: <1407681875-2611-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver doesn't require these files anymore.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile                 |    1 -
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |   86 --------------------
 .../staging/rtl8188eu/include/odm_RegConfig8188E.h |   32 --------
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    1 -
 4 files changed, 120 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
 delete mode 100644 drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 32d64a7..1b8c89b 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -30,7 +30,6 @@ r8188eu-y :=				\
 		hal/odm.o		\
 		hal/odm_debug.o		\
 		hal/odm_HWConfig.o	\
-		hal/odm_RegConfig8188E.o\
 		hal/odm_RTL8188E.o	\
 		hal/rtl8188e_cmd.o	\
 		hal/rtl8188e_dm.o	\
diff --git a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
deleted file mode 100644
index 634d111..0000000
--- a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
+++ /dev/null
@@ -1,86 +0,0 @@
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
-#include "odm_precomp.h"
-
-void odm_ConfigBB_AGC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Bitmask, u32 Data)
-{
-	struct adapter *adapter = pDM_Odm->Adapter;
-
-	PHY_SetBBReg(adapter, Addr, Bitmask, Data);
-	/*  Add 1us delay between BB/RF register setting. */
-	udelay(1);
-
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_TRACE,
-		     ("===> ODM_ConfigBBWithHeaderFile: [AGC_TAB] %08X %08X\n",
-		     Addr, Data));
-}
-
-void odm_ConfigBB_PHY_REG_PG_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-				   u32 Bitmask, u32 Data)
-{
-	if (Addr == 0xfe) {
-		msleep(50);
-	} else if (Addr == 0xfd) {
-		mdelay(5);
-	} else if (Addr == 0xfc) {
-		mdelay(1);
-	} else if (Addr == 0xfb) {
-		udelay(50);
-	} else if (Addr == 0xfa) {
-		udelay(5);
-	} else if (Addr == 0xf9) {
-		udelay(1);
-	} else{
-		ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_LOUD,
-			     ("===> @@@@@@@ ODM_ConfigBBWithHeaderFile: [PHY_REG] %08X %08X %08X\n",
-			     Addr, Bitmask, Data));
-		storePwrIndexDiffRateOffset(pDM_Odm->Adapter, Addr, Bitmask, Data);
-	}
-}
-
-void odm_ConfigBB_PHY_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Bitmask, u32 Data)
-{
-	struct adapter *adapter = pDM_Odm->Adapter;
-
-	if (Addr == 0xfe) {
-		msleep(50);
-	} else if (Addr == 0xfd) {
-		mdelay(5);
-	} else if (Addr == 0xfc) {
-		mdelay(1);
-	} else if (Addr == 0xfb) {
-		udelay(50);
-	} else if (Addr == 0xfa) {
-		udelay(5);
-	} else if (Addr == 0xf9) {
-		udelay(1);
-	} else {
-		if (Addr == 0xa24)
-			pDM_Odm->RFCalibrateInfo.RegA24 = Data;
-		PHY_SetBBReg(adapter, Addr, Bitmask, Data);
-
-		/*  Add 1us delay between BB/RF register setting. */
-		udelay(1);
-		ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_TRACE,
-			     ("===> ODM_ConfigBBWithHeaderFile: [PHY_REG] %08X %08X\n",
-			     Addr, Data));
-	}
-}
diff --git a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
deleted file mode 100644
index dd49a86..0000000
--- a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
+++ /dev/null
@@ -1,32 +0,0 @@
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
-#ifndef __INC_ODM_REGCONFIG_H_8188E
-#define __INC_ODM_REGCONFIG_H_8188E
-
-void odm_ConfigBB_AGC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-			    u32 Bitmask, u32 Data);
-
-void odm_ConfigBB_PHY_REG_PG_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-				   u32 Bitmask, u32 Data);
-
-void odm_ConfigBB_PHY_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-			    u32 Bitmask, u32 Data);
-
-#endif
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 683c5bd..436d6ff 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -46,7 +46,6 @@
 
 #include "odm_reg.h"
 
-#include "odm_RegConfig8188E.h"
 #include "odm_RTL8188E.h"
 
 void odm_CmnInfoHook_Debug(struct odm_dm_struct *pDM_Odm);
-- 
1.7.10.4

