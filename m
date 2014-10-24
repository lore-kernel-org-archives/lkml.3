Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbaJXQi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:38:27 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:64664 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbaJXQiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:38:24 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Weijie Yang <weijie.yang@samsung.com>, mingo@kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, fengguang.wu@intel.com,
        m.szyprowski@samsung.com, iamjoonsoo.kim@lge.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH] x86, cma: reserve dma contiguous area after initmem_init()
In-Reply-To: <000101cfef69$31e528a0$95af79e0$%yang@samsung.com>
Organization: http://mina86.com/
References: <000101cfef69$31e528a0$95af79e0$%yang@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141024:weijie.yang@samsung.com::Bg9lNw2U34Xcbc5T:000000000000000000000000000000000000000iq1
X-Hashcash: 1:20:141024:weijie.yang.kh@gmail.com::5HVsuHtLEtDqoTVk:00000000000000000000000000000000000000QeZ
X-Hashcash: 1:20:141024:linux-mm@kvack.org::u4QC3MPccz8SJS9+:00000000000000000000000000000000000000000000Jq3
X-Hashcash: 1:20:141024:akpm@linux-foundation.org::Y381JBbyfsNvC1kI:00000000000000000000000000000000000012JW
X-Hashcash: 1:20:141024:hpa@zytor.com::7emODzXdmO5tMclS:00000yCg
X-Hashcash: 1:20:141024:tglx@linutronix.de::LQHitcLv/SVZeMzg:00000000000000000000000000000000000000000001hd4
X-Hashcash: 1:20:141024:fengguang.wu@intel.com::Rx2eKk8HQLq5ABo9:0000000000000000000000000000000000000002TcA
X-Hashcash: 1:20:141024:iamjoonsoo.kim@lge.com::cE9PLZqA1DQr4gQe:0000000000000000000000000000000000000002OTW
X-Hashcash: 1:20:141024:m.szyprowski@samsung.com::E4+m7tTmKsJdILpF:0000000000000000000000000000000000000367R
X-Hashcash: 1:20:141024:linux-kernel@vger.kernel.org::DMrHum4+1rQfG+Ig:0000000000000000000000000000000003OsN
X-Hashcash: 1:20:141024:mingo@kernel.org::MPLsjI0MTurIaxog:05rQ6
Date: Fri, 24 Oct 2014 18:38:18 +0200
Message-ID: <xa1ta94l2zk5.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2014, Weijie Yang <weijie.yang@samsung.com> wrote:
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

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  arch/x86/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 235cfd3..ab08aa2 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1128,7 +1128,6 @@ void __init setup_arch(char **cmdline_p)
>  	setup_real_mode();
>  
>  	memblock_set_current_limit(get_max_mapped());
> -	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
>  
>  	/*
>  	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
> @@ -1159,6 +1158,7 @@ void __init setup_arch(char **cmdline_p)
>  	early_acpi_boot_init();
>  
>  	initmem_init();
> +	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
>  
>  	/*
>  	 * Reserve memory for crash kernel after SRAT is parsed so that it
> -- 
> 1.7.0.4
>
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
