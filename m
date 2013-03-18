Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3CRSwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:52:54 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36139 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3CRSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:52:53 -0400
MIME-Version: 1.0
In-Reply-To: <1363602093-11965-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1363602093-11965-1-git-send-email-linfeng@cn.fujitsu.com>
Date: Mon, 18 Mar 2013 11:52:52 -0700
X-Google-Sender-Auth: VRM0u36l_g03C-Wfz26I7T34nNQ
Message-ID: <CAE9FiQUHtM_Nuz4ak+HeNGV6a-HTtfMkxc+zBZuow47Vj70CKQ@mail.gmail.com>
Subject: Re: [PATCH] x86: mm: add_pfn_range_mapped: use meaningful index to
 teach clean_sort_range()
From: Yinghai Lu <yinghai@kernel.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, penberg@kernel.org, jacob.shin@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:21 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
> Since add_range_with_merge() return the max none zero element of the array, it's
> suffice to use it to instruct clean_sort_range() to do the sort. Or the former
> assignment by add_range_with_merge() is nonsense because clean_sort_range()
> will produce a accurate number of the sorted array and it never depends on
> nr_pfn_mapped.
>
> Cc: Jacob Shin <jacob.shin@amd.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>  arch/x86/mm/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 59b7fc4..55ae904 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -310,7 +310,7 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>  {
>         nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
>                                              nr_pfn_mapped, start_pfn, end_pfn);
> -       nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
> +       nr_pfn_mapped = clean_sort_range(pfn_mapped, nr_pfn_mapped);
>
>         max_pfn_mapped = max(max_pfn_mapped, end_pfn);>

Acked-by: Yinghai Lu <yinghai@kernel.org>
