Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaAFJUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:20:14 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54009 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaAFJUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:20:12 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s069K9pg028139, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: add terminating newline
Date: Mon, 6 Jan 2014 17:19:59 +0800
Message-ID: <1388999999-9218-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The netif_err() and netif_info() should have the terminating newline
at the end of the message.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5107372..3d8a565 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2135,11 +2135,11 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
-		netif_err(tp, probe, netdev, "couldn't register the device");
+		netif_err(tp, probe, netdev, "couldn't register the device\n");
 		goto out1;
 	}
 
-	netif_info(tp, probe, netdev, "%s", DRIVER_VERSION);
+	netif_info(tp, probe, netdev, "%s\n", DRIVER_VERSION);
 
 	return 0;
 
-- 
1.8.4.2

