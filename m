Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaFQD0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:26:03 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:51462 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754702AbaFQD0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:26:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13141:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: look07_515e4f5dfe452
X-Filterd-Recvd-Size: 2678
Message-ID: <1402975557.2797.8.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Warn on unnecessary void function return
 statements
From: Joe Perches <joe@perches.com>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Anish Bhatt <anish@chelsio.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Date: Mon, 16 Jun 2014 20:25:57 -0700
In-Reply-To: <CAK5sBcGurbiFvd7s5sd=HtRkdw0SydWVw3g7_zKBt_eJC+NGUw@mail.gmail.com>
References: <1401728316.5770.9.camel@joe-AO725>
	 <1402961300-17985-1-git-send-email-anish@chelsio.com>
	 <1402964898.11561.2.camel@joe-AO725> <539F8F62.4000805@chelsio.com>
	 <1402970429.2797.3.camel@joe-AO725>
	 <CAK5sBcGurbiFvd7s5sd=HtRkdw0SydWVw3g7_zKBt_eJC+NGUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 08:46 +0530, Sachin Kamat wrote:
> On Tue, Jun 17, 2014 at 7:30 AM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-06-16 at 17:44 -0700, Anish Bhatt wrote:
> >> My code has multiple exit lables:
> >> void function(void)
> >> {
> >>       ...
> >>
> >>       if (err1)
> >>               goto exit1;
> >>       ...
> >>       if (err2)
> >>               goto exit2;
> >>
> >>       ...
> >>       return; /* Good return, no errors */
> >> exit1:
> >>       printk(err1);
> >>       return;
> >> exit2:
> >>       printk(err2);
> >> }
> >>
> >> The single tabbed return was required to prevent the good return & err1
> >> messages cascading down. The extra exit label with a noop looks weird,
> >> but is passing checkpatch.pl --strict, so I will go with that, thanks.
> >> -Anish
> >>
> >
> > Hmm, those return uses seem reasonable
> > to me.
> >
> > Perhaps the test should warn only on
> > this specific 3 line sequence:
> >
> > [any line but a label]
> >         return;
> > }
> >
> > Andrew?  Anyone else?  Opinions?
> 
> It should warn only if the return is followed by a value like
> return 0; or return -EERROR_CODE; etc. and not just 'return;'

No.  The compiler gets to warn on those.
checkpatch isn't a compiler.

It's a code style verifying and sometimes an
API misuse checking tool.

In this case, using return at the bottom of a
void function like

void function(void)
{
	[code...]

	return;
}

is undesired and would generally be written as

void function(void)
{
	[code...]
}


