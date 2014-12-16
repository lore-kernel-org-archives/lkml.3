Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLPN6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:58:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39740 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaLPN6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:58:03 -0500
Date: Tue, 16 Dec 2014 15:57:58 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, ninox@posteo.net, tapaswenipathak@gmail.com,
        gdonald@gmail.com, cmroliv@gmail.com, asaf.vertz@tandemg.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8723au: core: fixing "foo * bar" should be
 "foo *bar"
Message-ID: <20141216135758.GA32288@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, "foo * bar" should be "foo *bar"

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
Changes in v2:
  - fix ugly multiline arguments to the functions

 drivers/staging/rtl8723au/core/rtw_efuse.c |   32 ++++++---------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index 81960e7..a6deddc 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -327,15 +327,9 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
  *---------------------------------------------------------------------------*/
 
 void
-EFUSE_Write1Byte(
-	struct rtw_adapter *	Adapter,
-	u16		Address,
-	u8		Value);
+EFUSE_Write1Byte(struct rtw_adapter *Adapter, u16 Address, u8 Value);
 void
-EFUSE_Write1Byte(
-	struct rtw_adapter *	Adapter,
-	u16		Address,
-	u8		Value)
+EFUSE_Write1Byte(struct rtw_adapter *Adapter, u16 Address, u8 Value)
 {
 	u8	Bytetemp = {0x00};
 	u8	temp = {0x00};
@@ -635,10 +629,7 @@ Efuse_ReadAllMap(struct rtw_adapter *pAdapter, u8 efuseType, u8 *Efuse)
  *
  *---------------------------------------------------------------------------*/
 static void
-efuse_ShadowRead1Byte(
-	struct rtw_adapter *	pAdapter,
-	u16		Offset,
-	u8		*Value)
+efuse_ShadowRead1Byte(struct rtw_adapter *pAdapter, u16 Offset, u8 *Value)
 {
 	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
 
@@ -647,10 +638,7 @@ efuse_ShadowRead1Byte(
 
 /* Read Two Bytes */
 static void
-efuse_ShadowRead2Byte(
-	struct rtw_adapter *	pAdapter,
-	u16		Offset,
-	u16		*Value)
+efuse_ShadowRead2Byte(struct rtw_adapter *pAdapter, u16 Offset, u16 *Value)
 {
 	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
 
@@ -660,10 +648,7 @@ efuse_ShadowRead2Byte(
 
 /* Read Four Bytes */
 static void
-efuse_ShadowRead4Byte(
-	struct rtw_adapter *	pAdapter,
-	u16		Offset,
-	u32		*Value)
+efuse_ShadowRead4Byte(struct rtw_adapter *pAdapter, u16 Offset, u32 *Value)
 {
 	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
 
@@ -722,11 +707,8 @@ void EFUSE_ShadowMapUpdate23a(struct rtw_adapter *pAdapter, u8 efuseType)
  *
  *---------------------------------------------------------------------------*/
 void
-EFUSE_ShadowRead23a(
-	struct rtw_adapter *	pAdapter,
-	u8		Type,
-	u16		Offset,
-	u32		*Value)
+EFUSE_ShadowRead23a(struct rtw_adapter *pAdapter,
+		    u8 Type, u16 Offset, u32 *Value)
 {
 	if (Type == 1)
 		efuse_ShadowRead1Byte(pAdapter, Offset, (u8 *)Value);
-- 
1.7.0.4

