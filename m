Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaLBItN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:49:13 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38375 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaLBItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:49:11 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB28n7Y4001827, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 1/2] r8169:prevent enable hardware tx/rx too early
Date: Tue, 2 Dec 2014 16:48:30 +0800
Message-ID: <1417510111-3568-2-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417510111-3568-1-git-send-email-hau@realtek.com>
References: <1417510111-3568-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For RTL8168G/GU/H/EP and RTL8411B remove enable tx/rx from its own hw_start
function. This will prevent enable tx/rx before complete hardware tx/rx
setting.

Tx/Rx will be enabled in the end of function rtl_hw_start_8168.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index cf154f7..7f4515f 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5934,7 +5934,6 @@ static void rtl_hw_start_8168g_1(struct rtl8169_private *tp)
 	rtl_w0w1_eri(tp, 0xdc, ERIAR_MASK_0001, 0x01, 0x00, ERIAR_EXGMAC);
 	rtl_eri_write(tp, 0x2f8, ERIAR_MASK_0011, 0x1d8f, ERIAR_EXGMAC);
 
-	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
 	RTL_W32(MISC, RTL_R32(MISC) & ~RXDV_GATED_EN);
 	RTL_W8(MaxTxPacketSize, EarlySize);
 
@@ -6027,7 +6026,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87, ERIAR_EXGMAC);
 
-	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
 	RTL_W32(MISC, RTL_R32(MISC) & ~RXDV_GATED_EN);
 	RTL_W8(MaxTxPacketSize, EarlySize);
 
@@ -6109,7 +6107,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87, ERIAR_EXGMAC);
 
-	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
 	RTL_W32(MISC, RTL_R32(MISC) & ~RXDV_GATED_EN);
 	RTL_W8(MaxTxPacketSize, EarlySize);
 
-- 
1.9.1

