Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaHTI70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:59:26 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34239 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaHTI7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:59:24 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7K8xKRC002820, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 3/4] r8152: remove clear_bp function
Date: Wed, 20 Aug 2014 16:58:38 +0800
Message-ID: <1394712342-15778-19-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-16-Taiwan-albertk@realtek.com>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions are used to update the firmware. Move the actions into
the firmware files.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 33dcc97..937d132 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2189,28 +2189,6 @@ static void rtl_phy_reset(struct r8152 *tp)
 	}
 }
 
-static void rtl_clear_bp(struct r8152 *tp)
-{
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_0, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_2, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_4, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_6, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_0, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_2, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_4, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_6, 0);
-	mdelay(3);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0);
-}
-
-static void r8153_clear_bp(struct r8152 *tp)
-{
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_BP_EN, 0);
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_BP_EN, 0);
-	rtl_clear_bp(tp);
-}
-
 static void r8153_teredo_off(struct r8152 *tp)
 {
 	u32 ocp_data;
@@ -2248,7 +2226,6 @@ static void r8152b_hw_phy_cfg(struct r8152 *tp)
 
 	r8152b_disable_aldps(tp);
 
-	rtl_clear_bp(tp);
 
 	r8152b_enable_aldps(tp);
 	set_bit(PHY_RESET, &tp->flags);
@@ -2404,7 +2381,6 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 		r8152_mdio_write(tp, MII_BMCR, data);
 	}
 
-	r8153_clear_bp(tp);
 
 	if (tp->version == RTL_VER_03) {
 		data = ocp_reg_read(tp, OCP_EEE_CFG);
-- 
1.9.3

