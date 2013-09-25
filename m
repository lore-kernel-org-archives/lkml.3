Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3IYTWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:22:07 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:34378 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754304Ab3IYTWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:22:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2917:2987:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4559:5007:6119:7652:7903:8957:10004:10400:10848:11232:11658:11914:12517:12519:12663:12679:12740:13069:13163:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toad48_8650b5f15eb48
X-Filterd-Recvd-Size: 2622
Message-ID: <1380136920.17366.15.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 12:22:00 -0700
In-Reply-To: <20130925161949.GZ13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
	 <20130925152432.GY13318@ZenIV.linux.org.uk>
	 <1380123344.17366.5.camel@joe-AO722>
	 <20130925161949.GZ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 17:19 +0100, Al Viro wrote:
> On Wed, Sep 25, 2013 at 08:35:44AM -0700, Joe Perches wrote:
> > I think Propercase should be discouraged.
> > ie: Qdisc et al.
> 
> Excuse me, but "Joe happens to think that something should be discouraged"
> is not a problem.  "Joe uses checkpatch.pl as force multiplier, recruiting
> hundreds of monkeys to enforce his personal preferences", OTOH, very much is.

Hah.  I'm still looking to acquire minions not monkeys,
and the force seems weak in that one.  Enthralling the
wannabe thralls isn't working...

CamelCase uses are not reported by default.

So not to worry Al, CamelCase is a --strict (CHECK) test
and almost no one ever uses --strict.  

> You are calling for ban on any mixed-case identifiers.  I see at least three
> cases where they can be legitimate:

If I was calling for anything remotely like a "ban",
I'd try to add it to CodingStyle.

> 	* labels a-la Enomem, etc.  I've been using those and I will
> keep doing so, checkpatch.pl and its users be damned.

Good on you.

> 	* enum members, to distinguish those from defines (first letter
> capitalized vs. all-caps).

Shrug.  There aren't that many uses of that style.

> 	* (local) typedefs for structs; I really don't like their use for
> anything non-local, but IMO they have their uses in cases like e.g.
> fs/binfmt_misc.c

Fine by me.  Don't use checkpatch.  No stress from me.

It's pretty obvious from fs/binfmt_misc.c that you have
your own taste.

$ scripts/checkpatch.pl -f --strict fs/binfmt_misc.c
[...]
total: 45 errors, 39 warnings, 10 checks, 725 lines checked


