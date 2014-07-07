Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaGGSlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:41:40 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43390 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGGSli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:41:38 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/13] staging: rtl8188eu: rtw_efuse.c : Remove unused functions
Date: Tue,  8 Jul 2014 00:10:05 +0530
Message-Id: <1404758413-12859-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c    |   49 -------------------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h |    2 -
 2 files changed, 51 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index ede7708..2189183 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -982,58 +982,9 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata)
 	}
 }
 
-static u8 efuse_read8(struct adapter *padapter, u16 address, u8 *value)
-{
-	return efuse_OneByteRead(padapter, address, value);
-}
-
-static u8 efuse_write8(struct adapter *padapter, u16 address, u8 *value)
-{
-	return efuse_OneByteWrite(padapter, address, *value);
-}
-
 /*
  * read/wirte raw efuse data
  */
-u8 rtw_efuse_access(struct adapter *padapter, u8 write, u16 start_addr, u16 cnts, u8 *data)
-{
-	int i = 0;
-	u16 real_content_len = 0, max_available_size = 0;
-	u8 res = _FAIL;
-	u8 (*rw8)(struct adapter *, u16, u8*);
-
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&real_content_len);
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
-
-	if (start_addr > real_content_len)
-		return _FAIL;
-
-	if (write) {
-		if ((start_addr + cnts) > max_available_size)
-			return _FAIL;
-		rw8 = &efuse_write8;
-	} else {
-		rw8 = &efuse_read8;
-	}
-
-	Efuse_PowerSwitch(padapter, write, true);
-
-	/*  e-fuse one byte read / write */
-	for (i = 0; i < cnts; i++) {
-		if (start_addr >= real_content_len) {
-			res = _FAIL;
-			break;
-		}
-
-		res = rw8(padapter, start_addr++, data++);
-		if (_FAIL == res)
-			break;
-	}
-
-	Efuse_PowerSwitch(padapter, write, false);
-
-	return res;
-}
 
 u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 86a1832..6d20fcc 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -99,8 +99,6 @@ struct efuse_hal {
 	u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN];
 };
 
-u8 rtw_efuse_access(struct adapter *adapter, u8 read, u16 start_addr,
-		    u16 cnts, u8 *data);
 u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u8 rtw_efuse_map_write(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u16 Efuse_GetCurrentSize(struct adapter *adapter);
-- 
1.7.10.4

