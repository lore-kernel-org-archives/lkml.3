Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaEWAIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:08:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:9242 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbaEWAH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:07:58 -0400
X-IronPort-AV: E=Sophos;i="4.98,890,1392159600"; 
   d="scan'208";a="63304148"
Date: Fri, 23 May 2014 08:07:38 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Himangi Saraogi <himangi774@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt/sparc: Introduce the use of the managed version of
 kzalloc
In-Reply-To: <20140522231434.GA9546@core.coreip.homeip.net>
Message-ID: <alpine.DEB.2.10.1405230806590.3738@hadrien>
References: <20140522193430.GA16315@himangi-Dell> <20140522194539.GA7708@core.coreip.homeip.net> <alpine.DEB.2.10.1405230700090.2606@hadrien> <20140522231434.GA9546@core.coreip.homeip.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2014, Dmitry Torokhov wrote:

> Hi Julia,
>
> On Fri, May 23, 2014 at 07:03:37AM +0800, Julia Lawall wrote:
> >
> >
> > On Thu, 22 May 2014, Dmitry Torokhov wrote:
> >
> > > Hi Himangi,
> > >
> > > On Fri, May 23, 2014 at 01:04:30AM +0530, Himangi Saraogi wrote:
> > > > This patch moves data allocated using kzalloc to managed data allocated
> > > > using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> > > > functions. Also the unnecessary labels are done away with.
> > >
> > > Please no more partial devm conversions. I am not interested in patches
> > > that change only 1 resource to be managed and leaving the rest as is.
> > >
> > > If you want to do devm conversion please do it if you convert all (or at
> > > least majority) of resource handling to managed resources.
> >
> > Sorry, I don't think we are clear on what is wanted.  Himangi's patches
> > convert everything where a devm function is already available (to our
> > knowledge).  Do you prefer that new devm functions be introduced?  On the
> > one hand, that is perhaps useful from a safety point of view.  On the
> > other hand, it could lead to a huge number of rarely used devm functions
> > that no one knows about and to a lot of code diversity.  So I don't know
> > what is the good solution.
>
> I strongly dislike changes that mix managed and non-managed resources in
> the same driver as it only leads to confusion: should this resource be
> freed or will it be freed automatically.
>
> I am applying patches that convert all (or almost all) resources in a
> driver into managed ones, but if that is not [currently] possible then
> those drivers are probably better left alone (maybe after additional
> audit).

OK, we will try to take that into account.  Are the new managed functoins
added to the devres docuentation?

thanks,
julia
