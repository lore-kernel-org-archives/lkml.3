Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaJMUQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:16:03 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:48538 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753735AbaJMUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:16:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2110:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:7652:7903:7904:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12555:12663:12740:13019:13071:13138:13141:13230:13231:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flag28_341dd9cd48339
X-Filterd-Recvd-Size: 4528
Message-ID: <1413231356.1287.18.camel@joe-AO725>
Subject: Re: [PATCH] Crypto: gf128mul : fixed a parentheses coding style
 issue
From: Joe Perches <joe@perches.com>
To: Michael Roocroft <mike.linux@btinternet.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2014 13:15:56 -0700
In-Reply-To: <543C3229.2090205@btinternet.com>
References: <1413146950-932-1-git-send-email-mike.linux@btinternet.com>
	 <1413154885.22149.49.camel@joe-AO725> <543C3229.2090205@btinternet.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 21:12 +0100, Michael Roocroft wrote:
> On 10/13/14 00:01, Joe Perches wrote:
> > On Sun, 2014-10-12 at 21:49 +0100, Mike Roocroft wrote:
> >> Fixed a coding style issue.
> > []
> >> diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
> > []
> >> @@ -97,7 +97,7 @@
> >>       the table above
> >>   */
> >>   
> >> -#define xx(p, q)	0x##p##q
> >> +#define xx(p, q)	(0x##p##q)
> >>   
> >>   #define xda_bbe(i) ( \
> >>   	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
> > I think that macro is pretty useless and nothing
> > but obfuscation now.
> >
> > The comment above it doesn't seem useful either.
> >
> > How about just removing and replacing the uses
> > like this?
> >
> > ---
> >   crypto/gf128mul.c | 27 ++++++++-------------------
> >   1 file changed, 8 insertions(+), 19 deletions(-)
> >
> > diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
> > index 5276607..90cf17d 100644
> > --- a/crypto/gf128mul.c
> > +++ b/crypto/gf128mul.c
> > @@ -88,29 +88,18 @@
> >   	q(0xf8), q(0xf9), q(0xfa), q(0xfb), q(0xfc), q(0xfd), q(0xfe), q(0xff) \
> >   }
> >   
> > -/*	Given the value i in 0..255 as the byte overflow when a field element
> > -    in GHASH is multiplied by x^8, this function will return the values that
> > -    are generated in the lo 16-bit word of the field value by applying the
> > -    modular polynomial. The values lo_byte and hi_byte are returned via the
> > -    macro xp_fun(lo_byte, hi_byte) so that the values can be assembled into
> > -    memory as required by a suitable definition of this macro operating on
> > -    the table above
> > -*/
> > -
> > -#define xx(p, q)	0x##p##q
> > -
> >   #define xda_bbe(i) ( \
> > -	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
> > -	(i & 0x20 ? xx(10, e0) : 0) ^ (i & 0x10 ? xx(08, 70) : 0) ^ \
> > -	(i & 0x08 ? xx(04, 38) : 0) ^ (i & 0x04 ? xx(02, 1c) : 0) ^ \
> > -	(i & 0x02 ? xx(01, 0e) : 0) ^ (i & 0x01 ? xx(00, 87) : 0) \
> > +	(i & 0x80 ? 0x4380 : 0) ^ (i & 0x40 ? 0x21c0 : 0) ^ \
> > +	(i & 0x20 ? 0x10e0 : 0) ^ (i & 0x10 ? 0x0870 : 0) ^ \
> > +	(i & 0x08 ? 0x0438 : 0) ^ (i & 0x04 ? 0x021c : 0) ^ \
> > +	(i & 0x02 ? 0x010e : 0) ^ (i & 0x01 ? 0x0087 : 0) \
> >   )
> >   
> >   #define xda_lle(i) ( \
> > -	(i & 0x80 ? xx(e1, 00) : 0) ^ (i & 0x40 ? xx(70, 80) : 0) ^ \
> > -	(i & 0x20 ? xx(38, 40) : 0) ^ (i & 0x10 ? xx(1c, 20) : 0) ^ \
> > -	(i & 0x08 ? xx(0e, 10) : 0) ^ (i & 0x04 ? xx(07, 08) : 0) ^ \
> > -	(i & 0x02 ? xx(03, 84) : 0) ^ (i & 0x01 ? xx(01, c2) : 0) \
> > +	(i & 0x80 ? 0xe100 : 0) ^ (i & 0x40 ? 0x7080 : 0) ^ \
> > +	(i & 0x20 ? 0x3840 : 0) ^ (i & 0x10 ? 0x1c20 : 0) ^ \
> > +	(i & 0x08 ? 0x0e10 : 0) ^ (i & 0x04 ? 0x0708 : 0) ^ \
> > +	(i & 0x02 ? 0x0384 : 0) ^ (i & 0x01 ? 0x01c2 : 0) \
> >   )
> >   
> >   static const u16 gf128mul_table_lle[256] = gf128mul_dat(xda_lle);
> >
> >
> >
> Hi there,

Hi Mike.

> I'm not really contributing anything other than getting code checkpatch clean, whilst
> I relearn C and get a feel for various parts of the kernel.

checkpatch cleanliness, while OK for some parts of the
kernel, should not be an end-goal.

checkpatch is really a tool to "check patches".

If you want to submit neatening only patches, please
do your changes in drivers/staging/

Otherwise, please look for code that isn't simply a
style neatening bit, but something that actively makes
reading the code easier, makes the object code smaller
or faster, reduces complexity, adds extensibility,
etc, etc...

cheers, Joe



