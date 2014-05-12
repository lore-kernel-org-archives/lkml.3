Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaELRyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:54:40 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:60994 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932385AbaELRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:54:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KABQKcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0qFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:54:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/xfrm/xfrm_output.c: move EXPORT_SYMBOL
Message-Id: <20140512195434.ae5e323fe8394354b224a03e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
"WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable"

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/xfrm/xfrm_output.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 3bb2cdc..c51e8f7b 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -199,6 +199,7 @@ int xfrm_output(struct sk_buff *skb)
 
 	return xfrm_output2(skb);
 }
+EXPORT_SYMBOL_GPL(xfrm_output);
 
 int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
@@ -213,6 +214,7 @@ int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 		return -EAFNOSUPPORT;
 	return inner_mode->afinfo->extract_output(x, skb);
 }
+EXPORT_SYMBOL_GPL(xfrm_inner_extract_output);
 
 void xfrm_local_error(struct sk_buff *skb, int mtu)
 {
@@ -233,7 +235,4 @@ void xfrm_local_error(struct sk_buff *skb, int mtu)
 	afinfo->local_error(skb, mtu);
 	xfrm_state_put_afinfo(afinfo);
 }
-
-EXPORT_SYMBOL_GPL(xfrm_output);
-EXPORT_SYMBOL_GPL(xfrm_inner_extract_output);
 EXPORT_SYMBOL_GPL(xfrm_local_error);
-- 
1.9.1
