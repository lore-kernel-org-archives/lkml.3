Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaHWOVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:21:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46384 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaHWOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:21:45 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/20] staging: rtl8188eu: Rename HalHWImg8188E_MAC.c to mac_cfg.c
Date: Sat, 23 Aug 2014 19:48:41 +0530
Message-Id: <1408803521-13715-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile                |    2 +-
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c |  133 ---------------------
 drivers/staging/rtl8188eu/hal/mac_cfg.c           |  133 +++++++++++++++++++++
 3 files changed, 134 insertions(+), 134 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
 create mode 100644 drivers/staging/rtl8188eu/hal/mac_cfg.c

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 412a056..20225b3 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -18,7 +18,7 @@ r8188eu-y :=				\
 		core/rtw_wlan_util.o	\
 		core/rtw_xmit.o		\
 		hal/fw.o	\
-		hal/HalHWImg8188E_MAC.o	\
+		hal/mac_cfg.o \
 		hal/bb_cfg.o \
 		hal/rf_cfg.o \
 		hal/HalPhyRf_8188e.o	\
diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
deleted file mode 100644
index 7d22dd1..0000000
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/******************************************************************************
-*
-* Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of version 2 of the GNU General Public License as
-* published by the Free Software Foundation.
-*
-* This program is distributed in the hope that it will be useful, but WITHOUT
-* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
-* more details.
-*
-* You should have received a copy of the GNU General Public License along with
-* this program; if not, write to the Free Software Foundation, Inc.,
-* 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
-*
-*
-******************************************************************************/
-
-#include "odm_precomp.h"
-#include <rtw_iol.h>
-
-/* MAC_REG.TXT */
-
-static u32 array_MAC_REG_8188E[] = {
-		0x026, 0x00000041,
-		0x027, 0x00000035,
-		0x428, 0x0000000A,
-		0x429, 0x00000010,
-		0x430, 0x00000000,
-		0x431, 0x00000001,
-		0x432, 0x00000002,
-		0x433, 0x00000004,
-		0x434, 0x00000005,
-		0x435, 0x00000006,
-		0x436, 0x00000007,
-		0x437, 0x00000008,
-		0x438, 0x00000000,
-		0x439, 0x00000000,
-		0x43A, 0x00000001,
-		0x43B, 0x00000002,
-		0x43C, 0x00000004,
-		0x43D, 0x00000005,
-		0x43E, 0x00000006,
-		0x43F, 0x00000007,
-		0x440, 0x0000005D,
-		0x441, 0x00000001,
-		0x442, 0x00000000,
-		0x444, 0x00000015,
-		0x445, 0x000000F0,
-		0x446, 0x0000000F,
-		0x447, 0x00000000,
-		0x458, 0x00000041,
-		0x459, 0x000000A8,
-		0x45A, 0x00000072,
-		0x45B, 0x000000B9,
-		0x460, 0x00000066,
-		0x461, 0x00000066,
-		0x480, 0x00000008,
-		0x4C8, 0x000000FF,
-		0x4C9, 0x00000008,
-		0x4CC, 0x000000FF,
-		0x4CD, 0x000000FF,
-		0x4CE, 0x00000001,
-		0x4D3, 0x00000001,
-		0x500, 0x00000026,
-		0x501, 0x000000A2,
-		0x502, 0x0000002F,
-		0x503, 0x00000000,
-		0x504, 0x00000028,
-		0x505, 0x000000A3,
-		0x506, 0x0000005E,
-		0x507, 0x00000000,
-		0x508, 0x0000002B,
-		0x509, 0x000000A4,
-		0x50A, 0x0000005E,
-		0x50B, 0x00000000,
-		0x50C, 0x0000004F,
-		0x50D, 0x000000A4,
-		0x50E, 0x00000000,
-		0x50F, 0x00000000,
-		0x512, 0x0000001C,
-		0x514, 0x0000000A,
-		0x516, 0x0000000A,
-		0x525, 0x0000004F,
-		0x550, 0x00000010,
-		0x551, 0x00000010,
-		0x559, 0x00000002,
-		0x55D, 0x000000FF,
-		0x605, 0x00000030,
-		0x608, 0x0000000E,
-		0x609, 0x0000002A,
-		0x620, 0x000000FF,
-		0x621, 0x000000FF,
-		0x622, 0x000000FF,
-		0x623, 0x000000FF,
-		0x624, 0x000000FF,
-		0x625, 0x000000FF,
-		0x626, 0x000000FF,
-		0x627, 0x000000FF,
-		0x652, 0x00000020,
-		0x63C, 0x0000000A,
-		0x63D, 0x0000000A,
-		0x63E, 0x0000000E,
-		0x63F, 0x0000000E,
-		0x640, 0x00000040,
-		0x66E, 0x00000005,
-		0x700, 0x00000021,
-		0x701, 0x00000043,
-		0x702, 0x00000065,
-		0x703, 0x00000087,
-		0x708, 0x00000021,
-		0x709, 0x00000043,
-		0x70A, 0x00000065,
-		0x70B, 0x00000087,
-};
-
-bool rtl88eu_phy_mac_config(struct adapter *adapt)
-{
-	u32 i;
-	u32 arraylength;
-	u32 *ptrarray;
-
-	arraylength = sizeof(array_MAC_REG_8188E)/sizeof(u32);
-	ptrarray = array_MAC_REG_8188E;
-
-	for (i = 0; i < arraylength; i = i + 2)
-		usb_write8(adapt, ptrarray[i], (u8) ptrarray[i + 1]);
-
-	usb_write8(adapt, REG_MAX_AGGR_NUM, MAX_AGGR_NUM);
-	return true;
-}
diff --git a/drivers/staging/rtl8188eu/hal/mac_cfg.c b/drivers/staging/rtl8188eu/hal/mac_cfg.c
new file mode 100644
index 0000000..7d22dd1
--- /dev/null
+++ b/drivers/staging/rtl8188eu/hal/mac_cfg.c
@@ -0,0 +1,133 @@
+/******************************************************************************
+*
+* Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of version 2 of the GNU General Public License as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful, but WITHOUT
+* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+* more details.
+*
+* You should have received a copy of the GNU General Public License along with
+* this program; if not, write to the Free Software Foundation, Inc.,
+* 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+*
+*
+******************************************************************************/
+
+#include "odm_precomp.h"
+#include <rtw_iol.h>
+
+/* MAC_REG.TXT */
+
+static u32 array_MAC_REG_8188E[] = {
+		0x026, 0x00000041,
+		0x027, 0x00000035,
+		0x428, 0x0000000A,
+		0x429, 0x00000010,
+		0x430, 0x00000000,
+		0x431, 0x00000001,
+		0x432, 0x00000002,
+		0x433, 0x00000004,
+		0x434, 0x00000005,
+		0x435, 0x00000006,
+		0x436, 0x00000007,
+		0x437, 0x00000008,
+		0x438, 0x00000000,
+		0x439, 0x00000000,
+		0x43A, 0x00000001,
+		0x43B, 0x00000002,
+		0x43C, 0x00000004,
+		0x43D, 0x00000005,
+		0x43E, 0x00000006,
+		0x43F, 0x00000007,
+		0x440, 0x0000005D,
+		0x441, 0x00000001,
+		0x442, 0x00000000,
+		0x444, 0x00000015,
+		0x445, 0x000000F0,
+		0x446, 0x0000000F,
+		0x447, 0x00000000,
+		0x458, 0x00000041,
+		0x459, 0x000000A8,
+		0x45A, 0x00000072,
+		0x45B, 0x000000B9,
+		0x460, 0x00000066,
+		0x461, 0x00000066,
+		0x480, 0x00000008,
+		0x4C8, 0x000000FF,
+		0x4C9, 0x00000008,
+		0x4CC, 0x000000FF,
+		0x4CD, 0x000000FF,
+		0x4CE, 0x00000001,
+		0x4D3, 0x00000001,
+		0x500, 0x00000026,
+		0x501, 0x000000A2,
+		0x502, 0x0000002F,
+		0x503, 0x00000000,
+		0x504, 0x00000028,
+		0x505, 0x000000A3,
+		0x506, 0x0000005E,
+		0x507, 0x00000000,
+		0x508, 0x0000002B,
+		0x509, 0x000000A4,
+		0x50A, 0x0000005E,
+		0x50B, 0x00000000,
+		0x50C, 0x0000004F,
+		0x50D, 0x000000A4,
+		0x50E, 0x00000000,
+		0x50F, 0x00000000,
+		0x512, 0x0000001C,
+		0x514, 0x0000000A,
+		0x516, 0x0000000A,
+		0x525, 0x0000004F,
+		0x550, 0x00000010,
+		0x551, 0x00000010,
+		0x559, 0x00000002,
+		0x55D, 0x000000FF,
+		0x605, 0x00000030,
+		0x608, 0x0000000E,
+		0x609, 0x0000002A,
+		0x620, 0x000000FF,
+		0x621, 0x000000FF,
+		0x622, 0x000000FF,
+		0x623, 0x000000FF,
+		0x624, 0x000000FF,
+		0x625, 0x000000FF,
+		0x626, 0x000000FF,
+		0x627, 0x000000FF,
+		0x652, 0x00000020,
+		0x63C, 0x0000000A,
+		0x63D, 0x0000000A,
+		0x63E, 0x0000000E,
+		0x63F, 0x0000000E,
+		0x640, 0x00000040,
+		0x66E, 0x00000005,
+		0x700, 0x00000021,
+		0x701, 0x00000043,
+		0x702, 0x00000065,
+		0x703, 0x00000087,
+		0x708, 0x00000021,
+		0x709, 0x00000043,
+		0x70A, 0x00000065,
+		0x70B, 0x00000087,
+};
+
+bool rtl88eu_phy_mac_config(struct adapter *adapt)
+{
+	u32 i;
+	u32 arraylength;
+	u32 *ptrarray;
+
+	arraylength = sizeof(array_MAC_REG_8188E)/sizeof(u32);
+	ptrarray = array_MAC_REG_8188E;
+
+	for (i = 0; i < arraylength; i = i + 2)
+		usb_write8(adapt, ptrarray[i], (u8) ptrarray[i + 1]);
+
+	usb_write8(adapt, REG_MAX_AGGR_NUM, MAX_AGGR_NUM);
+	return true;
+}
-- 
1.7.10.4

