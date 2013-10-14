Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3JNP2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:28:39 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49804 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964Ab3JNP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 08/13] usb: phy: msm: Drop default usb_dr_mode from platform data.
Date: Mon, 14 Oct 2013 18:24:35 +0300
Message-Id: <1381764280-28420-9-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

USB DT bindings states: "...In case this attribute isn't
passed via DT, USB DRD controllers should default to OTG...",
so remove redundand field.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |    7 -------
 include/linux/usb/msm_hsusb.h |    3 ---
 2 files changed, 10 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 2aca042..4a23cfa 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1067,15 +1067,8 @@ static void msm_otg_init_sm(struct msm_otg *motg)
 			else
 				clear_bit(B_SESS_VLD, &motg->inputs);
 		} else if (pdata->otg_control == OTG_USER_CONTROL) {
-			if (pdata->default_mode == USB_DR_MODE_PERIPHERAL) {
-				set_bit(ID, &motg->inputs);
-				set_bit(B_SESS_VLD, &motg->inputs);
-			} else if (pdata->default_mode == USB_DR_MODE_HOST) {
-				clear_bit(ID, &motg->inputs);
-			} else {
 				set_bit(ID, &motg->inputs);
 				clear_bit(B_SESS_VLD, &motg->inputs);
-			}
 		}
 		break;
 	case USB_DR_MODE_HOST:
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index f9d512e..72c5830 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -106,8 +106,6 @@ enum usb_chg_type {
  * @power_budget: VBUS power budget in mA (0 will be treated as 500mA).
  * @mode: Supported mode (OTG/peripheral/host).
  * @otg_control: OTG switch controlled by user/Id pin
- * @default_mode: Default operational mode. Applicable only if
- *              OTG switch is controller by user.
  * @pclk_src_name: pclk is derived from ebi1_usb_clk in case of 7x27 and 8k
  *              dfab_usb_hs_clk in case of 8660 and 8960.
  */
@@ -117,7 +115,6 @@ struct msm_otg_platform_data {
 	unsigned power_budget;
 	enum usb_dr_mode mode;
 	enum otg_control_type otg_control;
-	enum usb_dr_mode default_mode;
 	enum msm_usb_phy_type phy_type;
 	void (*setup_gpio)(enum usb_otg_state state);
 	char *pclk_src_name;
-- 
1.7.9.5

