Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3AQKiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:38:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48452 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab3AQKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:38:03 -0500
Date: Thu, 17 Jan 2013 10:37:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        martin.petersen@oracle.com, asias@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
	non-contiguous descriptors
Message-ID: <20130117103742.GX23505@n2100.arm.linux.org.uk>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org> <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com> <50F64AC1.3040304@codeaurora.org> <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com> <20130116231857.GU2668@htj.dyndns.org> <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 09:11:20AM +0000, James Bottomley wrote:
> On Wed, 2013-01-16 at 15:18 -0800, Tejun Heo wrote:
> > On Wed, Jan 16, 2013 at 10:32:35AM +0000, James Bottomley wrote:
> > > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > > index 6b2fb87..ab88c5b 100644
> > > --- a/arch/arm/mm/dma-mapping.c
> > > +++ b/arch/arm/mm/dma-mapping.c
> > > @@ -809,7 +809,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
> > >  			op(vaddr, len, dir);
> > >  		}
> > >  		offset = 0;
> > > -		page++;
> > > +		page = pfn_to_page(page_to_pfn(page) + 1);
> > 
> > Probably page = nth_page(page, 1) is the better form.
> 
> It's the same thing.
> 
> I'd actually prefer page = pfn_to_page(page_to_pfn(page) + 1); because
> it makes the code look like the hack it is.  The preferred form for all
> iterators like this should be to iterate over the pfn instead of a
> pointer into the page arrays, because that will always work correctly no
> matter how many weird and wonderful memory schemes we come up with.

So, why don't we update the code to do that then?
