Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaLGRaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:30:30 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37572 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaLGRa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:30:29 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: hal: rtl8188e_cmd.c:  Remove unused function
Date: Sun,  7 Dec 2014 18:33:06 +0100
Message-Id: <1417973586-13518-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function rtl8188e_set_rssi_cmd() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c     |   16 ----------------
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h |    1 -
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 023a3d8..0eb8afe 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -127,22 +127,6 @@ exit:
 	return ret;
 }
 
-u8 rtl8188e_set_rssi_cmd(struct adapter *adapt, u8 *param)
-{
-	u8 res = _SUCCESS;
-	struct hal_data_8188e *haldata = GET_HAL_DATA(adapt);
-
-	if (haldata->fw_ractrl) {
-		;
-	} else {
-		DBG_88E("==>%s fw dont support RA\n", __func__);
-		res = _FAIL;
-	}
-
-
-	return res;
-}
-
 u8 rtl8188e_set_raid_cmd(struct adapter *adapt, u32 mask)
 {
 	u8 buf[3];
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h b/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
index 0e78e2a..42b1f22 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
@@ -107,7 +107,6 @@ struct P2P_PS_CTWPeriod_t {
 /*  host message to firmware cmd */
 void rtl8188e_set_FwPwrMode_cmd(struct adapter *padapter, u8 Mode);
 void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *padapter, u8 mstatus);
-u8 rtl8188e_set_rssi_cmd(struct adapter *padapter, u8 *param);
 u8 rtl8188e_set_raid_cmd(struct adapter *padapter, u32 mask);
 void rtl8188e_Add_RateATid(struct adapter *padapter, u32 bitmap, u8 arg,
 			   u8 rssi_level);
-- 
1.7.10.4

