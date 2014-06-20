Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207AbaFTUl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:41:57 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:20355 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbaFTUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:41:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHADWbpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBAhg3iC4DFQHDVQ2GSxeFYoZxgiMdhC0EmEuBeYswgiiGAoNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Emil Goode <emilgoode@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH 1/2] drivers/net/usb/asix_devices.c: remove null test before kfree
Date: Fri, 20 Jun 2014 22:40:39 +0200
Message-Id: <1403296839-6321-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Emil Goode <emilgoode@gmail.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/usb/asix_devices.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 5d19409..8a7582b 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -499,8 +499,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
-	if (dev->driver_priv)
-		kfree(dev->driver_priv);
+	kfree(dev->driver_priv);
 }
 
 static const struct ethtool_ops ax88178_ethtool_ops = {
-- 
1.8.4.5

