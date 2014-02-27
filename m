Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaB0VXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:23:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaB0VXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:23:51 -0500
Date: Thu, 27 Feb 2014 13:23:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: call vma_adjust_trans_huge() only for
 thp-enabled vma
Message-Id: <20140227132350.9378977e0ccbb3a7cf74ee18@linux-foundation.org>
In-Reply-To: <1393475977-3381-4-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1393475977-3381-4-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 23:39:37 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> vma_adjust() is called also for vma(VM_HUGETLB) and it could happen that
> we happen to try to split hugetlbfs hugepage. So exclude the possibility.
> 

It would be nice to have a more complete changelog here please.  Under
what circumstances does this cause problems and what are the
user-observable effects?

> --- next-20140220.orig/mm/mmap.c
> +++ next-20140220/mm/mmap.c
> @@ -772,7 +772,8 @@ again:			remove_next = 1 + (end > next->vm_end);
>  		}
>  	}
>  
> -	vma_adjust_trans_huge(vma, start, end, adjust_next);
> +	if (transparent_hugepage_enabled(vma))
> +		vma_adjust_trans_huge(vma, start, end, adjust_next);
>  
>  	anon_vma = vma->anon_vma;
>  	if (!anon_vma && adjust_next)
> -- 
> 1.8.5.3
