Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaIYQoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:44:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:23796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaIYQoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,598,1406617200"; 
   d="scan'208";a="479995789"
Date: Thu, 25 Sep 2014 21:46:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net_dma: fix memory leak in dma_pin_iocvec_pages
Message-ID: <20140925161600.GC1638@intel.com>
References: <87d2bdcask.wl%klamm@yandex-team.ru>
 <20140924045701.GR24663@intel.com>
 <CAPcyv4j5O-5n4YxC7qd05e_fniaofjf=8yfnqoehfJNYumZB4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j5O-5n4YxC7qd05e_fniaofjf=8yfnqoehfJNYumZB4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 11:27:06PM -0700, Dan Williams wrote:
> On Tue, Sep 23, 2014 at 9:57 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Wed, Sep 03, 2014 at 01:28:59PM +0400, Roman Gushchin wrote:
> >> dma_pin_iovec_pages() calls get_user_pages() for each iovec. If
> >> get_user_pages() returns a number smaller than the requested number,
> >> dma_pin_iovec_pages() calls dma_unpin_iovec_pages(). It releases
> >> previously allocated iovecs, but pages pinned by last get_user_pages()
> >> call remain unreleased.
> >> Fix this by calling put_page() for each such page.
> >>
> > Applied, thanks
> 
> Vinod, I have a patch in my queue that completely removes the remnants
> of NET_DMA.  It's been deprecated for more than a few cycles now
> without any reports to reinstate it.  Time to push the final removal
> patch.  I'll rebase it on top of this so it doesn't collide.

Okay, thanks for update. If you wnat I can remove it, so you don't need to
rebase.

-- 
~Vinod

