Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3DGKOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 06:14:00 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:57429 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144Ab3DGKN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 06:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <1365326292-2761-1-git-send-email-k80ck80c@gmail.com>
References: <1365326292-2761-1-git-send-email-k80ck80c@gmail.com>
Date: Sun, 7 Apr 2013 03:13:57 -0700
Message-ID: <CANN689GH8eYz+ELX-EyD5pJOUUu_+F0Oxje50P_qpsz2CcTZPQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmap.c: find_vma: eliminate initial if(mm) check
From: Michel Lespinasse <walken@google.com>
To: k80c <k80ck80c@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 2:18 AM, k80c <k80ck80c@gmail.com> wrote:
> As per commit 841e31e5cc6219d62054788faa289b6ed682d068,
> we dont really need this if(mm) check anymore.
>
> A WARN_ON_ONCE was added just for safety, but there have been no bug
> reports about this so far.
>
> Removing this if(mm) check.
>
> Signed-off-by: k80c <k80ck80c@gmail.com>
> ---
>  mm/mmap.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0db0de1..b2c363f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1935,9 +1935,6 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
>  {
>         struct vm_area_struct *vma = NULL;
>
> -       if (WARN_ON_ONCE(!mm))          /* Remove this in linux-3.6 */
> -               return NULL;
> -
>         /* Check the cache first. */
>         /* (Cache hit rate is typically around 35%.) */
>         vma = ACCESS_ONCE(mm->mmap_cache);

Looks good to me.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
