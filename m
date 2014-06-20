Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbaFTFXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:23:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:29525
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933667AbaFTFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:22:59 -0400
X-IronPort-AV: E=Sophos;i="5.01,512,1400018400"; 
   d="scan'208";a="67991449"
Date: Fri, 20 Jun 2014 07:22:56 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        benoit.taine@lip6.fr
Subject: Re: [PATCH] Coccinelle: Script to drop parenthesis in the return
 statements
In-Reply-To: <1403197152.9958.5.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1406200722120.1990@localhost6.localdomain6>
References: <20140619162954.GA4698@himangi-Dell>  <1403195662.7875.5.camel@joe-AO725>  <alpine.DEB.2.10.1406191848020.2078@hadrien> <1403197152.9958.5.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2014, Joe Perches wrote:

> On Thu, 2014-06-19 at 18:49 +0200, Julia Lawall wrote:
> > On Thu, 19 Jun 2014, Joe Perches wrote:
> > > On Thu, 2014-06-19 at 21:59 +0530, Himangi Saraogi wrote:
> > > > This script detects the use of a parenthesis around return value ot the
> > > > return statements and removes them as they are unnecessary and against
> > > > the CodingStyle. A new directory called checkpatch is added for semantic
> > > > patches that just make patches for what checkpatch does. This will help
> > > > developers having checkpatch problems, to run the semantic patches in this
> > > > directory on their code and fix some of them automatically.
> > >
> > > checkpatch already has --fix and --fix-inplace options that
> > > do something similar.
> > 
> > OK.  Then it is not worth adding coccinelle scripts for simple changes
> > like this one.
> > 
> > I guess that some of the more complex changes, like choosing an
> > appropriate error message function, checkpatch does not do?
> 
> I'm not quite sure what you're suggesting.
> 
> You mean choosing pr_err vs pr_notice or something
> like finding an active struct <foo> and converting
> printks to <foo>_<level>(&foo, fmt, ...)
> 
> from:
> {
> 	struct device *dev;
> 	...
> 	printk(KERN_ERR "msg", ...)
> to:
> 	dev_err(dev, "msg", ...)
> 
> checkpatch definitely can not do that.
> 
> Is it something else?

Yes, that is what I was thinking of.  Anyway, we can just test whether 
checkpatch --fix can d the change before proposing a semantic patch for 
it.

julia
