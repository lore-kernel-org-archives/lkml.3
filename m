Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967315AbaFQV6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:58:25 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:33309 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965326AbaFQV6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:58:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:965:966:967:968:973:981:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4390:4395:5007:6119:7652:7875:7903:8660:9025:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13019:13069:13095:13148:13230:13311:13357:13845:14096:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sail97_2bc5c3782f42c
X-Filterd-Recvd-Size: 2734
Message-ID: <1403042299.2649.3.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree test
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>, Jesper Juhl <jj@chaosbits.net>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>
Date: Tue, 17 Jun 2014 14:58:19 -0700
In-Reply-To: <alpine.DEB.2.02.1406172331001.2055@localhost6.localdomain6>
References: <1403034199-9824-1-git-send-email-fabf@skynet.be>
	 <1403035539.2722.3.camel@joe-AO725>
	 <alpine.DEB.2.02.1406172331001.2055@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Jesper Juhl)

On Tue, 2014-06-17 at 23:33 +0200, Julia Lawall wrote:
> On Tue, 17 Jun 2014, Joe Perches wrote:
> > On Tue, 2014-06-17 at 21:43 +0200, Fabian Frederick wrote:
> > > This patch adds a trivial script warning on
> > > 
> > > if(foo)
> > > 	kfree(foo)
> > > 
> > > (based on checkpatch)
> > []
> > > diff --git a/scripts/coccinelle/free/cond_kfree.cocci b/scripts/coccinelle/free/cond_kfree.cocci
> > []
> > > +* if (E)
> > > +*	kfree@p(E);
> > 
> > You should probably add all of the unnecessary
> > conditional tests that checkpatch uses:
> > 
> > kfree
> > usb_free_urb
> > debugfs_remove
> > debugfs_remove_recursive
> 
> Personally, I would prefer that the message encourage the user to consider 
> whether it is necessary to call these functions with NULL as an argument 
> in any case.

Jesper quite awhile ago wrote:

https://lkml.org/lkml/2005/10/13/81

- Since kfree always checks for a NULL argument there's no reason to have an
additional check prior to calling kfree. It's redundant.
- In many cases gcc produce significantly smaller code without the redundant
check before the call.
- It's been shown in the past (in discussions on LKML) that it's generally a
win performance wise to avoid the extra NULL check even though it might save
a function call. Only when the NULL check avoids the function call in the vast
majority of cases and the code is in a hot path does it make sense to have it.
- This patch removes quite a few more source lines than it adds, cutting down
on the overall number of source lines is generally a good thing.
- This patch reduces the indentation level, which is nice when the kfree call
is inside some deeply nested construct.



