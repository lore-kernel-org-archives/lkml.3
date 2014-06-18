Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaFRPXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaFRPXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:23:17 -0400
Date: Wed, 18 Jun 2014 17:22:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, rientjes@google.com, cl@linux.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fork: dup_mm: init vm stat counters under mmap_sem
Message-ID: <20140618152209.GA14818@redhat.com>
References: <1403098391-24546-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403098391-24546-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Vladimir Davydov wrote:
>
> @@ -365,7 +365,12 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	 */
>  	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
>  
> +	mm->total_vm = oldmm->total_vm;
>  	mm->locked_vm = 0;
> +	mm->pinned_vm = 0;
> +	mm->shared_vm = oldmm->shared_vm;
> +	mm->exec_vm = oldmm->exec_vm;
> +	mm->stack_vm = oldmm->stack_vm;
>  	mm->mmap = NULL;
>  	mm->vmacache_seqnum = 0;
>  	mm->map_count = 0;

I think the patch is fine.


But perhaps this deserves more cleanups, with or without this patch
the initialization does not look consistent. dup_mmap() nullifies
locked_vm/pinned_vm/mmap/map_count while mm_init() clears core_state/
nr_ptes/rss_stat.

Oleg.

