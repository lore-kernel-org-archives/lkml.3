Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaDNJmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:42:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21065 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaDNJmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:42:19 -0400
X-AuditID: cbfee690-b7f266d00000287c-a7-534bad798c1d
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Steve Capper'" <steve.capper@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        kgene.kim@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
References: <000501cf57b4$e57e8e80$b07bab80$@samsung.com>
 <20140414091424.GA14204@linaro.org>
 <000c01cf57c3$65afc110$310f4330$@samsung.com>
 <20140414093342.GA14635@linaro.org>
In-reply-to: <20140414093342.GA14635@linaro.org>
Subject: Re: [PATCH 7/8] arm64: mm: Implement 4 levels of translation tables
Date: Mon, 14 Apr 2014 18:42:17 +0900
Message-id: <000d01cf57c5$d2cd08a0$786719e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQILdni68u70DkxPk4mJeDBA1L/NRAHzx3ZxApBJnJcDQxTXNJpaZP3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zvm7lWu9gg+0zxS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	9aODrAUTZSoud31kaWBcI9rFyMkhIWAicfR4KzuELSZx4d56ti5GDg4hgWWMEkuDYEoudj5l
	6mLkAgovYpR4cPUlI4Tzh1Fi9caZLCBVbAKaEo/u9oANEhHQkTh5rY0VpIhZoINZ4kbfUqj2
	rYwST5e+YgdZwSlgINE7oRSkQVjAR+Lm8i9gzSwCqhKTpt9iBrF5BSwlJrdPYIKwBSV+TL4H
	toxZQEti/c7jTBC2vMTmNW+ZIU5VkNhx9jUjxBFuEh++/2KFqBGR2PfiHdjVEgILOSTWbTrC
	CLFMQOLb5EMsIPdICMhKbDoANUdS4uCKGywTGCVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILi
	pPQiE73ixNzi0rx0veT83E2MkBQwYQfjvQPWhxiTgdZPZJYSTc4HppC8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBkdnnvlLP3zav1mz7sfsG6
	+85Ti50dH8MsV/TOUQ34tm1u+774xlUzHyXfzhTccPVxu/96hlP7Vbmnnl90hVWe89POLer9
	x16eOyOzd11/iOKawhXnr6142f1W+O7HOuaXKiU5YWJi737wflG4vq5F5Mxxza2/nmhztjTW
	fXXrc7xlIr6y1rbvuxJLcUaioRZzUXEiALk7jjkXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd3Ktd7BBrtuC1r8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjNWPDrIWTJSpuNz1kaWBcY1oFyMnh4SAicTFzqdMELaY
	xIV769m6GLk4hAQWMUo8uPqSEcL5wyixeuNMFpAqNgFNiUd3e9hBbBEBHYmT19pYQYqYBTqY
	JW70LWWC6NjKKPF06SugKg4OTgEDid4JpSANwgI+EjeXfwFrZhFQlZg0/RYziM0rYCkxuX0C
	E4QtKPFj8j2wZcwCWhLrdx5ngrDlJTavecsMcaqCxI6zrxkhjnCT+PD9FytEjYjEvhfvGCcw
	Cs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgJPNMegfjqgaL
	Q4wCHIxKPLwdc7yDhVgTy4orcw8xSnAwK4nwbsvwChbiTUmsrEotyo8vKs1JLT7EmAz06URm
	KdHkfGACzCuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRseZ
	Tx7fjFny09PO/7jReqU5uoaFa44v8a76Ye3XqvWPu/V7QYh8yYanYQUXltXHFz58zb6sfLNW
	wmG9nE/vRP3OzvBk2t4rq7d2/Y6STLZlha61f599WX1DN+n3glXzpkzt+PZQoWnT3pSsn42L
	JR82ej4WZjgf4+GjsiL7RpEE3xeP7tItLUosxRmJhlrMRcWJAMKqFuN2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 14, 2014 6:34 PM, Steve Capper wrote:
> On Mon, Apr 14, 2014 at 06:24:55PM +0900, Jungseok Lee wrote:
> > On Monday, April 14, 2014 6:14 PM, Steve Capper wrote:
> > > On Mon, Apr 13, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:
> > > > This patch implements 4 levels of translation tables since 3
> > > > levels of page tables with 4KB pages cannot support 40-bit
> > > > physical address space described in [1] due to the following issue.
> > > >
> > > > It is a restriction that kernel logical memory map with 4KB + 3
> > > > levels
> > > > (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region
> > > > from 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to
> > > > create mapping for this region in map_mem function since
> > > > __phys_to_virt for this region reaches to address overflow.
> > > >
> > > > If SoC design follows the document, [1], over 32GB RAM would be
> > > > placed from 544GB. Even 64GB system is supposed to use the region
> > > > from 544GB to 576GB for only 32GB RAM. Naturally, it would reach
> > > > to enable 4 levels of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> > > >
> > > > However, it is recommended 4 levels of page table should be only
> > > > enabled if memory map is too sparse or there is about 512GB RAM.
> > >
> > > Hi,
> > > So I thought I'd apply this series and have a play, this patch
> > > doesn't apply cleanly for me, please see below why...
> >
> > This pathset is based on 3.15-rc1.
> 
> Thanks, yes that applies cleanly for me now.

Okay, it sounds good.

> >
> > > [ ... ]
> > >
> > > > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> > > > index 0fd5650..0b0b16a 100644
> > > > --- a/arch/arm64/kernel/head.S
> > > > +++ b/arch/arm64/kernel/head.S
> > > > @@ -46,8 +46,8 @@
> > > >  #error KERNEL_RAM_VADDR must start at 0xXXX80000  #endif
> > > >
> > > > -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> > > > -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > > > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > > > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> > > >
> > > >  	.globl	swapper_pg_dir
> > > >  	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
> > > > @@ -384,6 +384,20 @@ ENDPROC(__calc_phys_offset)
> > > >  	.endm
> > > >
> > > >  /*
> > > > + * Macro to populate the PUD for the corresponding block entry in
> > > > +the next
> > > > + * level (tbl) for the given virtual address.
> > > > + *
> > > > + * Preserves:	pud, tbl, virt
> > > > + * Corrupts:	tmp1, tmp2
> > > > + */
> > > > +	.macro create_pud_entry, pud, tbl, virt, tmp1, tmp2
> > > > +	lsr	\tmp1, \virt, #PUD_SHIFT
> > > > +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> > > > +	orr	\tmp2, \tbl, #3			// PUD entry table type
> > > > +	str	\tmp2, [\pud, \tmp1, lsl #3]
> > > > +	.endm
> > > > +
> > > > +/*
> > > >   * Macro to populate block entries in the page table for the start..end
> > > >   * virtual range (inclusive).
> > > >   *
> > > > @@ -445,10 +459,18 @@ __create_page_tables:
> > > >  	ldr	x3, =KERNEL_START
> > > >  	add	x3, x3, x28			// __pa(KERNEL_START)
> > >
> > > I don't think we have C++ style comments in the kernel. Also, I
> > > can't see any references to =KERNEL_START in arch/arm64/kernel/head.S (from 3.14 down).
> >
> > C++ style comments are prevalent in arch/arm64/kernel/head.S. I've
> > C++ followed the
> > code style written previously.
> 
> Apologies, my mistake, I've been staring at arch/arm too long where @ is used.

It's okay.

Best Regards
Jungseok Lee

