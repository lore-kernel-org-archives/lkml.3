Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaHGMx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:53:58 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49985 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbaHGMxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAAmzW4MX2birtCOUxjDdQ7c3Y+RyVkBt383HEQ=XFgnhhOsQPw@mail.gmail.com>
References: <CAMuHMdW2kb=EF-Nmem_gyUu=p7hFOTe+Q2ekHh41SaHHiWDGeg@mail.gmail.com>
	<CAAmzW4MX2birtCOUxjDdQ7c3Y+RyVkBt383HEQ=XFgnhhOsQPw@mail.gmail.com>
Date: Thu, 7 Aug 2014 14:53:54 +0200
X-Google-Sender-Auth: nyd_e9vQxPPSrBrEKFokDIa-fCQ
Message-ID: <CAMuHMdVC8aYwDEHnntshdVA24Nx3qAUXZfeRQNGqj=J6eExU-Q@mail.gmail.com>
Subject: Re: BUG: enable_cpucache failed for radix_tree_node, error 12 (was:
 Re: [PATCH v3 9/9] slab: remove BAD_ALIEN_MAGIC)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 7, 2014 at 2:36 PM, Joonsoo Kim <js1304@gmail.com> wrote:
>> With latest mainline, I'm getting a crash during bootup on m68k/ARAnyM:
>>
>> enable_cpucache failed for radix_tree_node, error 12.
>> kernel BUG at /scratch/geert/linux/linux-m68k/mm/slab.c:1522!

>> I bisected it to commit a640616822b2c3a8009b0600f20c4a76ea8a0025
>> Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Date:   Wed Aug 6 16:04:38 2014 -0700
>>
>>     slab: remove BAD_ALIEN_MAGIC

> This patch only works for !NUMA. And if num_possible_nodes() is 1,
> then it doesn't have any effect, because alloc_alien_cache() call is always
> skipped. Is it possible !NUMA and num_possible_nodes() != 1?
>
> Could you check your config for CONFIG_NUMA and
> CONFIG_NODES_SHIFT?

$ grep CONFIG_NUMA .config
$ grep CONFIG_NODES_SHIFT .config
CONFIG_NODES_SHIFT=3
$

There are indeed multiple nodes:

On node 0 totalpages: 3584
free_area_init_node: node 0, pgdat 003659a4, node_mem_map 00402000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3584 pages, LIFO batch:0
On node 1 totalpages: 65536
free_area_init_node: node 1, pgdat 00366294, node_mem_map 00426090
  DMA zone: 576 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 65536 pages, LIFO batch:15

> And, could you check booting with boot param "noaliencache"?

That fixes the boot, too.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
