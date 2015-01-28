Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbbA1UfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:35:06 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:49211 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755964AbbA1UfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:00 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2196:2199:2393:2538:2559:2562:3138:3139:3140:3141:3142:3351:3865:3868:4385:5007:6119:6261:7903:7904:9592:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: class96_341a85dfa7617
X-Filterd-Recvd-Size: 2229
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] dvb_net: Use vsprintf %pM extension to print Ethernet addresses
Date: Wed, 28 Jan 2015 10:05:50 -0800
Message-Id: <5e0ccf5c0cf308317c79f5497d7eb63adca72e44.1422468185.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1422468185.git.joe@perches.com>
References: <cover.1422468185.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for more macros, so remove them and use the kernel extension.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index e4041f0..ff79b0b 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -90,9 +90,6 @@ static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 
 #ifdef ULE_DEBUG
 
-#define MAC_ADDR_PRINTFMT "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x"
-#define MAX_ADDR_PRINTFMT_ARGS(macap) (macap)[0],(macap)[1],(macap)[2],(macap)[3],(macap)[4],(macap)[5]
-
 #define isprint(c)	((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
 
 static void hexdump( const unsigned char *buf, unsigned short len )
@@ -700,8 +697,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 
 					if (drop) {
 #ifdef ULE_DEBUG
-						dprintk("Dropping SNDU: MAC destination address does not match: dest addr: "MAC_ADDR_PRINTFMT", dev addr: "MAC_ADDR_PRINTFMT"\n",
-							MAX_ADDR_PRINTFMT_ARGS(priv->ule_skb->data), MAX_ADDR_PRINTFMT_ARGS(dev->dev_addr));
+						dprintk("Dropping SNDU: MAC destination address does not match: dest addr: %pM, dev addr: %pM\n",
+							priv->ule_skb->data, dev->dev_addr);
 #endif
 						dev_kfree_skb(priv->ule_skb);
 						goto sndu_done;
-- 
2.1.2

