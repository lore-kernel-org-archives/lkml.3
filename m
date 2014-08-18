Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaHRFrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 01:47:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49916 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaHRFrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 01:47:51 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: return -ENODEV on failure of try_module_get
Date: Mon, 18 Aug 2014 11:17:33 +0530
Message-Id: <1408340853-1674-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20140818015959.GC14301@kroah.com>
References: <20140818015959.GC14301@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __usb_find_phy_dev() does not return error and
try_module_get() fails, return -ENODEV.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/usb/phy/phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 36b6bce..fd0d7f1 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -232,6 +232,9 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
 	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
 	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
 		dev_dbg(dev, "unable to find transceiver\n");
+		if (!IS_ERR(phy))
+			phy = ERR_PTR(-ENODEV);
+
 		goto err0;
 	}
 
-- 
1.7.11.7

