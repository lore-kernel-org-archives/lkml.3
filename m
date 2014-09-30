Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaI3PDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:03:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54604 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI3PAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:00:44 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8UF0f8c017764, This message is accepted by code: ctloc85258
From: Chun-Hao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: [PATCH net-next 03/10] r8169:add disable/enable RTL8168GU mcu power managment interrupt
Date: Tue, 30 Sep 2014 23:00:23 +0800
Message-ID: <1412089230-10208-3-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412089230-10208-1-git-send-email-hau@realtek.com>
References: <1412089230-10208-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTL8168GU also need to disable/enable mcu power managment interrupt
before disable/eable pll.

Signed-off-by: Chun-Hao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 6d68229..f7b0c7d8 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4373,6 +4373,7 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 		break;
 	case RTL_GIGA_MAC_VER_40:
 	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_42:
 		rtl_w1w0_eri(tp, 0x1a8, ERIAR_MASK_1111, 0x00000000,
 			     0xfc000000, ERIAR_EXGMAC);
 		RTL_W8(PMCH, RTL_R8(PMCH) & ~0x80);
@@ -4400,6 +4401,7 @@ static void r8168_pll_power_up(struct rtl8169_private *tp)
 		break;
 	case RTL_GIGA_MAC_VER_40:
 	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_42:
 		RTL_W8(PMCH, RTL_R8(PMCH) | 0xc0);
 		rtl_w1w0_eri(tp, 0x1a8, ERIAR_MASK_1111, 0xfc000000,
 			     0x00000000, ERIAR_EXGMAC);
-- 
1.8.3.2

