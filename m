Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3CTWCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:02:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CTWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:02:50 -0400
Date: Wed, 20 Mar 2013 15:02:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hampson, Steven T" <steven.t.hampson@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH} mm: Merging memory blocks resets mempolicy
Message-Id: <20130320150248.116db8557253509972bcceda@linux-foundation.org>
In-Reply-To: <CD6BFEA8.10FFB%steven.t.hampson@intel.com>
References: <CD6BFEA8.10FFB%steven.t.hampson@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013 06:13:42 +0000 "Hampson, Steven T" <steven.t.hampson@intel.com> wrote:

> Using mbind to change the mempolicy to MPOL_BIND on several adjacent
> mmapped blocks
> may result in a reset of the mempolicy to MPOL_DEFAULT in vma_adjust.
> 
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -820,7 +820,7 @@ again:			remove_next = 1 + (end > next->vm_end);
>  		if (next->anon_vma)
>  			anon_vma_merge(vma, next);
>  		mm->map_count--;
> -		mpol_put(vma_policy(next));
> +		vma_set_policy(vma, vma_policy(next));
>  		kmem_cache_free(vm_area_cachep, next);
>  		/*
>  		 * In mprotect's case 6 (see comments on vma_merge),

Is this missing an mpol_put(vma_policy(vma))?
