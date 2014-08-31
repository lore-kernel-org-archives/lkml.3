Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbaHaIil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:38:41 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65433 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaHaIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:38:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 1/9] staging: rtl8188eu: Rework function rtl8188e_PHY_RF6052SetBandwidth()
Date: Sun, 31 Aug 2014 14:08:21 +0530
Message-Id: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/phy.c             |    3 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   58 +++++------------------
 drivers/staging/rtl8188eu/include/rf.h          |    2 +
 3 files changed, 16 insertions(+), 47 deletions(-)
 create mode 100644 drivers/staging/rtl8188eu/include/rf.h

diff --git a/drivers/staging/rtl8188eu/hal/phy.c b/drivers/staging/rtl8188eu/hal/phy.c
index 5041da0..b67b91e 100644
--- a/drivers/staging/rtl8188eu/hal/phy.c
+++ b/drivers/staging/rtl8188eu/hal/phy.c
@@ -23,6 +23,7 @@
 #include <drv_types.h>
 #include <rtw_iol.h>
 #include <rtl8188e_hal.h>
+#include <rf.h>
 
 #define MAX_PRECMD_CNT 16
 #define MAX_RFDEPENDCMD_CNT 16
@@ -312,7 +313,7 @@ static void phy_set_bw_mode_callback(struct adapter *adapt)
 	case RF_PSEUDO_11N:
 		break;
 	case RF_6052:
-		rtl8188e_PHY_RF6052SetBandwidth(adapt, hal_data->CurrentChannelBW);
+		rtl88eu_phy_rf6052_set_bandwidth(adapt, hal_data->CurrentChannelBW);
 		break;
 	default:
 		break;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index bcee67a..bd90068 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -15,64 +15,30 @@
  * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
  *
- *
  ******************************************************************************/
-/******************************************************************************
- *
- *
- * Module:	rtl8192c_rf6052.c	( Source C File)
- *
- * Note:	Provide RF 6052 series relative API.
- *
- * Function:
- *
- * Export:
- *
- * Abbrev:
- *
- * History:
- * Data			Who		Remark
- *
- * 09/25/2008	MHC		Create initial version.
- * 11/05/2008	MHC		Add API for tw power setting.
- *
- *
-******************************************************************************/
-
-#define _RTL8188E_RF6052_C_
 
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <phy.h>
 #include <rtl8188e_hal.h>
 
-/*-----------------------------------------------------------------------------
- * Function:    PHY_RF6052SetBandwidth()
- *
- * Overview:    This function is called by SetBWModeCallback8190Pci() only
- *
- * Input:       struct adapter *Adapter
- *			WIRELESS_BANDWIDTH_E	Bandwidth	20M or 40M
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Note:		For RF type 0222D
- *---------------------------------------------------------------------------*/
-void rtl8188e_PHY_RF6052SetBandwidth(struct adapter *Adapter,
-				     enum ht_channel_width Bandwidth)
+void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
+				      enum ht_channel_width bandwidth)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
 
-	switch (Bandwidth) {
+	switch (bandwidth) {
 	case HT_CHANNEL_WIDTH_20:
-		pHalData->RfRegChnlVal[0] = ((pHalData->RfRegChnlVal[0] & 0xfffff3ff) | BIT(10) | BIT(11));
-		phy_set_rf_reg(Adapter, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask, pHalData->RfRegChnlVal[0]);
+		hal_data->RfRegChnlVal[0] = ((hal_data->RfRegChnlVal[0] &
+					      0xfffff3ff) | BIT(10) | BIT(11));
+		phy_set_rf_reg(adapt, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask,
+			       hal_data->RfRegChnlVal[0]);
 		break;
 	case HT_CHANNEL_WIDTH_40:
-		pHalData->RfRegChnlVal[0] = ((pHalData->RfRegChnlVal[0] & 0xfffff3ff) | BIT(10));
-		phy_set_rf_reg(Adapter, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask, pHalData->RfRegChnlVal[0]);
+		hal_data->RfRegChnlVal[0] = ((hal_data->RfRegChnlVal[0] &
+					      0xfffff3ff) | BIT(10));
+		phy_set_rf_reg(adapt, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask,
+			       hal_data->RfRegChnlVal[0]);
 		break;
 	default:
 		break;
diff --git a/drivers/staging/rtl8188eu/include/rf.h b/drivers/staging/rtl8188eu/include/rf.h
new file mode 100644
index 0000000..ca0d28d
--- /dev/null
+++ b/drivers/staging/rtl8188eu/include/rf.h
@@ -0,0 +1,2 @@
+void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
+				      enum ht_channel_width bandwidth);
-- 
1.7.10.4

