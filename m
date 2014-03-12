Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaCLRXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:23:25 -0400
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:58297 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756351AbaCLRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:23:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2692:3138:3139:3140:3141:3142:3350:3865:3866:3872:5007:6261:10004:10026:10848:11658:11914:12296:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sink41_911248bdc6b16
X-Filterd-Recvd-Size: 1519
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/9] lg-vl600: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:37 -0700
Message-Id: <90c51467c9cc8ca3b8e4d74a63da42b28d8d51ec.1394644825.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/usb/lg-vl600.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/lg-vl600.c b/drivers/net/usb/lg-vl600.c
index acfcc32..8f37efd 100644
--- a/drivers/net/usb/lg-vl600.c
+++ b/drivers/net/usb/lg-vl600.c
@@ -210,7 +210,7 @@ static int vl600_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			 * (0x86dd) so Linux can understand it.
 			 */
 			if ((buf->data[sizeof(*ethhdr)] & 0xf0) == 0x60)
-				ethhdr->h_proto = __constant_htons(ETH_P_IPV6);
+				ethhdr->h_proto = htons(ETH_P_IPV6);
 		}
 
 		if (count) {
-- 
1.8.1.2.459.gbcd45b4.dirty

