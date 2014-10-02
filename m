Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaJBICA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:02:00 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43694 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBIB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:01:58 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9281tlZ001960, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: nway reset after setting eee
Date: Thu, 2 Oct 2014 16:01:22 +0800
Message-ID: <1394712342-15778-54-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restart autonegotiation is necessary after setting EEE.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a4d4c4a..e4dcfc1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3480,6 +3480,9 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
 	ret = tp->rtl_ops.eee_set(tp, edata);
 
+	if (ret == 0)
+		ret = mii_nway_restart(&tp->mii);
+
 	usb_autopm_put_interface(tp->intf);
 
 out:
-- 
1.9.3

