Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaKEXgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:36:13 -0500
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:53872 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbaKEXgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:36:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3867:3868:3870:4250:4321:4385:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13161:13229:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dogs36_52e650a296e0c
X-Filterd-Recvd-Size: 3111
Message-ID: <1415230568.6634.36.camel@perches.com>
Subject: [PATCH net-next] net: esp: Convert NETDEBUG to pr_info
From: Joe Perches <joe@perches.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Nov 2014 15:36:08 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 64ce207306de ("[NET]: Make NETDEBUG pure printk wrappers")
originally had these NETDEBUG printks as always emitting.

Commit a2a316fd068c ("[NET]: Replace CONFIG_NET_DEBUG with sysctl")
added a net_msg_warn sysctl to these NETDEBUG uses.

Convert these NETDEBUG uses to normal pr_info calls.

This changes the output prefix from "ESP: " to include
"IPSec: " for the ipv4 case and "IPv6: " for the ipv6 case.

These output lines are now like the other messages in the files.

Other miscellanea:

Neaten the arithmetic spacing to be consistent with other
arithmetic spacing in the files.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv4/esp4.c | 10 +++++-----
 net/ipv6/esp6.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index d2bf02e..60173d4 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -603,12 +603,12 @@ static int esp_init_authenc(struct xfrm_state *x)
 		BUG_ON(!aalg_desc);
 
 		err = -EINVAL;
-		if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
+		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			NETDEBUG(KERN_INFO "ESP: %s digestsize %u != %hu\n",
-				 x->aalg->alg_name,
-				 crypto_aead_authsize(aead),
-				 aalg_desc->uinfo.auth.icv_fullbits/8);
+			pr_info("ESP: %s digestsize %u != %hu\n",
+				x->aalg->alg_name,
+				crypto_aead_authsize(aead),
+				aalg_desc->uinfo.auth.icv_fullbits / 8);
 			goto free_key;
 		}
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 83fc3a3..d21d7b2 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -544,12 +544,12 @@ static int esp_init_authenc(struct xfrm_state *x)
 		BUG_ON(!aalg_desc);
 
 		err = -EINVAL;
-		if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
+		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			NETDEBUG(KERN_INFO "ESP: %s digestsize %u != %hu\n",
-				 x->aalg->alg_name,
-				 crypto_aead_authsize(aead),
-				 aalg_desc->uinfo.auth.icv_fullbits/8);
+			pr_info("ESP: %s digestsize %u != %hu\n",
+				x->aalg->alg_name,
+				crypto_aead_authsize(aead),
+				aalg_desc->uinfo.auth.icv_fullbits / 8);
 			goto free_key;
 		}
 


