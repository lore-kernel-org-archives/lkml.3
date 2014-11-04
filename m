Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaKDT2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:28:37 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:6318 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbaKDT2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:28:36 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4SAKQnWVRbsl9p/2dsb2JhbABbgw6BLLp9BgEBAQEBBQF0miIEAoEkFwEBAQEBfYRfI4EaN4hFAb5ojzWGN4l1ZB2ENQWeB5ZPgUcBgjE8L4EGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] esp4: remove assignment in if condition
Date: Tue,  4 Nov 2014 20:28:31 +0100
Message-Id: <1415129311-12480-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/esp4.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 360b565..9dd66ee 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -392,8 +392,11 @@ static int esp_input(struct xfrm_state *x, struct sk_buff *skb)
 	if (elen <= 0)
 		goto out;
 
-	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
+	err = skb_cow_data(skb, 0, &trailer);
+
+	if (err < 0)
 		goto out;
+
 	nfrags = err;
 
 	assoclen = sizeof(*esph);
-- 
1.9.3

