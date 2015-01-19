Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbbASHOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:14:07 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40525 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbASHOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:14:04 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J7Dx6f003978, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 7/7] r8152: use BIT macro
Date: Mon, 19 Jan 2015 15:13:37 +0800
Message-ID: <1394712342-15778-125-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-118-Taiwan-albertk@realtek.com>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BIT macro to replace (1 << bits).

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 46440ed..c3a0224 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -489,16 +489,16 @@ struct rx_desc {
 #define RX_LEN_MASK			0x7fff
 
 	__le32 opts2;
-#define RD_UDP_CS			(1 << 23)
-#define RD_TCP_CS			(1 << 22)
-#define RD_IPV6_CS			(1 << 20)
-#define RD_IPV4_CS			(1 << 19)
+#define RD_UDP_CS			BIT(23)
+#define RD_TCP_CS			BIT(22)
+#define RD_IPV6_CS			BIT(20)
+#define RD_IPV4_CS			BIT(19)
 
 	__le32 opts3;
-#define IPF				(1 << 23) /* IP checksum fail */
-#define UDPF				(1 << 22) /* UDP checksum fail */
-#define TCPF				(1 << 21) /* TCP checksum fail */
-#define RX_VLAN_TAG			(1 << 16)
+#define IPF				BIT(23) /* IP checksum fail */
+#define UDPF				BIT(22) /* UDP checksum fail */
+#define TCPF				BIT(21) /* TCP checksum fail */
+#define RX_VLAN_TAG			BIT(16)
 
 	__le32 opts4;
 	__le32 opts5;
@@ -507,24 +507,24 @@ struct rx_desc {
 
 struct tx_desc {
 	__le32 opts1;
-#define TX_FS			(1 << 31) /* First segment of a packet */
-#define TX_LS			(1 << 30) /* Final segment of a packet */
-#define GTSENDV4		(1 << 28)
-#define GTSENDV6		(1 << 27)
+#define TX_FS			BIT(31) /* First segment of a packet */
+#define TX_LS			BIT(30) /* Final segment of a packet */
+#define GTSENDV4		BIT(28)
+#define GTSENDV6		BIT(27)
 #define GTTCPHO_SHIFT		18
 #define GTTCPHO_MAX		0x7fU
 #define TX_LEN_MAX		0x3ffffU
 
 	__le32 opts2;
-#define UDP_CS			(1 << 31) /* Calculate UDP/IP checksum */
-#define TCP_CS			(1 << 30) /* Calculate TCP/IP checksum */
-#define IPV4_CS			(1 << 29) /* Calculate IPv4 checksum */
-#define IPV6_CS			(1 << 28) /* Calculate IPv6 checksum */
+#define UDP_CS			BIT(31) /* Calculate UDP/IP checksum */
+#define TCP_CS			BIT(30) /* Calculate TCP/IP checksum */
+#define IPV4_CS			BIT(29) /* Calculate IPv4 checksum */
+#define IPV6_CS			BIT(28) /* Calculate IPv6 checksum */
 #define MSS_SHIFT		17
 #define MSS_MAX			0x7ffU
 #define TCPHO_SHIFT		17
 #define TCPHO_MAX		0x7ffU
-#define TX_VLAN_TAG			(1 << 16)
+#define TX_VLAN_TAG		BIT(16)
 };
 
 struct r8152;
-- 
2.1.0

