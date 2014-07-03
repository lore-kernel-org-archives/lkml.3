Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaGCD4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 23:56:09 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42751 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGCD4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 23:56:07 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s633u1lJ019957, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: increase the tx timeout
Date: Thu, 3 Jul 2014 11:55:48 +0800
Message-ID: <1404359748-4202-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system is too busy to complete the urb, the tx timout function
would be called. This causes the other tx urbs would be killed, too.
Increase the tx timeout to avoid it.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2543196..e9685ce 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -441,7 +441,7 @@ enum rtl_register_content {
 #define BYTE_EN_END_MASK	0xf0
 
 #define RTL8152_RMS		(VLAN_ETH_FRAME_LEN + VLAN_HLEN)
-#define RTL8152_TX_TIMEOUT	(HZ)
+#define RTL8152_TX_TIMEOUT	(5 * HZ)
 
 /* rtl8152 flags */
 enum rtl8152_flags {
-- 
1.9.3

