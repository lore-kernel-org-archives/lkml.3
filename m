Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaITO0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:26:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35983 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaITO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:26:20 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/13] staging: rtl8188eu: Remove odm_debug.c
Date: Sat, 20 Sep 2014 19:55:47 +0530
Message-Id: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a function and global variable from odm_debug.c to odm.c

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile        |    1 -
 drivers/staging/rtl8188eu/hal/odm.c       |    8 ++++++++
 drivers/staging/rtl8188eu/hal/odm_debug.c |   32 -----------------------------
 3 files changed, 8 insertions(+), 33 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/odm_debug.c

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 33cd34d..31ac159 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -27,7 +27,6 @@ r8188eu-y :=				\
 		hal/hal_intf.o		\
 		hal/hal_com.o		\
 		hal/odm.o		\
-		hal/odm_debug.o		\
 		hal/odm_HWConfig.o	\
 		hal/odm_RTL8188E.o	\
 		hal/rtl8188e_cmd.o	\
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 3a929bf..ae98379 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -23,6 +23,7 @@
 #include "odm_precomp.h"
 #include "phy.h"
 
+u32 GlobalDebugLevel;
 static const u16 dB_Invert_Table[8][12] = {
 	{1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4},
 	{4, 5, 6, 6, 7, 8, 9, 10, 11, 13, 14, 16},
@@ -172,6 +173,13 @@ u8 CCKSwingTable_Ch14[CCK_TABLE_SIZE][8] = {
 #define		RxDefaultAnt1		0x65a9
 #define	RxDefaultAnt2		0x569a
 
+void ODM_InitDebugSetting(struct odm_dm_struct *pDM_Odm)
+{
+	pDM_Odm->DebugLevel = ODM_DBG_TRACE;
+
+	pDM_Odm->DebugComponents = 0;
+}
+
 /* 3 Export Interface */
 
 /*  2011/09/21 MH Add to describe different team necessary resource allocate?? */
diff --git a/drivers/staging/rtl8188eu/hal/odm_debug.c b/drivers/staging/rtl8188eu/hal/odm_debug.c
deleted file mode 100644
index 84caadd..0000000
--- a/drivers/staging/rtl8188eu/hal/odm_debug.c
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
-
-/*  include files */
-
-#include "odm_precomp.h"
-
-void ODM_InitDebugSetting(struct odm_dm_struct *pDM_Odm)
-{
-	pDM_Odm->DebugLevel = ODM_DBG_TRACE;
-
-	pDM_Odm->DebugComponents = 0;
-}
-
-u32 GlobalDebugLevel;
-- 
1.7.10.4

