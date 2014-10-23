Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaJWHqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:46:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53429 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaJWHqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:46:46 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-99-5448b26352eb
Message-id: <5448B262.5080401@samsung.com>
Date: Thu, 23 Oct 2014 09:46:42 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Weijie Yang <weijie.yang.kh@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org, mina86@mina86.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [mm] BUG: Int 6: CR2 (null)
References: <20141009020410.GA7968@wfg-t540p.sh.intel.com>
 <CAL1ERfOneR5ix3y0Q6GFyPondQp8MpPZY=8nJWZc9n1FC=d9Gw@mail.gmail.com>
In-reply-to: <CAL1ERfOneR5ix3y0Q6GFyPondQp8MpPZY=8nJWZc9n1FC=d9Gw@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7rJmzxCDJ6+VrF4/3w9s8XK7mY2
	i8u75rBZ3Fvzn9Vi5fF2VosFx1tYLbbuvcpu8eTEfxYHDo/7e9k9Gm/cYPPYOesuu8fiPS+Z
	PDZ9msTu0fX2CpPHuj+vmDw+b5IL4IjisklJzcksSy3St0vgynj05Rl7wVLFiomPvjM2MB6W
	6GLk5JAQMJF4dbqRCcIWk7hwbz0biC0ksJRR4uQc1y5GLiD7E6PE46vbmbsYOTh4BbQkTv9y
	BKlhEVCVeLzsKjOIzSZgKNH1tgusV1QgRuL+ztVgNq+AoMSPyfdYQGwRgWCJv2cOs4DMZBbY
	wSjxZu0UsJnCAhoS1+7JQuxqZJSY+/YpK0gDJ1DDhZ8nwRYwC5hJfHl5mBXClpfYvOYt8wRG
	gVlIdsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx8HUH49JjVocYBTgY
	lXh4K5I9QoRYE8uKK3MPMUpwMCuJ8NZaA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzhXvKXrr
	PUezvJDz2M2Cl3Pr+A1ZuOStvScWrXmzaq7rBM4FMR0b/bo/Nqzbqj15j9JKkWUs3kev61f+
	FlQ98dfLer17rcW/9X2viixUVp4+FbVb8If2/VYZ6dPl2xczLdjkmCJxTcc1/k1rS+4a3f9Z
	T3pNg/1lBFXiv7hP+LjLTPmKiOV9JZbijERDLeai4kQArwpURmMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-23 08:03, Weijie Yang wrote:
> On Thu, Oct 9, 2014 at 10:04 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> FYI, we noticed the below changes on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> commit 478e86d7c8c5f41e29abb81b05b459d24bdc71a2 ("mm: cma: adjust address limit to avoid hitting low/high memory boundary")
>>
>>
>> +------------------------------------------+------------+------------+
>> |                                          | 81febe58a8 | 478e86d7c8 |
>> +------------------------------------------+------------+------------+
>> | boot_successes                           | 10         | 0          |
>> | boot_failures                            | 5          | 10         |
>> | kernel_BUG_at_arch/x86/mm/physaddr.c     | 5          |            |
>> | invalid_opcode                           | 5          |            |
>> | EIP_is_at__phys_addr                     | 5          |            |
>> | Kernel_panic-not_syncing:Fatal_exception | 5          |            |
>> | backtrace:vm_mmap_pgoff                  | 5          |            |
>> | backtrace:SyS_mmap_pgoff                 | 5          |            |
>> | BUG:Int_CR2(null)                        | 0          | 10         |
>> +------------------------------------------+------------+------------+
>>
>> [    0.000000] BRK [0x025ee000, 0x025eefff] PGTABLE
>> [    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
>> [    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
>> [    0.000000] BUG: Int 6: CR2   (null)
>> [    0.000000]      EDI c0000000  ESI   (null)  EBP 41c11ea4  EBX 425cc101
>> [    0.000000]      ESP 41c11e98   ES 0000007b   DS 0000007b
>> [    0.000000]      EDX 00000001  ECX   (null)  EAX 41cd8150
>> [    0.000000]      vec 00000006  err   (null)  EIP 41072227   CS 00000060  flg 00210002
>> [    0.000000] Stack: 425cc150   (null)   (null) 41c11ef4 41d4ee4d   (null) 13ffe000 41c11ec4
>> [    0.000000]        41c2d900   (null) 13ffe000   (null) 4185793e 0000002e 410c2982 41c11f00
>> [    0.000000]        410c2df5   (null)   (null)   (null) 425cc150 00013efe   (null) 41c11f28
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-next-20141008 #815
>> [    0.000000]  00000000 425cc101 41c11e48 41850786 41c11ea4 41d2b1db 41d95f71 00000006
>> [    0.000000]  00000000 c0000000 00000000 41c11ea4 425cc101 41c11e98 0000007b 0000007b
>> [    0.000000]  00000001 00000000 41cd8150 00000006 00000000 41072227 00000060 00210002
>> [    0.000000] Call Trace:
>> [    0.000000]  [<41850786>] dump_stack+0x16/0x18
>> [    0.000000]  [<41d2b1db>] early_idt_handler+0x6b/0x6b
>> [    0.000000]  [<41072227>] ? __phys_addr+0x2e/0xca
>> [    0.000000]  [<41d4ee4d>] cma_declare_contiguous+0x3c/0x2d7
>> [    0.000000]  [<4185793e>] ? _raw_spin_unlock_irqrestore+0x59/0x91
>> [    0.000000]  [<410c2982>] ? wake_up_klogd+0x8/0x33
>> [    0.000000]  [<410c2df5>] ? console_unlock+0x448/0x461
>> [    0.000000]  [<41d6d359>] dma_contiguous_reserve_area+0x27/0x47
>> [    0.000000]  [<41d6d4d1>] dma_contiguous_reserve+0x158/0x163
>> [    0.000000]  [<41d33e0f>] setup_arch+0x79b/0xc68
>> [    0.000000]  [<4184c0b4>] ? printk+0x1c/0x1e
>> [    0.000000]  [<41d2b7cf>] start_kernel+0x9c/0x456
>> [    0.000000]  [<41d2b2ca>] i386_start_kernel+0x79/0x7d
>>
> I notice that code has been merged into mainline kernel without fix,
> maybe fengguang's mail was missed.
>
> I review the code, dma_contiguous_reserve() is called before initmem_init(),
> so the variable high_memory is not initialized and calculated by
> __pa(high_memory),
> in x86 arch high_memory is initialized after dma_contiguous_reserve(), while
> in arm arch high_memory is initialized before dma_contiguous_reserve(),
> I think that is the reason which causes the BUG in x86.
>
> However, I'm not familiar with system init sequence, so I send this
> notice mail rather than a patch :-(

Thanks for your analysis. I agree that the simplest way of fixing this 
issue is
to move dma_contiguous_reserve() after initmem_init(). Could you prepare 
such patch?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

