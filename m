Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaILDja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:39:30 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55311 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaILDj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:39:28 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8C3dMuK015393, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 1/2] r8169: fix the default setting of rx vlan
Date: Fri, 12 Sep 2014 11:35:11 +0800
Message-ID: <1394712342-15778-39-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-38-Taiwan-albertk@realtek.com>
References: <1394712342-15778-38-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the parameter "features" of __rtl8169_set_features() is equal to
dev->features, the variable "changed" is alwayes 0, and nothing would
be changed.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 91652e7..f3ce284 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6707,7 +6707,12 @@ static int rtl_open(struct net_device *dev)
 
 	rtl8169_init_phy(dev, tp);
 
-	__rtl8169_set_features(dev, dev->features);
+	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		tp->cp_cmd |= RxVlan;
+	else
+		tp->cp_cmd &= ~RxVlan;
+
+	RTL_W16(CPlusCmd, tp->cp_cmd);
 
 	rtl_pll_power_up(tp);
 
-- 
1.9.3

