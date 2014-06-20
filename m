Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaFTPDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:42 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42297 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaFTPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:38 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 25/41] staging: rtl8188eu: Remove unused function ReadEFuseByte()
Date: Fri, 20 Jun 2014 20:29:31 +0530
Message-Id: <1403276387-11841-26-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c    |   47 -------------------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h |    1 -
 2 files changed, 48 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 7e126ce..16377f6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -63,53 +63,6 @@ Efuse_CalculateWordCnts(u8 word_en)
 	return word_cnts;
 }
 
-/*
- * Description:
- * Execute E-Fuse read byte operation.
- * Referred from SD1 Richard.
- * Assumption:
- *		1. Boot from E-Fuse and successfully auto-load.
- *		2. PASSIVE_LEVEL (USB interface)
- * Created by Roger, 2008.10.21.
- */
-void
-ReadEFuseByte(
-		struct adapter *Adapter,
-		u16 _offset,
-		u8 *pbuf,
-		bool pseudo)
-{
-	u32 value32;
-	u8 readbyte;
-	u16 retry;
-
-	/* Write Address */
-	usb_write8(Adapter, EFUSE_CTRL+1, (_offset & 0xff));
-	readbyte = usb_read8(Adapter, EFUSE_CTRL+2);
-	usb_write8(Adapter, EFUSE_CTRL+2, ((_offset >> 8) & 0x03) | (readbyte & 0xfc));
-
-	/* Write bit 32 0 */
-	readbyte = usb_read8(Adapter, EFUSE_CTRL+3);
-	usb_write8(Adapter, EFUSE_CTRL+3, (readbyte & 0x7f));
-
-	/* Check bit 32 read-ready */
-	retry = 0;
-	value32 = usb_read32(Adapter, EFUSE_CTRL);
-	while (!(((value32 >> 24) & 0xff) & 0x80)  && (retry < 10000)) {
-		value32 = usb_read32(Adapter, EFUSE_CTRL);
-		retry++;
-	}
-
-	/*  20100205 Joseph: Add delay suggested by SD1 Victor. */
-	/*  This fix the problem that Efuse read error in high temperature condition. */
-	/*  Designer says that there shall be some delay after ready bit is set, or the */
-	/*  result will always stay on last data we read. */
-	udelay(50);
-	value32 = usb_read32(Adapter, EFUSE_CTRL);
-
-	*pbuf = (u8)(value32 & 0xff);
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	EFUSE_Read1Byte
  *
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 41d6cf2..d8be20d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -125,7 +125,6 @@ u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u8 rtw_efuse_map_write(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
 u8 Efuse_CalculateWordCnts(u8 word_en);
-void ReadEFuseByte(struct adapter *adapter, u16 _offset, u8 *pbuf, bool test);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
 			      void *out);
 u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data, bool test);
-- 
1.7.10.4

