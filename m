Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143Ab3DOVYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:24:35 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:35320 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934043Ab3DOVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130415080808.GC1994@udknight>
References: <20130415080808.GC1994@udknight>
Date: Mon, 15 Apr 2013 14:24:33 -0700
X-Google-Sender-Auth: kRpwZmDIb7GjtggsTdO95V4rh2E
Message-ID: <CAE9FiQW3G3ncyVHV=0nbhX2cD2sLXTzn6FAprfa3y8AeMbE43A@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm:memblock: add memblock_alloc_in_[range|range_nid]
From: Yinghai Lu <yinghai@kernel.org>
To: Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 1:08 AM, Wang YanQing <udknight@gmail.com> wrote:
> There is a memblock code use pattern in kernel which looks like below:
> in nobootmem.c:
>
>        addr = memblock_find_in_range_node(goal, limit, size, align, nid);
>        if (!addr)
>                 return NULL;
>
>        ptr = phys_to_virt(addr);
>        memset(ptr, 0, size);
>        memblock_reserve(addr, size);
>
> use memblock_alloc_in_[range|range_nid] to do
> the search and reserve in one function will
> bring the benefit below:
>
> 1: clarify the codes
> 2: we will check memblock_reserve's return value

No, I don't like this.

It cause confusing.
alloc usually it means allocate and access it right away.
find/reserve, is somehow will only access some time later.

also in find/reserve path, we don't round size to align.
   size = round_up(size, align);

Thanks

Yinghai
