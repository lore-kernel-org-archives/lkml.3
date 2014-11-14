Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaKNGMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:12:42 -0500
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:55831 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751146AbaKNGMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:12:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2899:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6261:7904:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13019:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cub16_51691095c0f30
X-Filterd-Recvd-Size: 1859
Message-ID: <1415945558.5912.10.camel@perches.com>
Subject: Re: [Cocci] spatch for trivial pointer comparison style?
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 22:12:38 -0800
In-Reply-To: <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6>
References: <1415908529.4223.11.camel@perches.com>
	 <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 07:06 +0100, Julia Lawall wrote:
> On Thu, 13 Nov 2014, Joe Perches wrote:
> 
> > I added a checkpatch entry for this.
> > Maybe some cocci test like this would be useful?
> > 
> > @@
> > type t;
> > t *p;
> > @@
> > -	p == NULL
> > +	!p
> > 
> > @@
> > type t;
> > t *p;
> > @@
> > -	p != NULL
> > +	p
> > 
> > @@
> > type t;
> > t *p;
> > @@
> > -	NULL == p
> > +	!p
> > 
> > @@
> > type t;
> > t *p;
> > @@
> > -	NULL != p
> > +	p
> 
> This was discussed many years ago.  I don't think that the change is 
> desirable in all cases.  There are functions like kmalloc where NULL means 
> failure and !p seems like the reasonable choice.  But there maybe other 
> cases where NULL is somehow a meaningful value.  
> 
> Here is a link to the part of the discussion:
> 
> https://lkml.org/lkml/2007/7/27/103

Yes, I agree with some of the things Al Viro said
there, but isn't 'type t; t *p;' a subset of
"expression *e"?



