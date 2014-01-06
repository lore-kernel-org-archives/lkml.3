Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaAFGky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:40:54 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43072 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaAFGjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:39:42 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s066ddTO019004, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/3] r8152: move the actions of saving the information of the device
Date: Mon, 6 Jan 2014 14:39:25 +0800
Message-ID: <1388990366-8508-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
References: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some information of the device may be used in other functions. Move
the relative code to make sure it would be initialzed correctly
before using it.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 095f15b..8615681 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2759,6 +2759,10 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp = netdev_priv(netdev);
 	tp->msg_enable = 0x7FFF;
 
+	tp->udev = udev;
+	tp->netdev = netdev;
+	tp->intf = intf;
+
 	if (!rtl_ops_init(tp, id)) {
 		netif_err(tp, probe, netdev, "Unknown Device");
 		return -ENODEV;
@@ -2767,9 +2771,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tasklet_init(&tp->tl, bottom_half, (unsigned long)tp);
 	INIT_DELAYED_WORK(&tp->schedule, rtl_work_func_t);
 
-	tp->udev = udev;
-	tp->netdev = netdev;
-	tp->intf = intf;
 	netdev->netdev_ops = &rtl8152_netdev_ops;
 	netdev->watchdog_timeo = RTL8152_TX_TIMEOUT;
 
-- 
1.8.4.2

