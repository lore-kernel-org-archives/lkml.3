Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaJAPRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:17:55 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48794 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaJAPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:17:51 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s91FHm2v004297, This message is accepted by code: ctloc85258
From: Chun-Hao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: [PATCH v2 net-next 08/10] r8169:change the name of function "r8168dp_check_dash" to "r8168_check_dash"
Date: Wed, 1 Oct 2014 23:17:19 +0800
Message-ID: <1412176641-24393-8-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412176641-24393-1-git-send-email-hau@realtek.com>
References: <1412176641-24393-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DASH function not only RTL8168DP can support, but also RTL8168EP.
So change the name of function "r8168dp_check_dash" to "r8168_check_dash".

Signed-off-by: Chun-Hao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 5884b6d..d84605a 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1015,7 +1015,7 @@ static void rtl8168_driver_stop(struct rtl8169_private *tp)
 	rtl_msleep_loop_wait_low(tp, &rtl_ocp_read_cond, 10, 10);
 }
 
-static int r8168dp_check_dash(struct rtl8169_private *tp)
+static int r8168_check_dash(struct rtl8169_private *tp)
 {
 	u16 reg = rtl8168_get_ocp_reg(tp);
 
@@ -4364,7 +4364,7 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 	if ((tp->mac_version == RTL_GIGA_MAC_VER_27 ||
 	     tp->mac_version == RTL_GIGA_MAC_VER_28 ||
 	     tp->mac_version == RTL_GIGA_MAC_VER_31) &&
-	    r8168dp_check_dash(tp)) {
+	    r8168_check_dash(tp)) {
 		return;
 	}
 
-- 
1.8.3.2

