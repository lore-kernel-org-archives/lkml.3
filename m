Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaIYRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:21:21 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:35725 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbaIYRVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:21:20 -0400
Date: Thu, 25 Sep 2014 13:21:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Support compiling out madvise and fadvise
Message-ID: <20140925172113.GA8209@cmpxchg.org>
References: <20140922161109.GA25027@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922161109.GA25027@thin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:11:16AM -0700, Josh Triplett wrote:
> @@ -3,7 +3,7 @@
>  #
>  
>  mmu-y			:= nommu.o
> -mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o madvise.o memory.o mincore.o \
> +mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o memory.o mincore.o \
>  			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
>  			   vmalloc.o pagewalk.o pgtable-generic.o
>  
> @@ -11,7 +11,7 @@ ifdef CONFIG_CROSS_MEMORY_ATTACH
>  mmu-$(CONFIG_MMU)	+= process_vm_access.o
>  endif
>  
> -obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
> +obj-y			:= filemap.o mempool.o oom_kill.o \
>  			   maccess.o page_alloc.o page-writeback.o \
>  			   readahead.o swap.o truncate.o vmscan.o shmem.o \
>  			   util.o mmzone.o vmstat.o backing-dev.o \
> @@ -28,6 +28,9 @@ else
>  	obj-y		+= bootmem.o
>  endif
>  
> +ifdef CONFIG_MMU
> +	obj-$(CONFIG_ADVISE_SYSCALLS)	+= fadvise.o madvise.o
> +endif

That makes fadvise MMU-only, but I don't see why it should be.

Was that intentional?
