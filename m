Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3JVHeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:34:13 -0400
Received: from asix.com.tw ([210.243.224.51]:16711 "EHLO freebsd2.asix.com.tw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751178Ab3JVHeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:34:11 -0400
From: freddy@asix.com.tw
To: davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        allan@asix.com.tw, louis@asix.com.tw
Cc: Freddy Xin <freddy@asix.com.tw>
Subject: [PATCH 1/2] [PATCH] ax88179_178a: Correct the RX error definition in RX header
Date: Tue, 22 Oct 2013 15:32:10 +0800
Message-Id: <1382427131-2429-1-git-send-email-freddy@asix.com.tw>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Freddy Xin <freddy@asix.com.tw>

Correct the definition of AX_RXHDR_CRC_ERR and
AX_RXHDR_DROP_ERR. They are BIT29 and BIT31 in pkt_hdr
seperately.

Signed-off-by: Freddy Xin <freddy@asix.com.tw>
---
 drivers/net/usb/ax88179_178a.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 3569293..3bcd0d9 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -36,8 +36,8 @@
 #define AX_RXHDR_L4_TYPE_TCP			16
 #define AX_RXHDR_L3CSUM_ERR			2
 #define AX_RXHDR_L4CSUM_ERR			1
-#define AX_RXHDR_CRC_ERR			((u32)BIT(31))
-#define AX_RXHDR_DROP_ERR			((u32)BIT(30))
+#define AX_RXHDR_CRC_ERR			((u32)BIT(29))
+#define AX_RXHDR_DROP_ERR			((u32)BIT(31))
 #define AX_ACCESS_MAC				0x01
 #define AX_ACCESS_PHY				0x02
 #define AX_ACCESS_EEPROM			0x04
-- 
1.7.10.4

