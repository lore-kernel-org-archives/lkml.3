Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbbAIC1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:27:00 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57227 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbAIC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:26:57 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t092Qsuv023224, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 1/2 RESEND] r8152: call rtl_start_rx after netif_carrier_on
Date: Fri, 9 Jan 2015 10:26:35 +0800
Message-ID: <1394712342-15778-115-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-114-Taiwan-albertk@realtek.com>
References: <1394712342-15778-114-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove rtl_start_rx() from rtl_enable() and put it after calling
netif_carrier_on().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 57ec23e..cd93388 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2059,7 +2059,7 @@ static int rtl_enable(struct r8152 *tp)
 
 	rxdy_gated_en(tp, false);
 
-	return rtl_start_rx(tp);
+	return 0;
 }
 
 static int rtl8152_enable(struct r8152 *tp)
@@ -2874,6 +2874,7 @@ static void set_carrier(struct r8152 *tp)
 			tp->rtl_ops.enable(tp);
 			set_bit(RTL8152_SET_RX_MODE, &tp->flags);
 			netif_carrier_on(netdev);
+			rtl_start_rx(tp);
 		}
 	} else {
 		if (tp->speed & LINK_STATUS) {
-- 
2.1.0

