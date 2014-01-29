Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaA2BZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:25:21 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39711 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaA2BZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:25:20 -0500
MIME-Version: 1.0
In-Reply-To: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
Date: Tue, 28 Jan 2014 17:25:19 -0800
Message-ID: <CAGa+x85rWSAw0KCt-gJTkpvfur5ujYYqQXGJ0G+z135udTHYgw@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Kevin Hilman <khilman@linaro.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 2:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> In original bootmem wrapper for memblock, we have limit checking.
>
> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  mm/memblock.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> Index: linux-2.6/mm/memblock.c
> ===================================================================
> --- linux-2.6.orig/mm/memblock.c
> +++ linux-2.6/mm/memblock.c
> @@ -1077,6 +1077,9 @@ static void * __init memblock_virt_alloc
>         if (!align)
>                 align = SMP_CACHE_BYTES;
>
> +       if (max_addr > memblock.current_limit)
> +               max_addr = memblock.current_limit;
> +
>  again:
>         alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
>                                             nid);

Tested-by: Kevin Hilman <khilman@linaro.org>

Verified various ARM boots to be passing again.

Kevin
