Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3H2UoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:44:19 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60724 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab3H2UoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <521faf12.9JwU9Jt+2QNWkPCZ%akpm@linux-foundation.org>
References: <521faf12.9JwU9Jt+2QNWkPCZ%akpm@linux-foundation.org>
Date: Thu, 29 Aug 2013 13:44:18 -0700
X-Google-Sender-Auth: GF0t8w8MfeC5iEMVcpsvhsO9eXo
Message-ID: <CAE9FiQWHeip7XWF+-mCt3gXsESpr52Fb71fbrJbRSJyeHCAMeQ@mail.gmail.com>
Subject: Re: + mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch added
 to -mm tree
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 1:29 PM,  <akpm@linux-foundation.org> wrote:
> Subject: + mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch added to -mm tree
> To: liwanp@linux.vnet.ibm.com,yinghai@kernel.org
> From: akpm@linux-foundation.org
> Date: Thu, 29 Aug 2013 13:29:06 -0700
>
>
> The patch titled
>      Subject: mm/sparse: introduce alloc_usemap_and_memmap fix-2
> has been added to the -mm tree.  Its filename is
>      mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch
>
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Subject: mm/sparse: introduce alloc_usemap_and_memmap fix-2
>
> Pass function pointer to alloc_usemap_and_memmap() instead of true/false.
>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/sparse.c |   41 +++++++++++++++--------------------------
>  1 file changed, 15 insertions(+), 26 deletions(-)
>
> diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-2 mm/sparse.c
> --- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-2
> +++ a/mm/sparse.c
> @@ -339,13 +339,14 @@ static void __init check_usemap_section_
>  }
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>
> -static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
> +static void __init sparse_early_usemaps_alloc_node(void **data,
>                                  unsigned long pnum_begin,
>                                  unsigned long pnum_end,
>                                  unsigned long usemap_count, int nodeid)
>  {
>         void *usemap;
>         unsigned long pnum;
> +       unsigned long **usemap_map = (unsigned long **)data;

Can you check if (void *data) will work?

void ** looks strange.

Yinghai
