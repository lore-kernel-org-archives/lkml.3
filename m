Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaAFJeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:34:04 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:65415 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaAFJeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:34:01 -0500
Date: Mon, 6 Jan 2014 10:34:09 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: possible regression on 3.13 when calling flush_dcache_page
Message-ID: <20140106093408.GA2816@ldesroches-Latitude-E6320>
Mail-Followup-To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
References: <20131212143149.GI12099@ldesroches-Latitude-E6320>
 <20131212143618.GJ12099@ldesroches-Latitude-E6320>
 <20131213015909.GA8845@lge.com>
 <20131216144343.GD9627@ldesroches-Latitude-E6320>
 <20131218072117.GA2383@lge.com>
 <20131220080851.GC16592@ldesroches-Latitude-E6320>
 <20131223224435.GD16592@ldesroches-Latitude-E6320>
 <20131224063837.GA27156@lge.com>
 <20140103145404.GC18002@ldesroches-Latitude-E6320>
 <20140106002648.GC696@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140106002648.GC696@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:26:48AM +0900, Joonsoo Kim wrote:
> On Fri, Jan 03, 2014 at 03:54:04PM +0100, Ludovic Desroches wrote:
> > Hi,
> > 
> > On Tue, Dec 24, 2013 at 03:38:37PM +0900, Joonsoo Kim wrote:
> > 
> > [...]
> > 
> > > > > > > > I think that this commit may not introduce a bug. This patch remove one
> > > > > > > > variable on slab management structure and replace variable name. So there
> > > > > > > > is no functional change.
> > 
> > You are right, the commit given by git bisect was not the good one...
> > Since I removed other patches done on top of it, I thought it really was
> > this one but in fact it is 8456a64.
> 
> Okay. It seems more reasonable to me.
> I guess that this is the same issue with following link.
> http://lkml.org/lkml/2014/1/4/81
> 
> And, perhaps, that patch solves your problem. But I'm not sure that it is the
> best solution for this problem. I should discuss with slab maintainers.

Yes this patch solves my problem.

> 
> I will think about this problem more deeply and report the solution to you
> as soon as possible.

Ok thanks.

> 
> Thanks.
> 
> > 
> >  dd0f774  Fri Jan 3 12:33:55 2014 +0100  Revert "slab: remove useless
> > statement for checking pfmemalloc"  Ludovic Desroches 
> >  ff7487d  Fri Jan 3 12:32:33 2014 +0100  Revert "slab: rename
> > slab_bufctl to slab_freelist"  Ludovic Desroches 
> >  b963564  Fri Jan 3 12:32:13 2014 +0100  Revert "slab: fix to calm down
> > kmemleak warning"  Ludovic Desroches 
> >  3fcfe50  Fri Jan 3 12:30:32 2014 +0100  Revert "slab: replace
> > non-existing 'struct freelist *' with 'void *'"  Ludovic Desroches 
> >  750a795  Fri Jan 3 12:30:16 2014 +0100  Revert "memcg, kmem: rename
> > cache_from_memcg to cache_from_memcg_idx"  Ludovic Desroches 
> >  7e2de8a  Fri Jan 3 12:30:10 2014 +0100  mmc: atmel-mci: disable pdc
> > Ludovic Desroches
> > 
> > In this case I have the kernel oops. If I revert 8456a64 too, it
> > disappears.
> > 
> > I will try to test it on other devices because I couldn't reproduce it
> > with newer ones (but it's not the same ARM architecture so I would like
> > to see if it's also related to the device itself).
> > 
> > In attachment, there are the results of /proc/slabinfo before inserted the
> > sdio wifi module causing the oops.
> > 
> > Regards
> > 
> > Ludovic
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
