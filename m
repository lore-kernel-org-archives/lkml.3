Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaEOXHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:07:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbaEOXHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:07:30 -0400
Date: Thu, 15 May 2014 16:07:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Add --strict test for kmalloc/kzalloc with
 multiply
Message-Id: <20140515160728.aa401aa7b21c88ea098ddc60@linux-foundation.org>
In-Reply-To: <1400195086.5058.26.camel@joe-AO725>
References: <1400024929.24350.76.camel@joe-AO725>
	<20140515155844.041ee0bc17aae5f3b8eacd70@linux-foundation.org>
	<1400195086.5058.26.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 16:04:46 -0700 Joe Perches <joe@perches.com> wrote:

> On Thu, 2014-05-15 at 15:58 -0700, Andrew Morton wrote:
> > On Tue, 13 May 2014 16:48:49 -0700 Joe Perches <joe@perches.com> wrote:
> > > Protect against sizeof overflows by preferring
> > > kmalloc_array and kcalloc to kmalloc/kzalloc
> > > with a sizeof multiply.
> []
> > > +# check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
> > > +		if ($^V && $^V ge 5.10.0 &&
> > > +		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
> > > +			my $oldfunc = $3;
> > > +			my $a1 = $4;
> > > +			my $a2 = $10;
> > > +			my $newfunc = "kmalloc_array";
> > > +			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
> > > +			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
> > > +				CHK("ALLOC_WITH_MULTIPLY",
> > > +				    "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr);
> > > +			}
> > > +		}
> > > +
> > 
> > Why hide this behind --strict?
> 
> Non-obvious CHK/--strict tests are less controversial.
> 
> The block above it
> "prefer foo = alloc(sizeof(*foo)) over foo = alloc(sizeof(struct bar))"
> used CHK so I copied it.
> 
> I've no objection to making it WARN instead,

I'd prefer that - this is one of my regular comment-on-during-review
things.

