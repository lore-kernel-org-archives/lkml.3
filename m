Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaJBPyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:54:49 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:49135 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaJBPyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:54:47 -0400
MIME-Version: 1.0
In-Reply-To: <1412264685-3368-1-git-send-email-paulmcquad@gmail.com>
References: <1412264685-3368-1-git-send-email-paulmcquad@gmail.com>
Date: Thu, 2 Oct 2014 19:54:46 +0400
Message-ID: <CAMo8BfKvvGg7QAH1GqGH98Qsw9v8=Ok0cV+uxKL5RP97p--KpQ@mail.gmail.com>
Subject: Re: [PATCH] mm: highmem remove 3 errors
From: Max Filippov <jcmvbkbc@gmail.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 7:44 PM, Paul McQuade <paulmcquad@gmail.com> wrote:
> pointers should be foo *bar or (foo *)
>
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  mm/highmem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/highmem.c b/mm/highmem.c
> index 123bcd3..f6dae74 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -130,7 +130,7 @@ unsigned int nr_free_highpages (void)
>  static int pkmap_count[LAST_PKMAP];
>  static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
>
> -pte_t * pkmap_page_table;
> +pte_t *pkmap_page_table;
>
>  /*
>   * Most architectures have no use for kmap_high_get(), so let's abstract
> @@ -291,7 +291,7 @@ void *kmap_high(struct page *page)
>         pkmap_count[PKMAP_NR(vaddr)]++;
>         BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
>         unlock_kmap();
> -       return (void*) vaddr;
> +       return (void *) vaddr;

checkpatch suggests that
CHECK: No space is necessary after a cast

>  }
>
>  EXPORT_SYMBOL(kmap_high);
> @@ -318,7 +318,7 @@ void *kmap_high_get(struct page *page)
>                 pkmap_count[PKMAP_NR(vaddr)]++;
>         }
>         unlock_kmap_any(flags);
> -       return (void*) vaddr;
> +       return (void *) vaddr;

Here as well.

-- 
Thanks.
-- Max
