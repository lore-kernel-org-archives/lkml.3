Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaGBQt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:49:27 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34052 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaGBQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/48] staging: rtl8188eu: Remove unused function c2h_evt_clear()
Date: Wed,  2 Jul 2014 22:17:00 +0530
Message-Id: <1404319664-8327-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_com.c     |   11 -----------
 drivers/staging/rtl8188eu/include/hal_com.h |    2 --
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_com.c b/drivers/staging/rtl8188eu/hal/hal_com.c
index c91a58c..170e3de 100644
--- a/drivers/staging/rtl8188eu/hal/hal_com.c
+++ b/drivers/staging/rtl8188eu/hal/hal_com.c
@@ -319,14 +319,3 @@ void hal_init_macaddr(struct adapter *adapter)
 	rtw_hal_set_hwreg(adapter, HW_VAR_MAC_ADDR,
 			  adapter->eeprompriv.mac_addr);
 }
-
-/*
-* C2H event format:
-* Field	 TRIGGER		CONTENT	   CMD_SEQ	CMD_LEN		 CMD_ID
-* BITS	 [127:120]	[119:16]      [15:8]		  [7:4]		   [3:0]
-*/
-
-void c2h_evt_clear(struct adapter *adapter)
-{
-	usb_write8(adapter, REG_C2HEVT_CLEAR, C2H_EVT_HOST_CLOSE);
-}
diff --git a/drivers/staging/rtl8188eu/include/hal_com.h b/drivers/staging/rtl8188eu/include/hal_com.h
index 1527efa..47715d9 100644
--- a/drivers/staging/rtl8188eu/include/hal_com.h
+++ b/drivers/staging/rtl8188eu/include/hal_com.h
@@ -166,6 +166,4 @@ void HalSetBrateCfg(struct adapter *Adapter, u8 *mBratesOS, u16 *pBrateCfg);
 bool Hal_MappingOutPipe(struct adapter *pAdapter, u8 NumOutPipe);
 
 void hal_init_macaddr(struct adapter *adapter);
-
-void c2h_evt_clear(struct adapter *adapter);
 #endif /* __HAL_COMMON_H__ */
-- 
1.7.10.4

