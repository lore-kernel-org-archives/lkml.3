Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaKDVyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:54:51 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:62443 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaKDVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:54:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8SABRKWVRbsl9p/2dsb2JhbABagw6BLbsKBQF0misEAoEkFwEBAQEBfYRfI4EaN4hFAbwNjy+GN4l1ZB2ENQWeDpZSgUcBgjE8L4EGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH V2 net-next] esp4: remove assignment in if condition
Date: Tue,  4 Nov 2014 22:54:36 +0100
Message-Id: <1415138076-7036-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: remove blank line between set and test (suggested by Joe Perches).

 net/ipv4/esp4.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 360b565..d2bf02e 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -392,8 +392,10 @@ static int esp_input(struct xfrm_state *x, struct sk_buff *skb)
 	if (elen <= 0)
 		goto out;
 
-	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
+	err = skb_cow_data(skb, 0, &trailer);
+	if (err < 0)
 		goto out;
+
 	nfrags = err;
 
 	assoclen = sizeof(*esph);
-- 
1.9.3

