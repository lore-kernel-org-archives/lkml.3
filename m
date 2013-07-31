Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab3GaJWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:22:02 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43000 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3GaJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:21:57 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6V9Lq5o030808, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH v4 3/5] net/usb/r815x: change the return value for bind functions
Date: Wed, 31 Jul 2013 17:21:24 +0800
Message-ID: <1375262486-5373-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
 <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace 0 with the result from usbnet_cdc_bind().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r815x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
index 1a80e76..2df2f4f 100644
--- a/drivers/net/usb/r815x.c
+++ b/drivers/net/usb/r815x.c
@@ -172,7 +172,7 @@ static int r8153_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = R815x_PHY_ID;
 	dev->mii.supports_gmii = 1;
 
-	return 0;
+	return status;
 }
 
 static int r8152_bind(struct usbnet *dev, struct usb_interface *intf)
@@ -191,7 +191,7 @@ static int r8152_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = R815x_PHY_ID;
 	dev->mii.supports_gmii = 0;
 
-	return 0;
+	return status;
 }
 
 static const struct driver_info r8152_info = {
-- 
1.8.3.1

