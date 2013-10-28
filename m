Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3J1L7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:59:06 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35711 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3J1L6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:58:36 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9SBwXZZ016707, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 4/5] net/usb/r8152: fix incorrect type in assignment
Date: Mon, 28 Oct 2013 19:58:13 +0800
Message-ID: <1382961494-2272-5-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
References: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct some declaration.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a711025..90bc105 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -309,22 +309,22 @@ enum rtl8152_flags {
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
@@ -878,7 +878,7 @@ static void write_bulk_callback(struct urb *urb)
 static void intr_callback(struct urb *urb)
 {
 	struct r8152 *tp;
-	__u16 *d;
+	__le16 *d;
 	int status = urb->status;
 	int res;
 
-- 
1.8.3.1

