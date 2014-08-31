Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaHaIkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:40:12 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63891 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHaIjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:39:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 7/9] staging: rtl8188eu: Remove file rtl8188e_rf.h
Date: Sun, 31 Aug 2014 14:08:27 +0530
Message-Id: <1409474309-24362-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move macros from rtl8188e_rf.h to rf.h and then remove rtl8188e_rf.h .

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c  |    1 +
 drivers/staging/rtl8188eu/include/rf.h           |    3 ++
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_rf.h  |   32 ----------------------
 4 files changed, 4 insertions(+), 33 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_rf.h

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 79a329d..6ae22b0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -20,6 +20,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <phy.h>
+#include <rf.h>
 #include <rtl8188e_hal.h>
 
 void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
diff --git a/drivers/staging/rtl8188eu/include/rf.h b/drivers/staging/rtl8188eu/include/rf.h
index 3b97ee3..98a5551 100644
--- a/drivers/staging/rtl8188eu/include/rf.h
+++ b/drivers/staging/rtl8188eu/include/rf.h
@@ -1,3 +1,6 @@
+#define RF6052_MAX_TX_PWR	0x3F
+#define RF6052_MAX_REG		0x3F
+
 void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
 				      enum ht_channel_width bandwidth);
 void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt,
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 814ba1a..f5abe01 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -25,7 +25,6 @@
 #include "rtl8188e_spec.h"
 #include "Hal8188EPhyReg.h"
 #include "Hal8188EPhyCfg.h"
-#include "rtl8188e_rf.h"
 #include "rtl8188e_dm.h"
 #include "rtl8188e_recv.h"
 #include "rtl8188e_xmit.h"
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
deleted file mode 100644
index 445f123..0000000
--- a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
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
-#ifndef __RTL8188E_RF_H__
-#define __RTL8188E_RF_H__
-
-#define		RF6052_MAX_TX_PWR		0x3F
-#define		RF6052_MAX_REG			0x3F
-#define		RF6052_MAX_PATH			2
-
-
-void rtl8188e_RF_ChangeTxPath(struct adapter *Adapter, u16 DataRate);
-void rtl8188e_PHY_RF6052SetBandwidth(struct adapter *Adapter,
-				     enum ht_channel_width Bandwidth);
-
-#endif/* __RTL8188E_RF_H__ */
-- 
1.7.10.4

