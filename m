Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3JOO3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:29:38 -0400
Received: from mailrelay-out2.netcologne.de ([81.173.193.132]:57719 "EHLO
	mailrelay-out2.netcologne.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab3JOO3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:29:18 -0400
From: =?iso-8859-15?Q?Kelleter=2C_G=FCnther?= <GKelleter@datus.com>
To: "andrew.hendry@gmail.com" <andrew.hendry@gmail.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] X.25: Fix address field length calculation
Thread-Topic: [PATCH] X.25: Fix address field length calculation
Thread-Index: AQHOybLnty+s/FnB5kKUVGTJOhUv6w==
Date: Tue, 15 Oct 2013 14:29:06 +0000
Message-ID: <525D5131.9070007@datus.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.52.21.9]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <01736E88829C1B4A9589D66039BC9A5E@datus.local>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-purgate-ID: 153929::1381847355-00000593-E31637E5/0-0/0-0
X-purgate: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.

Signed-off-by: Guenther Kelleter <gkelleter@datus.com>
---
Wrong length calculation leads to rejection of CALL ACCEPT packets.

 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 45a3ab5..2daf224 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
 	}
  	len = *skb->data;
-	needed = 1 + (len >> 4) + (len & 0x0f);
+	needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
  	if (!pskb_may_pull(skb, needed)) {
 		/* packet is too short to hold the addresses it claims
-- 
1.8.3.4.71.g0878476
