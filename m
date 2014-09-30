Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaI3PCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:02:40 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54608 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaI3PAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:00:46 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8UF0hb3017989, This message is accepted by code: ctloc85258
From: Chun-Hao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: [PATCH net-next 05/10] r8169:add more chips to support magic packet v2
Date: Tue, 30 Sep 2014 23:00:25 +0800
Message-ID: <1412089230-10208-5-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412089230-10208-1-git-send-email-hau@realtek.com>
References: <1412089230-10208-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For RTL8168F RTL8168FB RTL8168G RTL8168GU RTL8411 RTL8411B RTL8402
RTL8107E, the magic enable bit is changed to eri 0xde bit0.

In this patch, change magic packet enable bit of these chips to
eri 0xde bit0.

Signed-off-by: Chun-Hao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index b4cbc6c..1bf6696 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1546,8 +1546,20 @@ static u32 __rtl8169_get_wol(struct rtl8169_private *tp)
 	if (options & LinkUp)
 		wolopts |= WAKE_PHY;
 	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
+	case RTL_GIGA_MAC_VER_36:
+	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_38:
+	case RTL_GIGA_MAC_VER_40:
+	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_42:
+	case RTL_GIGA_MAC_VER_43:
+	case RTL_GIGA_MAC_VER_44:
 	case RTL_GIGA_MAC_VER_45:
 	case RTL_GIGA_MAC_VER_46:
+	case RTL_GIGA_MAC_VER_47:
+	case RTL_GIGA_MAC_VER_48:
 		if (rtl_eri_read(tp, 0xdc, ERIAR_EXGMAC) & MagicPacket_v2)
 			wolopts |= WAKE_MAGIC;
 		break;
@@ -1601,8 +1613,20 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
 
 	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
+	case RTL_GIGA_MAC_VER_36:
+	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_38:
+	case RTL_GIGA_MAC_VER_40:
+	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_42:
+	case RTL_GIGA_MAC_VER_43:
+	case RTL_GIGA_MAC_VER_44:
 	case RTL_GIGA_MAC_VER_45:
 	case RTL_GIGA_MAC_VER_46:
+	case RTL_GIGA_MAC_VER_47:
+	case RTL_GIGA_MAC_VER_48:
 		tmp = ARRAY_SIZE(cfg) - 1;
 		if (wolopts & WAKE_MAGIC)
 			rtl_w1w0_eri(tp,
@@ -7667,8 +7691,20 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	RTL_W8(Config1, RTL_R8(Config1) | PMEnable);
 	RTL_W8(Config5, RTL_R8(Config5) & (BWF | MWF | UWF | LanWake | PMEStatus));
 	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
+	case RTL_GIGA_MAC_VER_36:
+	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_38:
+	case RTL_GIGA_MAC_VER_40:
+	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_42:
+	case RTL_GIGA_MAC_VER_43:
+	case RTL_GIGA_MAC_VER_44:
 	case RTL_GIGA_MAC_VER_45:
 	case RTL_GIGA_MAC_VER_46:
+	case RTL_GIGA_MAC_VER_47:
+	case RTL_GIGA_MAC_VER_48:
 		if (rtl_eri_read(tp, 0xdc, ERIAR_EXGMAC) & MagicPacket_v2)
 			tp->features |= RTL_FEATURE_WOL;
 		if ((RTL_R8(Config3) & LinkUp) != 0)
-- 
1.8.3.2

