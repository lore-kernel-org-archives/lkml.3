Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966381AbaKLCF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:05:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43118 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935117AbaKLCFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:05:24 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAC25LEo029941, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 2/3] r8152: clear the flag of SCHEDULE_TASKLET in tasklet
Date: Wed, 12 Nov 2014 10:05:04 +0800
Message-ID: <1394712342-15778-93-Taiwan-albertk@realtek.com>
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

Clear the flag of SCHEDULE_TASKLET in bottom_half() to avoid
re-schedule the tasklet again by workqueue.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a300467..ad9dd7d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1797,6 +1797,8 @@ static void bottom_half(unsigned long data)
 	if (!netif_carrier_ok(tp->netdev))
 		return;
 
+	clear_bit(SCHEDULE_TASKLET, &tp->flags);
+
 	rx_bottom(tp);
 	tx_bottom(tp);
 }
-- 
1.9.3

