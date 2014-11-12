Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850AbaKLCpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:45:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965278AbaKLBoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:44:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arjun Sreedharan <arjun024@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.14 138/203] usb: phy: return -ENODEV on failure of try_module_get
Date: Wed, 12 Nov 2014 10:16:48 +0900
Message-Id: <20141112011549.016744025@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arjun Sreedharan <arjun024@gmail.com>

commit 2c4e3dbf63b39d44a291db70016c718f45d9cd46 upstream.

When __usb_find_phy_dev() does not return error and
try_module_get() fails, return -ENODEV.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/phy/phy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -229,6 +229,9 @@ struct usb_phy *usb_get_phy_dev(struct d
 	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
 	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
 		dev_dbg(dev, "unable to find transceiver\n");
+		if (!IS_ERR(phy))
+			phy = ERR_PTR(-ENODEV);
+
 		goto err0;
 	}
 


