Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbaELRFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:05:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:43263 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaELRFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:05:20 -0400
Date: Mon, 12 May 2014 20:05:04 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remap_file_pages: initialize populate before usage
Message-ID: <20140512170504.GA30120@node.dhcp.inet.fi>
References: <1399898454-14915-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399898454-14915-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 08:40:54AM -0400, Sasha Levin wrote:
> 'populate' wasn't initialized before being used in error paths,
> causing panics when mm_populate() would get called with invalid
> values.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

> ---
>  mm/mmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 84dcfc7..2a0e0a8 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2591,7 +2591,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>  
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma;
> -	unsigned long populate;
> +	unsigned long populate = 0;
>  	unsigned long ret = -EINVAL;
>  
>  	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
