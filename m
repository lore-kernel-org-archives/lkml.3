Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422728AbaGRRCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:02:39 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:38447 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030450AbaGRRCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:02:14 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 5/6] usb: phy: mxs: Add VF610 USB PHY support
Date: Fri, 18 Jul 2014 19:01:41 +0200
Message-Id: <af194168fadd80c26f94da740f1e61ce6603225a.1405702442.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405702442.git.stefan@agner.ch>
References: <cover.1405702442.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the USB PHY in Vybrid VF610. We assume that
the disconnection without VBUS is also needed for Vybrid. For all
other flags, the presumption of innocence applies.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/usb/phy/phy-mxs-usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index c42bdf0..207946b 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -125,10 +125,15 @@ static const struct mxs_phy_data imx6sl_phy_data = {
 		MXS_PHY_NEED_IP_FIX,
 };
 
+static const struct mxs_phy_data vf610_phy_data = {
+	.flags = MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS,
+};
+
 static const struct of_device_id mxs_phy_dt_ids[] = {
 	{ .compatible = "fsl,imx6sl-usbphy", .data = &imx6sl_phy_data, },
 	{ .compatible = "fsl,imx6q-usbphy", .data = &imx6q_phy_data, },
 	{ .compatible = "fsl,imx23-usbphy", .data = &imx23_phy_data, },
+	{ .compatible = "fsl,vf610-usbphy", .data = &vf610_phy_data, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mxs_phy_dt_ids);
-- 
2.0.1

