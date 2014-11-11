Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaKKLJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaKKLJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arjun Sreedharan <arjun024@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 005/170] usb: phy: return -ENODEV on failure of try_module_get
Date: Tue, 11 Nov 2014 11:06:04 +0000
Message-Id: <1415704129-12709-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arjun Sreedharan <arjun024@gmail.com>

commit 2c4e3dbf63b39d44a291db70016c718f45d9cd46 upstream.

When __usb_find_phy_dev() does not return error and
try_module_get() fails, return -ENODEV.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/phy/phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 36b6bce33b20..fd0d7f122ace 100644
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
2.1.0

