Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbaFTPDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:09 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53605 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709AbaFTPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/41] staging: rtl8188eu: Remove function Efuse_Write1ByteToFakeContent()
Date: Fri, 20 Jun 2014 20:29:26 +0530
Message-Id: <1403276387-11841-21-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Efuse_Write1ByteToFakeContent() is used only in efuse_OneByteWrite(),
when pseudo is true, but pseudo is always false.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index de211a7..f6205c9 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -61,21 +61,6 @@ static bool Efuse_Read1ByteFromFakeContent(
 	return true;
 }
 
-static bool
-Efuse_Write1ByteToFakeContent(
-			struct adapter *pAdapter,
-			u16 Offset,
-			u8 Value)
-{
-	if (Offset >= EFUSE_MAX_HW_SIZE)
-		return false;
-	if (fakeEfuseBank == 0)
-		fakeEfuseContent[Offset] = Value;
-	else
-		fakeBTEfuseContent[fakeEfuseBank-1][Offset] = Value;
-	return true;
-}
-
 /*  11/16/2008 MH Add description. Get current efuse area enabled word!!. */
 u8
 Efuse_CalculateWordCnts(u8 word_en)
@@ -238,11 +223,6 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
 	u8 tmpidx = 0;
 	u8 result;
 
-	if (pseudo) {
-		result = Efuse_Write1ByteToFakeContent(pAdapter, addr, data);
-		return result;
-	}
-
 	/*  -----------------e-fuse reg ctrl --------------------------------- */
 	/* address */
 	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr&0xff));
-- 
1.7.10.4

