Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaJ0SDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:03:31 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:38395 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbaJ0SDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:03:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEPAHOHTlRXQ3zJ/2dsb2JhbABcgw6BLLlDCwUBdJpDgR4XAX2EMC8jgRo3iEUBvGePB4Y0ilQdhDUFnWGWLoFHAYIxPC+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1] ipv4: remove set but unused variable sha
Date: Mon, 27 Oct 2014 19:03:22 +0100
Message-Id: <1414433002-29106-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned char *sha (source) was already in original git version
 but was never used.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/ipconfig.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 648fa14..a896da5 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -498,7 +498,7 @@ ic_rarp_recv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 	struct arphdr *rarp;
 	unsigned char *rarp_ptr;
 	__be32 sip, tip;
-	unsigned char *sha, *tha;		/* s for "source", t for "target" */
+	unsigned char *tha;		/* t for "target" */
 	struct ic_device *d;
 
 	if (!net_eq(dev_net(dev), &init_net))
@@ -549,7 +549,6 @@ ic_rarp_recv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 		goto drop_unlock;	/* should never happen */
 
 	/* Extract variable-width fields */
-	sha = rarp_ptr;
 	rarp_ptr += dev->addr_len;
 	memcpy(&sip, rarp_ptr, 4);
 	rarp_ptr += 4;
-- 
1.9.1

