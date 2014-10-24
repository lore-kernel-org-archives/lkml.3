Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaJXWsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:48:39 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:33808 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaJXWsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:48:38 -0400
Date: Sat, 25 Oct 2014 01:45:37 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, hughd@google.com, riel@redhat.com,
        mgorman@suse.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH 03/10] mm: convert i_mmap_mutex to rwsem
Message-ID: <20141024224537.GA21108@node.dhcp.inet.fi>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
 <1414188380-17376-4-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414188380-17376-4-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:06:13PM -0700, Davidlohr Bueso wrote:
> diff --git a/mm/fremap.c b/mm/fremap.c
> index 72b8fa3..11ef7ec 100644
> --- a/mm/fremap.c
> +++ b/mm/fremap.c
> @@ -238,13 +238,13 @@ get_write_lock:
>  			}
>  			goto out_freed;
>  		}
> -		mutex_lock(&mapping->i_mmap_mutex);
> +		i_mmap_lock_write(mapping);
>  		flush_dcache_mmap_lock(mapping);
>  		vma->vm_flags |= VM_NONLINEAR;
>  		vma_interval_tree_remove(vma, &mapping->i_mmap);
>  		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
>  		flush_dcache_mmap_unlock(mapping);
> -		mutex_unlock(&mapping->i_mmap_mutex);
> +		i_mmap_unlock_write(mapping);
>  	}
>  
>  	if (vma->vm_flags & VM_LOCKED) {

This should go to previous patch.

-- 
 Kirill A. Shutemov
