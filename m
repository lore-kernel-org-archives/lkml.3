Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaEOXEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:04:51 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:40451 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751654AbaEOXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:04:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:2897:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3868:3872:3874:4250:4321:5007:6119:7652:7903:8957:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12049:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: event94_ccecec531f2c
X-Filterd-Recvd-Size: 2042
Message-ID: <1400195086.5058.26.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Add --strict test for kmalloc/kzalloc with
 multiply
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 May 2014 16:04:46 -0700
In-Reply-To: <20140515155844.041ee0bc17aae5f3b8eacd70@linux-foundation.org>
References: <1400024929.24350.76.camel@joe-AO725>
	 <20140515155844.041ee0bc17aae5f3b8eacd70@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 15:58 -0700, Andrew Morton wrote:
> On Tue, 13 May 2014 16:48:49 -0700 Joe Perches <joe@perches.com> wrote:
> > Protect against sizeof overflows by preferring
> > kmalloc_array and kcalloc to kmalloc/kzalloc
> > with a sizeof multiply.
[]
> > +# check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
> > +		if ($^V && $^V ge 5.10.0 &&
> > +		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
> > +			my $oldfunc = $3;
> > +			my $a1 = $4;
> > +			my $a2 = $10;
> > +			my $newfunc = "kmalloc_array";
> > +			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
> > +			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
> > +				CHK("ALLOC_WITH_MULTIPLY",
> > +				    "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr);
> > +			}
> > +		}
> > +
> 
> Why hide this behind --strict?

Non-obvious CHK/--strict tests are less controversial.

The block above it
"prefer foo = alloc(sizeof(*foo)) over foo = alloc(sizeof(struct bar))"
used CHK so I copied it.

I've no objection to making it WARN instead,


