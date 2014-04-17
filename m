Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaDQBso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:48:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48261 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaDQBsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:48:42 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 17 Apr 2014 10:49:11 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Steven King <sfking@fdwdc.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: [uClinux-dev] v3.15-rc1 slab allocator broken on m68knommu
 (coldfire)
Message-ID: <20140417014911.GA3284@js1304-P5Q-DELUXE>
References: <201404141745.44279.sfking@fdwdc.com>
 <201404160847.27300.sfking@fdwdc.com>
 <CAMuHMdV2zSWaDbHNv3QQeEgu26PQX9TWn7cHA=4U0YOK0bbExg@mail.gmail.com>
 <201404161044.11416.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404161044.11416.sfking@fdwdc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:44:11AM -0700, Steven King wrote:
> On Wednesday 16 April 2014 9:06:57 am Geert Uytterhoeven wrote:
> > Hi Steven,
> >
> > On Wed, Apr 16, 2014 at 5:47 PM, Steven King <sfking@fdwdc.com> wrote:
> > > --- a/mm/slab.c
> > > +++ b/mm/slab.c
> > > @@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache
> > > *cachep, return freelist;
> > >  }
> > >
> > > -static inline freelist_idx_t get_free_obj(struct page *page, unsigned
> > > char idx) +static inline freelist_idx_t get_free_obj(struct page *page,
> > > unsigned int idx) {
> > >         return ((freelist_idx_t *)page->freelist)[idx];
> > >  }
> > >
> > >  static inline void set_free_obj(struct page *page,
> > > -                                       unsigned char idx, freelist_idx_t
> > > val) +                                       unsigned int idx,
> > > freelist_idx_t val) {
> > >         ((freelist_idx_t *)(page->freelist))[idx] = val;
> > >  }
> > >
> > >
> > > then v3.15-rc1 will boot using the slab allocator.
> >
> > Is "idx" ever larger than 255?
> >
> > Gr{oetje,eeting}s,
> 
> Yes.  If I stick
> 
>         if (idx > 255)
>                 pr_info("%s %d\n", __func__, idx);
> 
> in get_free_obj and set_free_obj and see values for idx up into the 400s.

Hello,

Yes, it's my mistake. idx can be larger than 255 if freelist_idx_t is
unsigned short. So unsigned char idx isn't appropriate here. Your
system's PAGE_SIZE may be 2^13, so freelist_idx_t would be unsigned short
and idx will be larger than 255.

Your fix looks good to me, so could you send it quickly to Pekka with
some description? If you don't have enough time to do it, I can handle it.

Really thanks for notifying this issue.

Thanks.
