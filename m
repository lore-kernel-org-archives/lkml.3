Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaFTPDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:16 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60500 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaFTPDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/41] staging: rtl8188eu: Remove function Efuse_Read1ByteFromFakeContent()
Date: Fri, 20 Jun 2014 20:29:27 +0530
Message-Id: <1403276387-11841-22-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Efuse_Read1ByteFromFakeContent() is never called because pseudo
is always false in Efuse_CalculateWordCnts() and efuse_OneByteRead().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index f6205c9..937ebce 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -47,20 +47,6 @@ u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN] = {0};
 #define EFUSE_CTRL			REG_EFUSE_CTRL		/*  E-Fuse Control. */
 /*  */
 
-static bool Efuse_Read1ByteFromFakeContent(
-			struct adapter *pAdapter,
-			u16 Offset,
-			u8 *Value)
-{
-	if (Offset >= EFUSE_MAX_HW_SIZE)
-		return false;
-	if (fakeEfuseBank == 0)
-		*Value = fakeEfuseContent[Offset];
-	else
-		*Value = fakeBTEfuseContent[fakeEfuseBank-1][Offset];
-	return true;
-}
-
 /*  11/16/2008 MH Add description. Get current efuse area enabled word!!. */
 u8
 Efuse_CalculateWordCnts(u8 word_en)
@@ -97,11 +83,6 @@ ReadEFuseByte(
 	u8 readbyte;
 	u16 retry;
 
-	if (pseudo) {
-		Efuse_Read1ByteFromFakeContent(Adapter, _offset, pbuf);
-		return;
-	}
-
 	/* Write Address */
 	usb_write8(Adapter, EFUSE_CTRL+1, (_offset & 0xff));
 	readbyte = usb_read8(Adapter, EFUSE_CTRL+2);
@@ -193,10 +174,6 @@ u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data, bool pseudo)
 	u8 tmpidx = 0;
 	u8 result;
 
-	if (pseudo) {
-		result = Efuse_Read1ByteFromFakeContent(pAdapter, addr, data);
-		return result;
-	}
 	/*  -----------------e-fuse reg ctrl --------------------------------- */
 	/* address */
 	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr & 0xff));
-- 
1.7.10.4

