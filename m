Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3JIHEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:04:47 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:40223 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756441Ab3JIHEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:04:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3874:4250:4321:5007:6119:6120:6691:7652:7903:8603:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: talk73_295a920c4db16
X-Filterd-Recvd-Size: 2404
Message-ID: <1381302282.2050.1.camel@joe-AO722>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>
Date: Wed, 09 Oct 2013 00:04:42 -0700
In-Reply-To: <20131009065404.GA7005@kroah.com>
References: <1381296747.2040.17.camel@joe-AO722>
	 <20131009054335.GA3525@kroah.com> <1381299404.2040.19.camel@joe-AO722>
	 <20131009065404.GA7005@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 23:54 -0700, Greg KH wrote:
> On Tue, Oct 08, 2013 at 11:16:44PM -0700, Joe Perches wrote:
> > On Tue, 2013-10-08 at 22:43 -0700, Greg KH wrote:
> > > On Tue, Oct 08, 2013 at 10:32:27PM -0700, Joe Perches wrote:
> > > > Currently, devm_ managed memory only supports kzalloc.
> > > > 
> > > > Convert the devm_kzalloc implementation to devm_kmalloc
> > > > and remove the complete memset to 0 but still set the
> > > > initial struct devres header and whatever padding before
> > > > data to 0.
> > > > 
> > > > Add the other normal alloc variants as static inlines with
> > > > __GFP_ZERO added to the gfp flag where appropriate:
> > > > 
> > > > 	devm_kzalloc
> > > > 	devm_kcalloc
> > > > 	devm_kmalloc_array
> > > > 
> > > > Add gfp.h to device.h for the newly added static inlines.
> > > > 
> > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > > ---
> > > >  drivers/base/devres.c  | 27 ++++++++++++++++-----------
> > > >  include/linux/device.h | 21 +++++++++++++++++++--
> > > >  2 files changed, 35 insertions(+), 13 deletions(-)
> > > 
> > > Makes sense to me, does this let other drivers start to use this where
> > > they were not able to in the past?
> > 
> > Yes.
> > 
> > There are some existing uses of devm_kzalloc(dev, n*size, gfp)
> > that could/should be converted.
> 
> Ok, great, want me to take the "RFC" off of this and apply it to my
> tree?

Unless Tejun has an objection soon, yes.


