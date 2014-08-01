Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaHAPYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:24:15 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:58722 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:24:13 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cmroliv@gmail.com
Subject: [PATCH] staging: rtl8723au: Fix static symbol sparse warning
Date: Fri,  1 Aug 2014 17:54:39 +0100
Message-Id: <1406912079-3115-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <53DBA840.6050804@lwfinger.net>
References: <53DBA840.6050804@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
drivers/staging/rtl8723au/core/rtw_efuse.c:579:5: warning: symbol 'efuse_GetCurrentSize23a' was not declared. Should it be static?
by removing efuse_GetCurrentSize23a since its never used

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_efuse.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index 345bff8..fe092c5 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -100,22 +100,6 @@ static void Efuse_PowerSwitch(struct rtw_adapter *padapter,
 	}
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	efuse_GetCurrentSize23a
- *
- * Overview:	Get current efuse size!!!
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/16/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
 u16
 Efuse_GetCurrentSize23a(struct rtw_adapter *pAdapter, u8 efuseType)
 {
@@ -576,15 +560,6 @@ u16 efuse_GetMaxSize23a(struct rtw_adapter *padapter)
 	return max_size;
 }
 /*  */
-int efuse_GetCurrentSize23a(struct rtw_adapter *padapter, u16 *size)
-{
-	Efuse_PowerSwitch(padapter, false, true);
-	*size = Efuse_GetCurrentSize23a(padapter, EFUSE_WIFI);
-	Efuse_PowerSwitch(padapter, false, false);
-
-	return _SUCCESS;
-}
-/*  */
 int rtw_efuse_map_read23a(struct rtw_adapter *padapter,
 			  u16 addr, u16 cnts, u8 *data)
 {
-- 
1.7.10.4

