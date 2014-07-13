Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaGMOaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:30:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42701 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaGMOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:30:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/16] staging: rtl8188eu: Remove unused function rtw_use_tkipkey_handler()
Date: Sun, 13 Jul 2014 19:59:23 +0530
Message-Id: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_security.c    |   25 ----------------------
 drivers/staging/rtl8188eu/include/rtw_security.h |    1 -
 2 files changed, 26 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_security.c b/drivers/staging/rtl8188eu/core/rtw_security.c
index d78def5..f9096a5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_security.c
+++ b/drivers/staging/rtl8188eu/core/rtw_security.c
@@ -1679,28 +1679,3 @@ do {									\
 	d##2 = TE0(s##2) ^ TE1(s##3) ^ TE2(s##0) ^ TE3(s##1) ^ rk[4 * i + 2]; \
 	d##3 = TE0(s##3) ^ TE1(s##0) ^ TE2(s##1) ^ TE3(s##2) ^ rk[4 * i + 3]; \
 } while (0);
-
-/**
- * omac1_aes_128 - One-Key CBC MAC (OMAC1) hash with AES-128 (aka AES-CMAC)
- * @key: 128-bit key for the hash operation
- * @data: Data buffer for which a MAC is determined
- * @data_len: Length of data buffer in bytes
- * @mac: Buffer for MAC (128 bits, i.e., 16 bytes)
- * Returns: 0 on success, -1 on failure
- *
- * This is a mode for using block cipher (AES in this case) for authentication.
- * OMAC1 was standardized with the name CMAC by NIST in a Special Publication
- * (SP) 800-38B.
- */
-void rtw_use_tkipkey_handler(void *FunctionContext)
-{
-	struct adapter *padapter = (struct adapter *)FunctionContext;
-
-
-	RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("^^^rtw_use_tkipkey_handler ^^^\n"));
-
-	padapter->securitypriv.busetkipkey = true;
-
-	RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("^^^rtw_use_tkipkey_handler padapter->securitypriv.busetkipkey=%d^^^\n", padapter->securitypriv.busetkipkey));
-
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_security.h b/drivers/staging/rtl8188eu/include/rtw_security.h
index 937cad8..66d60aa 100644
--- a/drivers/staging/rtl8188eu/include/rtw_security.h
+++ b/drivers/staging/rtl8188eu/include/rtw_security.h
@@ -378,6 +378,5 @@ void rtw_wep_encrypt(struct adapter *padapter, u8  *pxmitframe);
 u32 rtw_aes_decrypt(struct adapter *padapter, u8  *precvframe);
 u32 rtw_tkip_decrypt(struct adapter *padapter, u8  *precvframe);
 void rtw_wep_decrypt(struct adapter *padapter, u8  *precvframe);
-void rtw_use_tkipkey_handler(void *FunctionContext);
 
 #endif	/* __RTL871X_SECURITY_H_ */
-- 
1.7.10.4

