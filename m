Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaJFCgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 22:36:45 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46201 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaJFCgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 22:36:40 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s962aVPj019276, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2] r8152: nway reset after setting eee
Date: Mon, 6 Oct 2014 10:36:04 +0800
Message-ID: <1394712342-15778-57-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-54-Taiwan-albertk@realtek.com>
References: <1394712342-15778-54-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restart autonegotiation is necessary after setting EEE.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b9a9815..6532620 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3471,6 +3471,8 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
 		goto out;
 
 	ret = tp->rtl_ops.eee_set(tp, edata);
+	if (!ret)
+		ret = mii_nway_restart(&tp->mii);
 
 	usb_autopm_put_interface(tp->intf);
 
-- 
1.9.3

