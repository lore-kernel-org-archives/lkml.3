Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaJ0PNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:13:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbaJ0PNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:13:36 -0400
Date: Mon, 27 Oct 2014 16:13:27 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141027151327.GE9734@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oded,

can you please test these patches with the KFD driver and make sure
nothing breaks for you? I really like this improvement and it would be
great to send it upstream for v3.19.

Thanks,

	Joerg

On Fri, Oct 24, 2014 at 12:34:30PM -0700, Jesse Barnes wrote:
> This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
> simply, rather than doing tricks with page refs and get_user_pages().
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  mm/memory.c | 1 +
>  mm/mmap.c   | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 1cc6bfb..969ff0c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3378,6 +3378,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(handle_mm_fault);
>  
>  #ifndef __PAGETABLE_PUD_FOLDED
>  /*
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7f85520..2ee7971 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2359,6 +2359,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
>  }
>  #endif
>  
> +EXPORT_SYMBOL_GPL(find_extend_vma);
> +
>  /*
>   * Ok - we have the memory areas we should free on the vma list,
>   * so release them, and do the vma updates.
> -- 
> 1.9.1
