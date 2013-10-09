Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3JIRtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:49:47 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:56207 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920Ab3JIRtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:49:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2740:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:5007:6120:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coast64_8f3be2c52a847
X-Filterd-Recvd-Size: 1977
Message-ID: <1381340983.2050.17.camel@joe-AO722>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>
Date: Wed, 09 Oct 2013 10:49:43 -0700
In-Reply-To: <20131009163053.GF22495@htj.dyndns.org>
References: <1381296747.2040.17.camel@joe-AO722>
	 <20131009054335.GA3525@kroah.com> <1381299404.2040.19.camel@joe-AO722>
	 <20131009065404.GA7005@kroah.com> <1381302282.2050.1.camel@joe-AO722>
	 <20131009163053.GF22495@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 12:30 -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 09, 2013 at 12:04:42AM -0700, Joe Perches wrote:
> > > > > > 	devm_kzalloc
> > > > > > 	devm_kcalloc
> > > > > > 	devm_kmalloc_array
> > > > > > 
> > > > > > Add gfp.h to device.h for the newly added static inlines.
> ...
> > Unless Tejun has an objection soon, yes.
> 
> Do we really need devm_kmalloc_array() for devm interface?  The
> reasonsing behind only having kzalloc was that it's not worthwhile
> skipping zeroing for stuff happening during driver init/exit paths.
> The resource management overhead itself is already significant and
> unscalable compared to the raw cost of alloc/free and the interface
> isn't supposed to be used in super-hot paths.  Shouldn't
> devm_kzalloc() and devm_kcalloc() be enough?

I think API symmetry is a good thing and I think
that API dissymmetry is not a good thing when the
creation and support cost is very low.


