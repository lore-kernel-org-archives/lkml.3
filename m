Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaCIH1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:27:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47515 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCIH1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:27:45 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/28 v2] phy: omap-usb2: Add different compatible for OMAP5
Date: Sun, 9 Mar 2014 12:57:39 +0530
Message-ID: <1394350059-20524-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394350059-20524-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
 <1394350059-20524-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

Add a new compatible for OMAP5 since it does not use any of the
OTG operations as of now.
HAS_SRP and SET_VBUS functionalities are used only for OMAP4.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
removed the Documentation since the name of the file got modified in usb tree.
 drivers/phy/phy-omap-usb2.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index b220202..3cc4aba 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -154,6 +154,11 @@ static const struct usb_phy_data omap_usb2_data = {
 	.flags = OMAP_USB2_HAS_START_SRP | OMAP_USB2_HAS_SET_VBUS,
 };
 
+static const struct usb_phy_data omap5_usb2_data = {
+	.label = "omap5_usb2",
+	.flags = 0,
+};
+
 static const struct usb_phy_data dra7x_usb2_data = {
 	.label = "dra7x_usb2",
 	.flags = OMAP_USB2_CALIBRATE_FALSE_DISCONNECT,
@@ -170,6 +175,10 @@ static const struct of_device_id omap_usb2_id_table[] = {
 		.data = &omap_usb2_data,
 	},
 	{
+		.compatible = "ti,omap5-usb2",
+		.data = &omap5_usb2_data,
+	},
+	{
 		.compatible = "ti,dra7x-usb2",
 		.data = &dra7x_usb2_data,
 	},
-- 
1.7.9.5

