Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbaFTPEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:04:25 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33942 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbaFTPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 32/41] staging: rtl8188eu: EFUSE_ShadowMapUpdate():Remove unused parameter bool test
Date: Fri, 20 Jun 2014 20:29:38 +0530
Message-Id: <1403276387-11841-33-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    3 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    4 ++--
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index c7ea214..bfa6588 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -438,8 +438,7 @@ static void Efuse_ReadAllMap(struct adapter *pAdapter, u8 efuseType, u8 *Efuse)
  *---------------------------------------------------------------------------*/
 void EFUSE_ShadowMapUpdate(
 	struct adapter *pAdapter,
-	u8 efuseType,
-	bool pseudo)
+	u8 efuseType)
 {
 	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
 	u16 mapLen = 0;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 61bff1a..b895d36 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1629,13 +1629,13 @@ Hal_InitPGData88E(struct adapter *padapter)
 	if (!pEEPROM->bautoload_fail_flag) { /*  autoload OK. */
 		if (!is_boot_from_eeprom(padapter)) {
 			/*  Read EFUSE real map to shadow. */
-			EFUSE_ShadowMapUpdate(padapter, EFUSE_WIFI, false);
+			EFUSE_ShadowMapUpdate(padapter, EFUSE_WIFI);
 		}
 	} else {/* autoload fail */
 		RT_TRACE(_module_hci_hal_init_c_, _drv_notice_, ("AutoLoad Fail reported from CR9346!!\n"));
 		/* update to default value 0xFF */
 		if (!is_boot_from_eeprom(padapter))
-			EFUSE_ShadowMapUpdate(padapter, EFUSE_WIFI, false);
+			EFUSE_ShadowMapUpdate(padapter, EFUSE_WIFI);
 	}
 }
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 23a0168..1de6fa7 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -140,7 +140,7 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata);
 u8 Efuse_WordEnableDataWrite(struct adapter *adapter, u16 efuse_addr,
 			     u8 word_en, u8 *data, bool test);
 
-void EFUSE_ShadowMapUpdate(struct adapter *adapter, u8 efusetype, bool test);
+void EFUSE_ShadowMapUpdate(struct adapter *adapter, u8 efusetype);
 void EFUSE_ShadowRead(struct adapter *adapt, u8 type, u16 offset, u32 *val);
 
 #endif
-- 
1.7.10.4

