Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaJ2DQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:16:55 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55489 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaJ2DQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:16:34 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9T3GPYn004736, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 3/3] r8152: check WORK_ENABLE in suspend function
Date: Wed, 29 Oct 2014 11:12:17 +0800
Message-ID: <1394712342-15778-72-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-69-Taiwan-albertk@realtek.com>
References: <1394712342-15778-69-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid unnecessary behavior when autosuspend occurs during open().
The relative processes should only be run after finishing open().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f224231..ca3c5d5 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3207,7 +3207,7 @@ static int rtl8152_suspend(struct usb_interface *intf, pm_message_t message)
 		netif_device_detach(netdev);
 	}
 
-	if (netif_running(netdev)) {
+	if (netif_running(netdev) && test_bit(WORK_ENABLE, &tp->flags)) {
 		clear_bit(WORK_ENABLE, &tp->flags);
 		usb_kill_urb(tp->intr_urb);
 		tasklet_disable(&tp->tl);
-- 
1.9.3

