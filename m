Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaIYEbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:31:11 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:57296 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750703AbaIYEbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:31:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pest55_440bfd07f895a
X-Filterd-Recvd-Size: 1773
Message-ID: <1411619466.4026.2.camel@joe-AO725>
Subject: Re: [PATCH] kernel: acctc.c: Fixed else if not generally userful
 after a break or return warning
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Elshad Mustafayev <elshadimo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Sep 2014 21:31:06 -0700
In-Reply-To: <E1XX0bN-00032o-0x@feisty.vs19.net>
References: <E1XX0bN-00032o-0x@feisty.vs19.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:13:45PM -0400, Elshad Mustafayev wrote:
> > Fixed a coding style issue.
[]
> > diff --git a/kernel/acct.c b/kernel/acct.c
[]
> > @@ -376,9 +376,8 @@ static comp2_t encode_comp2_t(u64 value)
> >  	if (exp > MAXEXP2) {
> >  		/* Overflow. Return largest representable number instead. */
> >  		return (1ul << (MANTSIZE2+EXPSIZE2-1)) - 1;
> > -	} else {
> > -		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
> >  	}
> > +	return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
> 
> Just what makes the replacement easier to follow?
> 	if (foo)
> 		return bar;
> 	else
> 		return baz;
> is no less idiomatic than
> 	if (foo)
> 		return bar;
> 	return baz;
> 
> Al, really annoyed by how the words "coding style issue" are getting used as
> a magic incantation...

I agree.

I'll see about updating checkpatch to avoid warning on

	if (foo)
		return bar;
	else
		return baz;


