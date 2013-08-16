Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3HPILE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:11:04 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52625 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3HPIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:10:44 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7G8AaM9017142, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/7] r8152: remove clearing the memory to zero for netdev priv
Date: Fri, 16 Aug 2013 16:09:32 +0800
Message-ID: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove memset(tp, 0, sizeof(*tp));

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ef2498c..c13662b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2105,7 +2105,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	tp = netdev_priv(netdev);
-	memset(tp, 0, sizeof(*tp));
 	tp->msg_enable = 0x7FFF;
 
 	tasklet_init(&tp->tl, bottom_half, (unsigned long)tp);
-- 
1.8.3.1

