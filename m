Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3JVBuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 21:50:01 -0400
Received: from asix.com.tw ([113.196.140.82]:13218 "EHLO freebsd2.asix.com.tw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752736Ab3JVBtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 21:49:51 -0400
X-Greylist: delayed 66904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2013 21:49:50 EDT
From: freddy@asix.com.tw
To: davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        allan@asix.com.tw, louis@asix.com.tw
Cc: Freddy Xin <freddy@asix.com.tw>
Subject: [PATCH 1/1] [PATCH resubmit] ax88179_178a: Correct the RX error definition in RX header
Date: Tue, 22 Oct 2013 09:47:29 +0800
Message-Id: <1382406449-2041-1-git-send-email-freddy@asix.com.tw>
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

