Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966806AbaKLCFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:05:37 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43117 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaKLCFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:05:23 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAC25Kp1029934, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 1/3] r8152: remove the duplicate init for the list of rx_done
Date: Wed, 12 Nov 2014 10:05:03 +0800
Message-ID: <1394712342-15778-92-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-91-Taiwan-albertk@realtek.com>
References: <1394712342-15778-79-Taiwan-albertk@realtek.com>
 <1394712342-15778-91-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The INIT_LIST_HEAD(&tp->rx_done) would be done in rtl_start_rx(),
so remove the unnecessary one in alloc_all_mem().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 66b139a..a300467 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1255,7 +1255,6 @@ static int alloc_all_mem(struct r8152 *tp)
 
 	spin_lock_init(&tp->rx_lock);
 	spin_lock_init(&tp->tx_lock);
-	INIT_LIST_HEAD(&tp->rx_done);
 	INIT_LIST_HEAD(&tp->tx_free);
 	skb_queue_head_init(&tp->tx_queue);
 
-- 
1.9.3

