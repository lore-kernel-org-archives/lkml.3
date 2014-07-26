Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaGZUBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:01:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaGZUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:01:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 062/109] r8152: fix r8152_csum_workaround function
Date: Sat, 26 Jul 2014 12:02:24 -0700
Message-Id: <20140726190225.744936488@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hayeswang <hayeswang@realtek.com>

[ Upstream commit a91d45f1a343188793d6f2bdf1a72c64015a8255 ]

The transport offset of the IPv4 packet should be fixed and wouldn't
be out of the hw limitation, so the r8152_csum_workaround() should
be used for IPv6 packets.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1361,7 +1361,7 @@ static void r8152_csum_workaround(struct
 		struct sk_buff_head seg_list;
 		struct sk_buff *segs, *nskb;
 
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO);
+		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs) || !segs)
 			goto drop;


