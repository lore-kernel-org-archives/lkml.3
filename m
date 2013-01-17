Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3AQJLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:11:33 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56295 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab3AQJLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:11:25 -0500
Message-ID: <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
 non-contiguous descriptors
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, martin.petersen@oracle.com,
        asias@redhat.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Date: Thu, 17 Jan 2013 09:11:20 +0000
In-Reply-To: <20130116231857.GU2668@htj.dyndns.org>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>
	 <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>
	 <50F64AC1.3040304@codeaurora.org>
	 <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
	 <20130116231857.GU2668@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 15:18 -0800, Tejun Heo wrote:
> On Wed, Jan 16, 2013 at 10:32:35AM +0000, James Bottomley wrote:
> > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > index 6b2fb87..ab88c5b 100644
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -809,7 +809,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
> >  			op(vaddr, len, dir);
> >  		}
> >  		offset = 0;
> > -		page++;
> > +		page = pfn_to_page(page_to_pfn(page) + 1);
> 
> Probably page = nth_page(page, 1) is the better form.

It's the same thing.

I'd actually prefer page = pfn_to_page(page_to_pfn(page) + 1); because
it makes the code look like the hack it is.  The preferred form for all
iterators like this should be to iterate over the pfn instead of a
pointer into the page arrays, because that will always work correctly no
matter how many weird and wonderful memory schemes we come up with.

James


