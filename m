Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbbAGQkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:40:46 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41857 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbbAGQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:40:43 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t07Gefb7024041, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 09/11] r8169:update rtl8105e pcie ephy parameter
Date: Thu, 8 Jan 2015 00:40:24 +0800
Message-ID: <1420648826-12972-10-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420648826-12972-1-git-send-email-hau@realtek.com>
References: <1420648826-12972-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8105e may return to PCIe L0 from PCIe L0s low power mode too slow.
The following ephy parameters are for this issue.
{ 0x05,	0, 0x2000 }

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index e92eece..ce98d2a 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6403,7 +6403,8 @@ static void rtl_hw_start_8105e_1(struct rtl8169_private *tp)
 		{ 0x03,	0, 0x0001 },
 		{ 0x19,	0, 0x0100 },
 		{ 0x19,	0, 0x0004 },
-		{ 0x0a,	0, 0x0020 }
+		{ 0x0a,	0, 0x0020 },
+		{ 0x05,	0, 0x2000 }
 	};
 
 	/* Force LAN exit from ASPM if Rx/Tx are not idle */
-- 
1.9.1

