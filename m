Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3KSD0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:26:04 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:59027 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3KSDZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:25:31 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAJ3PSoj016327, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v4 4/4] r8152: fix incorrect type in assignment
Date: Tue, 19 Nov 2013 11:25:11 +0800
Message-ID: <1384831511-1625-5-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384831511-1625-1-git-send-email-hayeswang@realtek.com>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
 <1384831511-1625-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data from the hardware should be little endian. Correct the
declaration.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0ac2b53..fb35e6e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -307,22 +307,22 @@ enum rtl8152_flags {
 #define MCU_TYPE_USB			0x0000
 
 struct rx_desc {
-	u32 opts1;
+	__le32 opts1;
 #define RX_LEN_MASK			0x7fff
-	u32 opts2;
-	u32 opts3;
-	u32 opts4;
-	u32 opts5;
-	u32 opts6;
+	__le32 opts2;
+	__le32 opts3;
+	__le32 opts4;
+	__le32 opts5;
+	__le32 opts6;
 };
 
 struct tx_desc {
-	u32 opts1;
+	__le32 opts1;
 #define TX_FS			(1 << 31) /* First segment of a packet */
 #define TX_LS			(1 << 30) /* Final segment of a packet */
 #define TX_LEN_MASK		0x3ffff
 
-	u32 opts2;
+	__le32 opts2;
 #define UDP_CS			(1 << 31) /* Calculate UDP/IP checksum */
 #define TCP_CS			(1 << 30) /* Calculate TCP/IP checksum */
 #define IPV4_CS			(1 << 29) /* Calculate IPv4 checksum */
@@ -877,7 +877,7 @@ static void write_bulk_callback(struct urb *urb)
 static void intr_callback(struct urb *urb)
 {
 	struct r8152 *tp;
-	__u16 *d;
+	__le16 *d;
 	int status = urb->status;
 	int res;
 
-- 
1.8.3.1

