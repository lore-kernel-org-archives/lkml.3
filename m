Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaJXJpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:45:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31484 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXJpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:45:20 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-8d-544a1fad21fd
Message-id: <544A1FAC.8090000@samsung.com>
Date: Fri, 24 Oct 2014 11:45:16 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>, mingo@kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, fengguang.wu@intel.com,
        mina86@mina86.com, iamjoonsoo.kim@lge.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH] x86, cma: reserve dma contiguous area after initmem_init()
References: <000101cfef69$31e528a0$95af79e0$%yang@samsung.com>
In-reply-to: <000101cfef69$31e528a0$95af79e0$%yang@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xa7pr5b1CDJbdE7WYs34Nm8X75+uZ
	LaZtFLdY2d3MZnF51xw2i3tr/rNaLDjewmqx+t8pRovNm6YyWzw58Z/F4uSGs6wO3B47Z91l
	91i85yWTx6ZVnWwemz5NYvfoenuFyePduXPsHidm/GbxWPfnFZNH35ZVjB6fN8l5nGj5whrA
	HcVlk5Kak1mWWqRvl8CV8f3iOeaC1TIVV3bvZm9gPCbWxcjJISFgIvH+wQYmCFtM4sK99Wxd
	jFwcQgJLGSXet95igXA+MUp8PrwYKMPBwSugJfF8eTBIA4uAqkTPxdWsIDabgKFE19suNhBb
	VCBG4v7O1WA2r4CgxI/J91hAWkUErCU6HtmBjGQWmM4k0btmPgtIjbCAv8SLrkNgRwgJ2Ek8
	nLkDbCangL1E84ZHYDazgJnEl5eHoWx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqaXFCc
	lJ5rqFecmFtcmpeul5yfu4kREkdfdjAuPmZ1iFGAg1GJh7ci2SNEiDWxrLgy9xCjBAezkgjv
	LGmvECHelMTKqtSi/Pii0pzU4kOMTBycUg2MhvEbZ2rrJ3BUru28GFsnc8XCtOCg0uKeXT0t
	MwNeFkrM4y5hX1fFsHqneuQyZq47fZ80zp/Inbx05m72uybWmos/LXKObjg425TJbPqvUxo/
	JKQZs3vX1ifK605J3JZnfmmfOt/0g7Vrvk1xKUhRTQ9ZPd2rJk1vkuFyu81rAtob99qt0EhR
	YinOSDTUYi4qTgQAZf+Gl4ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-24 11:00, Weijie Yang wrote:
> Fengguang Wu reported a BUG: Int 6: CR2 (null) on x86 platform in
> 0-day Linux Kernel Performance Test:
>
> [    0.000000] BRK [0x025ee000, 0x025eefff] PGTABLE
> [    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
> [    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
> [    0.000000] BUG: Int 6: CR2   (null)
> [    0.000000]      EDI c0000000  ESI   (null)  EBP 41c11ea4  EBX 425cc101
> [    0.000000]      ESP 41c11e98   ES 0000007b   DS 0000007b
> [    0.000000]      EDX 00000001  ECX   (null)  EAX 41cd8150
> [    0.000000]      vec 00000006  err   (null)  EIP 41072227   CS 00000060  flg 00210002
> [    0.000000] Stack: 425cc150   (null)   (null) 41c11ef4 41d4ee4d   (null) 13ffe000 41c11ec4
> [    0.000000]        41c2d900   (null) 13ffe000   (null) 4185793e 0000002e 410c2982 41c11f00
> [    0.000000]        410c2df5   (null)   (null)   (null) 425cc150 00013efe   (null) 41c11f28
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-next-20141008 #815
> [    0.000000]  00000000 425cc101 41c11e48 41850786 41c11ea4 41d2b1db 41d95f71 00000006
> [    0.000000]  00000000 c0000000 00000000 41c11ea4 425cc101 41c11e98 0000007b 0000007b
> [    0.000000]  00000001 00000000 41cd8150 00000006 00000000 41072227 00000060 00210002
> [    0.000000] Call Trace:
> [    0.000000]  [<41850786>] dump_stack+0x16/0x18
> [    0.000000]  [<41d2b1db>] early_idt_handler+0x6b/0x6b
> [    0.000000]  [<41072227>] ? __phys_addr+0x2e/0xca
> [    0.000000]  [<41d4ee4d>] cma_declare_contiguous+0x3c/0x2d7
> [    0.000000]  [<4185793e>] ? _raw_spin_unlock_irqrestore+0x59/0x91
> [    0.000000]  [<410c2982>] ? wake_up_klogd+0x8/0x33
> [    0.000000]  [<410c2df5>] ? console_unlock+0x448/0x461
> [    0.000000]  [<41d6d359>] dma_contiguous_reserve_area+0x27/0x47
> [    0.000000]  [<41d6d4d1>] dma_contiguous_reserve+0x158/0x163
> [    0.000000]  [<41d33e0f>] setup_arch+0x79b/0xc68
> [    0.000000]  [<4184c0b4>] ? printk+0x1c/0x1e
> [    0.000000]  [<41d2b7cf>] start_kernel+0x9c/0x456
> [    0.000000]  [<41d2b2ca>] i386_start_kernel+0x79/0x7d
>
> see detail: https://lkml.org/lkml/2014/10/8/708
>
> It is because dma_contiguous_reserve() is called before initmem_init() in x86,
> the variable high_memory is not initialized but accessed by __pa(high_memory)
> in dma_contiguous_reserve().
>
> This patch moves dma_contiguous_reserve() after initmem_init() so that
> high_memory is initialized before accessed.
>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   arch/x86/kernel/setup.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 235cfd3..ab08aa2 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1128,7 +1128,6 @@ void __init setup_arch(char **cmdline_p)
>   	setup_real_mode();
>   
>   	memblock_set_current_limit(get_max_mapped());
> -	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
>   
>   	/*
>   	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
> @@ -1159,6 +1158,7 @@ void __init setup_arch(char **cmdline_p)
>   	early_acpi_boot_init();
>   
>   	initmem_init();
> +	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
>   
>   	/*
>   	 * Reserve memory for crash kernel after SRAT is parsed so that it

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

