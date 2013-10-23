Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3JWBSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:18:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:21073 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab3JWBSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:18:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311355286"
Date: Tue, 22 Oct 2013 18:18:14 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 11/13] NTB: convert to dmaengine_unmap_data
Message-ID: <20131023011814.GH11192@jonmason-lab>
References: <1382117733-16720-12-git-send-email-b.zolnierkie@samsung.com>
 <20131022210828.31348.41879.stgit@viggo.jf.intel.com>
 <CAPcyv4iWE=fETyu6zNuyy=RBKZ1-wSks5RjLqH3xfZmMwro5rA@mail.gmail.com>
 <20131022231235.GE11192@jonmason-lab>
 <CAA9_cmd08gFK3a5MwK8Ftxn9Ta9A=_vxvug8CPHh-HDUbPYETw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmd08gFK3a5MwK8Ftxn9Ta9A=_vxvug8CPHh-HDUbPYETw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 06:05:31PM -0700, Dan Williams wrote:
> On Tue, Oct 22, 2013 at 4:12 PM, Jon Mason <jon.mason@intel.com> wrote:
> > On Tue, Oct 22, 2013 at 02:29:36PM -0700, Dan Williams wrote:
> >> On Fri, Oct 18, 2013 at 6:06 PM, Jon Mason <jon.mason@intel.com> wrote:
> >> > On Fri, Oct 18, 2013 at 07:35:31PM +0200, Bartlomiej Zolnierkiewicz wrote:
> >> >> Use the generic unmap object to unmap dma buffers.
> >> >>
> >> >> As NTB can be compiled without DMA_ENGINE support add
> >> >
> >> > Seems like the stubs should be added outside of this patch.
> >>
> >> I think they are ok here as this is the only driver that uses them.
> >> The alternative is a new api patch without a user.
> >>
> >> > Also, the
> >> > comment implies that NTB could not be compiled without DMA_ENGINE
> >> > support before, which it could be.
> >>
> >> Hmm, I read it as "since NTB *can* be compiled without dmaengine here
> >> are some stubs".
> >
> > This poses an overall question of whether it would simply be better to
> > abstract all of the with/without DMA_ENGINE part and simply remap it
> > to memcpy if DMA_ENGINE is not set (or if the DMA engine is
> > hotplugged).  Of course, this is outside the scope of this patch.
> 
> That's at least the promise of async_memcpy() it does not care if a
> channel is there or not, but I think it is better if the client has a
> strict dma and non-dma path.  Hiding the dma details from the client
> seems to have been the wrong choice at least for raid.
> 
> > That is fine.  It can be like this in the short term.
> >
> > Thanks,
> > Jon
> 
> I'll take that as:
> 
> Acked-by: Jon Mason <jon.mason@intel.com>

Begrudgingly-Acked-by: Jon Mason <jon.mason@intel.com>

> 
> ...but holler if not.
