Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbaHVQwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:52:54 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33495 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159AbaHVQww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:52:52 -0400
X-IronPort-AV: E=Sophos;i="5.04,382,1406584800"; 
   d="scan'208";a="90643874"
Date: Fri, 22 Aug 2014 18:52:49 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        =?ISO-8859-15?Q?Manuel_Sch=F6lling?= <manuel.schoelling@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ioat: Use time_before()
In-Reply-To: <1408643084.23250.84.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1408221851510.2055@localhost6.localdomain6>
References: <1400789466-11156-1-git-send-email-manuel.schoelling@gmx.de>  <CAPcyv4gnMVHd6R=WuN84TLxrAgsBAq8u9_PcmpgD8QECZMZAQw@mail.gmail.com> <1408643084.23250.84.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1777988654-1408726370=:2055"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1777988654-1408726370=:2055
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 21 Aug 2014, Joe Perches wrote:

> On Thu, 2014-08-21 at 10:10 -0700, Dan Williams wrote:
> > On Thu, May 22, 2014 at 1:11 PM, Manuel Schölling
> > <manuel.schoelling@gmx.de> wrote:
> > > To be future-proof and for better readability the time comparisons are modified
> > > to use time_before() instead of plain, error-prone math.
> []
> > > diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> []
> > > @@ -735,7 +735,8 @@ int ioat2_check_space_lock(struct ioat2_dma_chan *ioat, int num_descs)
> > >          * called under bh_disabled so we need to trigger the timer
> > >          * event directly
> > >          */
> > > -       if (jiffies > chan->timer.expires && timer_pending(&chan->timer)) {
> > > +       if (time_before(chan->timer.expires, jiffies)
> > > +           && timer_pending(&chan->timer)) {
> > >                 struct ioatdma_device *device = chan->device;
> > 
> > Thanks, let's use time_is_before_jiffies() for this cleanup... I'll
> > fix up and apply.
> 
> There are thousands of uses of time_before( and time_after(
> with jiffies, and 6 years after being added, a little more
> than a dozen or so of time_is_[before|after]_jiffies.
> 
> I also think the "time_is_[before|after]_jiffies" macros are
> not very well named.
> 
> Using them is more text than using jiffies directly.
> There is a small benefit in argument ordering correctness.
> 
> 	time_after(jiffies, foo)
> 	time_is_after_jiffies(foo)
> 
> I'd rather just drop jiffies altogether
> 	time_is_after(foo)
> or maybe add and use
> 	jiffies_is_after(foo)

jiffies_is_after is very understandable.  The others seem to require some 
thought.

julia
--8323328-1777988654-1408726370=:2055--
