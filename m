Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaAYPGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 10:06:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbaAYPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 10:06:23 -0500
Date: Sat, 25 Jan 2014 10:05:59 -0500
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com
Subject: [PATCH] usb: phy: Quiet unable to find transceiver message
Message-ID: <20140125150559.GN16455@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1ae5799ef6317 ("usb: hcd: Initialize USB phy if needed") allows
the USB layer to initialize external PHYs if needed.  However, a PHY is
not needed in all cases.  The usb_get_phy_device function will print
an error message, "unable to find transceiver" but everything still
functions normally.

Drop the severity of this message to pr_debug.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 drivers/usb/phy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index e6f61e4..c7fe880 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -228,7 +228,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
 
 	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
 	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
-		pr_err("unable to find transceiver\n");
+		pr_debug("unable to find transceiver\n");
 		goto err0;
 	}
 
-- 
1.8.5.3

