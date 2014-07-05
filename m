Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbaGEUpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:45:20 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:56585 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756156AbaGEUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:45:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:334:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2393:2551:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4419:4470:4605:5007:6119:7652:7903:8527:10004:10400:10848:10946:11026:11232:11658:11914:12050:12296:12517:12519:12555:12740:13019:13095:13138:13161:13229:13231:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: run34_10e8b28fd355f
X-Filterd-Recvd-Size: 4959
Message-ID: <1404593114.6384.72.camel@joe-AO725>
Subject: [PATCH] vsprintf: Remove SPECIAL from pointer types
From: Joe Perches <joe@perches.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 05 Jul 2014 13:45:14 -0700
In-Reply-To: <alpine.LFD.2.11.1407052103130.15455@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1406290246120.15455@eddie.linux-mips.org>
	 <20140702.182807.1245632778216212860.davem@davemloft.net>
	 <alpine.LFD.2.11.1407030244230.15455@eddie.linux-mips.org>
	 <alpine.LFD.2.11.1407030331550.15455@eddie.linux-mips.org>
	 <1404356734.14741.18.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030423300.15455@eddie.linux-mips.org>
	 <1404364565.14741.26.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030637030.15455@eddie.linux-mips.org>
	 <1404368746.14741.36.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051529040.15455@eddie.linux-mips.org>
	 <1404576420.6384.41.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
	 <1404583739.6384.51.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051917480.15455@eddie.linux-mips.org>
	 <1404585099.6384.53.camel@joe-AO725>
	 <alpine.LFD.2.11.1407052103130.15455@eddie.linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because gcc issues a complaint about any pointer format with %#p,
remove the use of SPECIAL to prefix 0x to various pointer types.

There are no uses in the kernel tree of %#p.

This removes the capability added by commit 725fe002d315
("vsprintf: correctly handle width when '#' flag used in %#p format").

There are some incidental message logging output changes of %pa
uses with this change.  None are in seq output so there are no
api changes.

Signed-off-by: Joe Perches <joe@perches.com>
---

Fine by me, here...

On Sat, 2014-07-05 at 21:25 +0100, Maciej W. Rozycki wrote:
> On Sat, 5 Jul 2014, Joe Perches wrote:
> 
> > > > I don't think %#p is valid so it
> > > > shouldn't have been set by #.
> > > 
> > >  Huh?  As recently as last Wednesday you pointed me at the specific commit 
> > > from Grant that made it valid (GCC format complaints aside).
> > 
> > Those gcc complaints are precisely the thing
> > that makes it invalid.
> 
>  So enforce that in code then, clear the SPECIAL flag where appropriate 
> and do not try to handle it in one place while leaving other ones to 
> behave randomly (i.e. a supposedly fixed field width varies depending on 
> the two uppermost digits).  Please note that it's only your proposed 
> change that introduces that randomness, right now code does what's 
> supposed and documented to, except a bit inconsistently.
> 
> > I believe you're tilting at windmills.
> > 
> > Hey, it works sometimes.  Knock yourself out.
> 
>  I pointed out an inconsistency with the intent to propose a fix once a 
> consensus have been reached, one way or another.  And I think shifting the 
> inconsistency to a different place, which is what your proposal does, 
> isn't really a complete solution, although I do recognise the improvement.

 lib/vsprintf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6fe2c84..1cad65b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -632,7 +632,7 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	return string(buf, end, sym, spec);
 #else
 	spec.field_width = 2 * sizeof(void *);
-	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.flags |= SMALL | ZEROPAD;
 	spec.base = 16;
 
 	return number(buf, end, value, spec);
@@ -1165,18 +1165,18 @@ char *address_val(char *buf, char *end, const void *addr,
 {
 	unsigned long long num;
 
-	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.flags |= SMALL | ZEROPAD;
 	spec.base = 16;
 
 	switch (fmt[1]) {
 	case 'd':
 		num = *(const dma_addr_t *)addr;
-		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+		spec.field_width = sizeof(dma_addr_t) * 2;
 		break;
 	case 'p':
 	default:
 		num = *(const phys_addr_t *)addr;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		spec.field_width = sizeof(phys_addr_t) * 2;
 		break;
 	}
 
@@ -1259,7 +1259,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
+	int default_width = 2 * sizeof(void *);
 
 	if (!ptr && *fmt != 'K') {
 		/*



