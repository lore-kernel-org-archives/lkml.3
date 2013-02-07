Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272Ab3BGURR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:17:17 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64729 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234Ab3BGURQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:17:16 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWf+pNodRBHY0ZKF_XwRnCEEQa1s0an0fanizaFQ6c1Kw@mail.gmail.com>
References: <CA+icZUUu2-tg+980e0yOMhGq_igkj=FZahy96fh0dcwXdM3+tg@mail.gmail.com>
	<CA+icZUWf+pNodRBHY0ZKF_XwRnCEEQa1s0an0fanizaFQ6c1Kw@mail.gmail.com>
Date: Thu, 7 Feb 2013 21:17:14 +0100
Message-ID: <CA+icZUU7+hWhiaOdyFNoghJZVqnOvbPABy=m0KLuiQcsKih--g@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 6 [WARNING: at kernel/sched/clock.c:219 sched_clock_cpu+0xf9/0x110()]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 9:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Feb 6, 2013 at 9:23 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Wed, Feb 6, 2013 at 8:43 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20130204:
>>>
>>> The metag tree gained a conflict against the arc tree.
>>>
>>> I added a couple of merge fix patches to the mips tree for breakage in
>>> other architectures.
>>>
>>> The powerpc tree still had a build failure.
>>>
>>> The crypto tree gained a conflict against the net-next tree.
>>>
>>> The sound-asoc tree lost its build failure.
>>>
>>> The block tree gained a build failure for which I applied a merge fix
>>> patch.
>>>
>>> The battery tree gained a conflict against the mfd tree.
>>>
>>> The spi tree gained a conflict against the sound-asoc tree.
>>>
>>> The kvm tree gained a conflict against the arm tree.
>>>
>>> The driver-core tree gained conflicts against the spi and iommu trees.
>>>
>>> The tty tree gained a build failure on sparc32 for which I applied a
>>> patch.
>>>
>>> The akpm tree gained a conflict against the nfsd tree and a build failure
>>> for which I reverted a commit.
>>>
>>> ----------------------------------------------------------------------------
>>>
>>
>> [ CC x86 folks ]
>>
>> With today's Linux-Next I get this warning:
>>
>> [    0.000000] Console: colour dummy device 80x25
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at kernel/sched/clock.c:219 sched_clock_cpu+0xf9/0x110()
>> [    0.000000] Hardware name: 530U3BI/530U4BI/530U4BH
>> [    0.000000] Modules linked in:
>> [    0.000000] Pid: 0, comm: swapper/0 Not tainted
>> 3.8.0-rc6-next20130206-1-iniza-small #1
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff8105a5cf>] warn_slowpath_common+0x7f/0xc0
>> [    0.000000]  [<ffffffff8105a62a>] warn_slowpath_null+0x1a/0x20
>> [    0.000000]  [<ffffffff81093319>] sched_clock_cpu+0xf9/0x110
>> [    0.000000]  [<ffffffff8105c611>] __console_unlock.part.9+0x31/0x440
>> [    0.000000]  [<ffffffff816b327b>] ? printk+0x61/0x63
>> [    0.000000]  [<ffffffff8105ca4d>] console_unlock+0x2d/0x40
>> [    0.000000]  [<ffffffff81d3ecce>] con_init+0x218/0x22b
>> [    0.000000]  [<ffffffff81d3e259>] console_init+0x16/0x27
>> [    0.000000]  [<ffffffff81d06d7a>] start_kernel+0x28b/0x3fc
>> [    0.000000]  [<ffffffff81d068ef>] ? repair_env_string+0x5a/0x5a
>> [    0.000000]  [<ffffffff81d06120>] ? early_idt_handlers+0x120/0x120
>> [    0.000000]  [<ffffffff81d065ec>] x86_64_start_reservations+0x2a/0x2c
>> [    0.000000]  [<ffffffff81d066e1>] x86_64_start_kernel+0xf3/0x102
>> [    0.000000] ---[ end trace 79eb6cf41ffc867b ]---
>> [    0.000000] console [tty0] enabled
>>
>> Not sure, if this related to the known console/fbcon locking issue.
>> I will try later to merge [1] and check again.
>>
>> - Sedat -
>>
>> [1] http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
>
> Unrelated to known console/fbcon locking issue (see new dmesg).
>
> - Sedat -

That issue disappeared with next-20130207, but with
CONFIG_VIRT_CPU_ACCOUNTING=y.
( Did not test CONFIG_TICK_CPU_ACCOUNTING=y. )

/boot/config-3.8.0-rc6-next20130206-1-iniza-small:CONFIG_TICK_CPU_ACCOUNTING=y
/boot/config-3.8.0-rc6-next20130207-1-iniza-small:CONFIG_VIRT_CPU_ACCOUNTING=y

- Sedat -
