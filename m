Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3CSFxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:53:06 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36780 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CSFxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <1363670161-9214-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1363670161-9214-3-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 18 Mar 2013 22:53:04 -0700
X-Google-Sender-Auth: mUAmmbFP-uefZ3PhDvH15EVAYRg
Message-ID: <CAE9FiQU-yCanj_jRSL2Pwdfg7L+832XYnsgR8m2gB=PJdTM_xw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm, nobootmem: do memset() after memblock_reserve()
From: Yinghai Lu <yinghai@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:16 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Currently, we do memset() before reserving the area.
> This may not cause any problem, but it is somewhat weird.
> So change execution order.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index 589c673..f11ec1c 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -46,8 +46,8 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
>                 return NULL;
>
>         ptr = phys_to_virt(addr);
> -       memset(ptr, 0, size);
>         memblock_reserve(addr, size);
> +       memset(ptr, 0, size);

move down ptr = ... too ?

>         /*
>          * The min_count is set to 0 so that bootmem allocated blocks
>          * are never reported as leaks.
> --
> 1.7.9.5
>
