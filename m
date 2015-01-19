Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbbASHOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:14:01 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40522 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbASHN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:13:58 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J7DtG6003968, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 6/7] r8152: replace get_protocol with vlan_get_protocol
Date: Mon, 19 Jan 2015 15:13:36 +0800
Message-ID: <1394712342-15778-124-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-118-Taiwan-albertk@realtek.com>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vlan_get_protocol() has been defined and use it to replace
get_protocol().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f66ffbd..46440ed 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1342,18 +1342,6 @@ static struct tx_agg *r8152_get_tx_agg(struct r8152 *tp)
 	return agg;
 }
 
-static inline __be16 get_protocol(struct sk_buff *skb)
-{
-	__be16 protocol;
-
-	if (skb->protocol == htons(ETH_P_8021Q))
-		protocol = vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
-	else
-		protocol = skb->protocol;
-
-	return protocol;
-}
-
 /* r8152_csum_workaround()
  * The hw limites the value the transport offset. When the offset is out of the
  * range, calculate the checksum by sw.
@@ -1459,7 +1447,7 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 			goto unavailable;
 		}
 
-		switch (get_protocol(skb)) {
+		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			opts1 |= GTSENDV4;
 			break;
@@ -1490,7 +1478,7 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 			goto unavailable;
 		}
 
-		switch (get_protocol(skb)) {
+		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			opts2 |= IPV4_CS;
 			ip_protocol = ip_hdr(skb)->protocol;
-- 
2.1.0

