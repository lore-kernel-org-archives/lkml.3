Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaAPXWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:22:19 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:33223 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaAPXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:22:17 -0500
Date: Thu, 16 Jan 2014 15:22:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmstat: Do not display stats for TLB flushes unless
 debugging
In-Reply-To: <20140116111205.GN4963@suse.de>
Message-ID: <alpine.DEB.2.02.1401161515540.4182@chino.kir.corp.google.com>
References: <1389278098-27154-1-git-send-email-mgorman@suse.de> <1389278098-27154-2-git-send-email-mgorman@suse.de> <20140116111205.GN4963@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Mel Gorman wrote:

> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 7249614..def5dd2 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -851,12 +851,14 @@ const char * const vmstat_text[] = {
>  	"thp_zero_page_alloc",
>  	"thp_zero_page_alloc_failed",
>  #endif
> +#ifdef CONFIG_DEBUG_TLBFLUSH
>  #ifdef CONFIG_SMP
>  	"nr_tlb_remote_flush",
>  	"nr_tlb_remote_flush_received",
> -#endif
> +#endif /* CONFIG_SMP */
>  	"nr_tlb_local_flush_all",
>  	"nr_tlb_local_flush_one",
> +#endif /* CONFIG_DEBUG_TLBFLUSH */
>  
>  #endif /* CONFIG_VM_EVENTS_COUNTERS */
>  };

Hmm, so why are NR_TLB_REMOTE_FLUSH{,_RECEIVED} defined for !CONFIG_SMP in 
linux-next?
