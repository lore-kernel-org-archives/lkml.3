Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaIAPn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:43:56 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47103 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaIAPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:43:54 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 1/8] staging: rtl8188eu: Rework function HalPwrSeqCmdParsing()
Date: Mon,  1 Sep 2014 21:13:36 +0530
Message-Id: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c     |   64 +++++++++-------------
 drivers/staging/rtl8188eu/hal/usb_halinit.c      |   12 +++-
 drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h |    4 +-
 3 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
index caca535..2565d6e 100644
--- a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
+++ b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
@@ -15,36 +15,16 @@
  * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
  *
- *
  ******************************************************************************/
-/*++
-Copyright (c) Realtek Semiconductor Corp. All rights reserved.
-
-Module Name:
-	HalPwrSeqCmd.c
-
-Abstract:
-	Implement HW Power sequence configuration CMD handling routine for Realtek devices.
-
-Major Change History:
-	When       Who               What
-	---------- ---------------   -------------------------------
-	2011-10-26 Lucas            Modify to be compatible with SD4-CE driver.
-	2011-07-07 Roger            Create.
-
---*/
 
 #include <HalPwrSeqCmd.h>
 #include <usb_ops_linux.h>
 
-/*	Description: */
-/*		This routine deals with the Power Configuration CMDs parsing
- *		for RTL8723/RTL8188E Series IC.
- *	Assumption:
- *		We should follow specific format which was released from HW SD.
+/* This routine deals with the Power Configuration CMDs parsing
+ * for RTL8723/RTL8188E Series IC.
  */
-u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
-		       u8 ifacetype, struct wl_pwr_cfg pwrseqcmd[])
+u8 rtl88eu_pwrseqcmdparsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
+			    u8 ifacetype, struct wl_pwr_cfg pwrseqcmd[])
 {
 	struct wl_pwr_cfg pwrcfgcmd = {0};
 	u8 poll_bit = false;
@@ -58,7 +38,9 @@ u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 		pwrcfgcmd = pwrseqcmd[aryidx];
 
 		RT_TRACE(_module_hal_init_c_ , _drv_info_,
-			 ("HalPwrSeqCmdParsing: offset(%#x) cut_msk(%#x) fab_msk(%#x) interface_msk(%#x) base(%#x) cmd(%#x) msk(%#x) value(%#x)\n",
+			 ("rtl88eu_pwrseqcmdparsing: offset(%#x) cut_msk(%#x)"
+			  "fab_msk(%#x) interface_msk(%#x) base(%#x) cmd(%#x)"
+			  "msk(%#x) value(%#x)\n",
 			 GET_PWR_CFG_OFFSET(pwrcfgcmd),
 			 GET_PWR_CFG_CUT_MASK(pwrcfgcmd),
 			 GET_PWR_CFG_FAB_MASK(pwrcfgcmd),
@@ -68,37 +50,42 @@ u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 			 GET_PWR_CFG_MASK(pwrcfgcmd),
 			 GET_PWR_CFG_VALUE(pwrcfgcmd)));
 
-		/* 2 Only Handle the command whose FAB, CUT, and Interface are matched */
+		/* Only Handle the command whose FAB, CUT, and Interface are matched */
 		if ((GET_PWR_CFG_FAB_MASK(pwrcfgcmd) & fab_vers) &&
 		    (GET_PWR_CFG_CUT_MASK(pwrcfgcmd) & cut_vers) &&
 		    (GET_PWR_CFG_INTF_MASK(pwrcfgcmd) & ifacetype)) {
 			switch (GET_PWR_CFG_CMD(pwrcfgcmd)) {
 			case PWR_CMD_READ:
-				RT_TRACE(_module_hal_init_c_ , _drv_info_, ("HalPwrSeqCmdParsing: PWR_CMD_READ\n"));
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_READ\n"));
 				break;
 			case PWR_CMD_WRITE:
-				RT_TRACE(_module_hal_init_c_ , _drv_info_, ("HalPwrSeqCmdParsing: PWR_CMD_WRITE\n"));
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_WRITE\n"));
 				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
 
 				/*  Read the value from system register */
 				value = usb_read8(padapter, offset);
 
 				value &= ~(GET_PWR_CFG_MASK(pwrcfgcmd));
-				value |= (GET_PWR_CFG_VALUE(pwrcfgcmd) & GET_PWR_CFG_MASK(pwrcfgcmd));
+				value |= (GET_PWR_CFG_VALUE(pwrcfgcmd) &
+					  GET_PWR_CFG_MASK(pwrcfgcmd));
 
 				/*  Write the value back to system register */
 				usb_write8(padapter, offset, value);
 				break;
 			case PWR_CMD_POLLING:
-				RT_TRACE(_module_hal_init_c_ , _drv_info_, ("HalPwrSeqCmdParsing: PWR_CMD_POLLING\n"));
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_POLLING\n"));
 
 				poll_bit = false;
 				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
 				do {
-						value = usb_read8(padapter, offset);
-
+					value = usb_read8(padapter, offset);
 					value &= GET_PWR_CFG_MASK(pwrcfgcmd);
-					if (value == (GET_PWR_CFG_VALUE(pwrcfgcmd) & GET_PWR_CFG_MASK(pwrcfgcmd)))
+
+					if (value == (GET_PWR_CFG_VALUE(pwrcfgcmd) &
+						      GET_PWR_CFG_MASK(pwrcfgcmd)))
 						poll_bit = true;
 					else
 						udelay(10);
@@ -110,19 +97,22 @@ u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 				} while (!poll_bit);
 				break;
 			case PWR_CMD_DELAY:
-				RT_TRACE(_module_hal_init_c_ , _drv_info_, ("HalPwrSeqCmdParsing: PWR_CMD_DELAY\n"));
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_DELAY\n"));
 				if (GET_PWR_CFG_VALUE(pwrcfgcmd) == PWRSEQ_DELAY_US)
 					udelay(GET_PWR_CFG_OFFSET(pwrcfgcmd));
 				else
 					udelay(GET_PWR_CFG_OFFSET(pwrcfgcmd)*1000);
 				break;
 			case PWR_CMD_END:
-				/*  When this command is parsed, end the process */
-				RT_TRACE(_module_hal_init_c_ , _drv_info_, ("HalPwrSeqCmdParsing: PWR_CMD_END\n"));
+				/* When this command is parsed, end the process */
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_END\n"));
 				return true;
 				break;
 			default:
-				RT_TRACE(_module_hal_init_c_ , _drv_err_, ("HalPwrSeqCmdParsing: Unknown CMD!!\n"));
+				RT_TRACE(_module_hal_init_c_, _drv_err_,
+					 ("rtl88eu_pwrseqcmdparsing: Unknown CMD!!\n"));
 				break;
 			}
 		}
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index f56cbdf..15a818a 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -107,7 +107,9 @@ static u32 rtl8188eu_InitPowerOn(struct adapter *adapt)
 	if (haldata->bMacPwrCtrlOn)
 		return _SUCCESS;
 
-	if (!HalPwrSeqCmdParsing(adapt, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, Rtl8188E_NIC_PWR_ON_FLOW)) {
+	if (!rtl88eu_pwrseqcmdparsing(adapt, PWR_CUT_ALL_MSK,
+				      PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,
+				      Rtl8188E_NIC_PWR_ON_FLOW)) {
 		DBG_88E(KERN_ERR "%s: run power on flow fail\n", __func__);
 		return _FAIL;
 	}
@@ -925,7 +927,9 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 	usb_write8(Adapter, REG_CR, 0x0);
 
 	/*  Run LPS WL RFOFF flow */
-	HalPwrSeqCmdParsing(Adapter, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, Rtl8188E_NIC_LPS_ENTER_FLOW);
+	rtl88eu_pwrseqcmdparsing(Adapter, PWR_CUT_ALL_MSK,
+				 PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,
+				 Rtl8188E_NIC_LPS_ENTER_FLOW);
 
 	/*  2. 0x1F[7:0] = 0		turn off RF */
 
@@ -946,7 +950,9 @@ static void CardDisableRTL8188EU(struct adapter *Adapter)
 	usb_write8(Adapter, REG_32K_CTRL, val8&(~BIT0));
 
 	/*  Card disable power action flow */
-	HalPwrSeqCmdParsing(Adapter, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, Rtl8188E_NIC_DISABLE_FLOW);
+	rtl88eu_pwrseqcmdparsing(Adapter, PWR_CUT_ALL_MSK,
+				 PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,
+				 Rtl8188E_NIC_DISABLE_FLOW);
 
 	/*  Reset MCU IO Wrapper */
 	val8 = usb_read8(Adapter, REG_RSV_CTRL+1);
diff --git a/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h b/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
index d945784..fc24ce4 100644
--- a/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
+++ b/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
@@ -122,7 +122,7 @@ struct wl_pwr_cfg {
 
 
 /*	Prototype of protected function. */
-u8 HalPwrSeqCmdParsing(struct adapter *padapter, u8 CutVersion, u8 FabVersion,
-		       u8 InterfaceType, struct wl_pwr_cfg PwrCfgCmd[]);
+u8 rtl88eu_pwrseqcmdparsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
+			    u8 ifacetype, struct wl_pwr_cfg pwrcfgCmd[]);
 
 #endif
-- 
1.7.10.4

