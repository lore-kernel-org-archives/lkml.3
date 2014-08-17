Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaHQSfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:35:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40473 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaHQSfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:35:04 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: return -ENODEV on failure of try_module_get
Date: Mon, 18 Aug 2014 00:04:42 +0530
Message-Id: <1408300482-1667-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __usb_find_phy_dev() does not return error and
try_module_get() fails, return -ENODEV

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/usb/phy/phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 36b6bce..8ad3638 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -232,6 +232,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
 	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
 	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
 		dev_dbg(dev, "unable to find transceiver\n");
+		phy = IS_ERR(phy) ? phy : ERR_PTR(-ENODEV);
 		goto err0;
 	}
 
-- 
1.7.11.7

