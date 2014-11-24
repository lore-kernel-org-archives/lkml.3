Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaKXLcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaKXLcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:32:31 -0500
Date: Mon, 24 Nov 2014 13:32:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Atzm Watanabe <atzm@stratosphere.co.jp>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tom Herbert <therbert@google.com>, netdev@vger.kernel.org
Subject: [PATCH] af_packet: fix sparse warning
Message-ID: <1416828696-3989-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

af_packet produces lots of these:
	net/packet/af_packet.c:384:39: warning: incorrect type in return expression (different modifiers)
	net/packet/af_packet.c:384:39:    expected struct page [pure] *
	net/packet/af_packet.c:384:39:    got struct page *

this seems to be because sparse does not realize that _pure
refers to function, not the returned pointer.

Tweak code slightly to avoid the warning.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4a877e..586229a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -378,7 +378,7 @@ static void unregister_prot_hook(struct sock *sk, bool sync)
 		__unregister_prot_hook(sk, sync);
 }
 
-static inline __pure struct page *pgv_to_page(void *addr)
+static inline struct page * __pure pgv_to_page(void *addr)
 {
 	if (is_vmalloc_addr(addr))
 		return vmalloc_to_page(addr);
-- 
MST
