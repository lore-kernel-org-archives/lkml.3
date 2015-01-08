Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbbAHR4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:56:49 -0500
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:41092 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932356AbbAHR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:56:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,3,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1978:1981:2194:2196:2199:2200:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3291:3352:3865:3866:3867:3868:3871:4250:4321:4385:4418:4605:5007:6117:6119:6261:8603:9592:10012:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13069:13095:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:2:0
X-HE-Tag: act21_754b1e7b2874f
X-Filterd-Recvd-Size: 2265
Message-ID: <1420739803.11784.7.camel@perches.com>
Subject: [PATCH net-next] netfilter: nat_snmp_basic: Use generic dump
 facility
From: Joe Perches <joe@perches.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Jan 2015 09:56:43 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic facility instead of a static hex_dump routine.
Delete the now unused static routine.

Now emits the hex dump at KERN_DEBUG instead of default.

Shrinks the kernel ever so trivially.

$ size net/ipv4/netfilter/nf_nat_snmp_basic.o*
   text	   data	    bss	    dec	    hex	filename
   5948	    352	      8	   6308	   18a4	net/ipv4/netfilter/nf_nat_snmp_basic.o.defconfig.new
   5985	    352	      8	   6345	   18c9	net/ipv4/netfilter/nf_nat_snmp_basic.o.defconfig.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv4/netfilter/nf_nat_snmp_basic.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 7c67667..5c8d3b5 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -998,18 +998,6 @@ err_id_free:
  *
  *****************************************************************************/
 
-static void hex_dump(const unsigned char *buf, size_t len)
-{
-	size_t i;
-
-	for (i = 0; i < len; i++) {
-		if (i && !(i % 16))
-			printk("\n");
-		printk("%02x ", *(buf + i));
-	}
-	printk("\n");
-}
-
 /*
  * Parse and mangle SNMP message according to mapping.
  * (And this is the fucking 'basic' method).
@@ -1026,7 +1014,7 @@ static int snmp_parse_mangle(unsigned char *msg,
 	struct snmp_object *obj;
 
 	if (debug > 1)
-		hex_dump(msg, len);
+		print_hex_dump_bytes("", DUMP_PREFIX_NONE, msg, len);
 
 	asn1_open(&ctx, msg, len);
 


