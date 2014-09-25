Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaIYS1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:27:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48296 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaIYS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:27:07 -0400
Date: Thu, 25 Sep 2014 11:27:02 -0700
From: josh@joshtriplett.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Support compiling out madvise and fadvise
Message-ID: <20140925182702.GB9360@cloud>
References: <20140922161109.GA25027@thin>
 <20140925172113.GA8209@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925172113.GA8209@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 01:21:13PM -0400, Johannes Weiner wrote:
> On Mon, Sep 22, 2014 at 09:11:16AM -0700, Josh Triplett wrote:
> > @@ -3,7 +3,7 @@
> >  #
> >  
> >  mmu-y			:= nommu.o
> > -mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o madvise.o memory.o mincore.o \
> > +mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o memory.o mincore.o \
> >  			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
> >  			   vmalloc.o pagewalk.o pgtable-generic.o
> >  
> > @@ -11,7 +11,7 @@ ifdef CONFIG_CROSS_MEMORY_ATTACH
> >  mmu-$(CONFIG_MMU)	+= process_vm_access.o
> >  endif
> >  
> > -obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
> > +obj-y			:= filemap.o mempool.o oom_kill.o \
> >  			   maccess.o page_alloc.o page-writeback.o \
> >  			   readahead.o swap.o truncate.o vmscan.o shmem.o \
> >  			   util.o mmzone.o vmstat.o backing-dev.o \
> > @@ -28,6 +28,9 @@ else
> >  	obj-y		+= bootmem.o
> >  endif
> >  
> > +ifdef CONFIG_MMU
> > +	obj-$(CONFIG_ADVISE_SYSCALLS)	+= fadvise.o madvise.o
> > +endif
> 
> That makes fadvise MMU-only, but I don't see why it should be.
> 
> Was that intentional?

No.  Fixed in v2; will send out momentarily.  Thanks!

- Josh Triplett
