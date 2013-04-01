Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3DAN4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:56:13 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38808 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab3DAN4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:56:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r31Du3SO009564, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/7] r8169: Remove firmware code
Date: Mon, 1 Apr 2013 21:55:33 +0800
Message-ID: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some codes are belong to binary codes and should be removed.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 28fb50a..d36aa76 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3368,32 +3368,6 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const u16 mac_ocp_patch[] = {
-		0xe008, 0xe01b, 0xe01d, 0xe01f,
-		0xe021, 0xe023, 0xe025, 0xe027,
-		0x49d2, 0xf10d, 0x766c, 0x49e2,
-		0xf00a, 0x1ec0, 0x8ee1, 0xc60a,
-
-		0x77c0, 0x4870, 0x9fc0, 0x1ea0,
-		0xc707, 0x8ee1, 0x9d6c, 0xc603,
-		0xbe00, 0xb416, 0x0076, 0xe86c,
-		0xc602, 0xbe00, 0x0000, 0xc602,
-
-		0xbe00, 0x0000, 0xc602, 0xbe00,
-		0x0000, 0xc602, 0xbe00, 0x0000,
-		0xc602, 0xbe00, 0x0000, 0xc602,
-		0xbe00, 0x0000, 0xc602, 0xbe00,
-
-		0x0000, 0x0000, 0x0000, 0x0000
-	};
-	u32 i;
-
-	/* Patch code for GPHY reset */
-	for (i = 0; i < ARRAY_SIZE(mac_ocp_patch); i++)
-		r8168_mac_ocp_write(tp, 0xf800 + 2*i, mac_ocp_patch[i]);
-	r8168_mac_ocp_write(tp, 0xfc26, 0x8000);
-	r8168_mac_ocp_write(tp, 0xfc28, 0x0075);
-
 	rtl_apply_firmware(tp);
 
 	if (r8168_phy_ocp_read(tp, 0xa460) & 0x0100)
-- 
1.8.1

