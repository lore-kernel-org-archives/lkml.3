Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab3B0NXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:23:55 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:44569 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3B0NXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:23:54 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUZ8O9Phgv4yuL657DBVQpLThv4p7KHLtYj5oJ6QqDgDg@mail.gmail.com>
References: <CA+icZUV=e_5qvEs-KyphN7=skmr1-kSSqbiVT5eFsfXbUaT9qQ@mail.gmail.com>
	<CA+icZUUZ8O9Phgv4yuL657DBVQpLThv4p7KHLtYj5oJ6QqDgDg@mail.gmail.com>
Date: Wed, 27 Feb 2013 14:23:51 +0100
Message-ID: <CA+icZUV+et8R7+Z8QBOcTLYaCqy=NpDgqcaHYmP5tfjqPybgpw@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 23 [ perf: NULL pointer dereference
 perf_init_event() ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:39 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Mon, Feb 25, 2013 at 2:44 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Mon, Feb 25, 2013 at 6:00 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Please do not add any work destined for v3.10 to your -next included
>>> branches until after Linus has release v3.9-rc1.
>>>
>>> Changes since 20130222:
>>>
>>> The metag tree gained a conflict against Linus' tree.
>>>
>>> The kbuild tree gained a build failure so I used the version from
>>> next-20130222.
>>>
>>> The drm tree still has its build failure for which I applied a patch.
>>>
>>> The watchdog tree gained a conflict against Linus' tree.
>>>
>>> The akpm tree gained a conflict against the vfs tree and lost lots of
>>> patches that turned up elsewhere.
>>>
>>> ----------------------------------------------------------------------------
>>>
>>
>> With today's Linux-Next I see multiple call-traces pointing to perf
>> issues (excerpt, for full dmesg see attachments):
>>
>> [    0.093651] Call Trace:
>> [    0.093656]  [<ffffffff8112a808>] perf_event_alloc+0x358/0x490
>> [    0.093661]  [<ffffffff810ec230>] ? touch_nmi_watchdog+0x80/0x80
>> [    0.093666]  [<ffffffff8112ac6e>] perf_event_create_kernel_counter+0x2e/0xe0
>> [    0.093670]  [<ffffffff810ec3ed>] watchdog_enable+0xfd/0x1e0
>> [    0.093676]  [<ffffffff81087a3c>] smpboot_thread_fn+0x9c/0x170
>> [    0.093681]  [<ffffffff810879a0>] ? lg_global_lock+0x70/0x70
>> [    0.093685]  [<ffffffff8107fb80>] kthread+0xc0/0xd0
>> [    0.093689]  [<ffffffff8107fac0>] ? flush_kthread_worker+0xb0/0xb0
>> [    0.093694]  [<ffffffff816cc56c>] ret_from_fork+0x7c/0xb0
>> [    0.093698]  [<ffffffff8107fac0>] ? flush_kthread_worker+0xb0/0xb0
>> [    0.093700] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18
>> e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 a2 c9 e2 00
>> 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ce ab 22 00 48 89 c3
>> 48 85
>> [    0.093736] RIP  [<ffffffff8112a3e2>] perf_init_event+0x32/0x100
>> [    0.093740]  RSP <ffff880119b93d58>
>> [    0.093742] CR2: 0000000000000000
>> [    0.093746] ---[ end trace 941ac4690a5bae9e ]---
>> [    0.104659] Disabled fast string operations
>> [    0.106781] Brought up 4 CPUs
>> [    0.106785] BUG: unable to handle kernel NULL pointer dereference
>> at           (null)
>> [    0.106790] IP: [<ffffffff8112a3e2>] perf_init_event+0x32/0x100
>> [    0.106791] PGD 0
>> [    0.106794] Oops: 0000 [#4] SMP
>> [    0.106795] Modules linked in:
>> [    0.106798] CPU 3
>> [    0.106798] Pid: 22, comm: watchdog/3 Tainted: G      D
>> 3.8.0-next20130225-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD.
>> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
>> [    0.106801] RIP: 0010:[<ffffffff8112a3e2>]  [<ffffffff8112a3e2>]
>> perf_init_event+0x32/0x100
>> ...
>>
>> Regards,
>> - Sedat -
>
> I see the same call-traces with today's Linux-Next (next-20130226)!
> Any hints/help?
>
> - Sedat -

[ CC Tejun and Borislav ]

This turned out to be a idr issue [1]. Thanks Borislav for his help.

Reverting "idr: implement lookup hint" commit [2] makes the call-traces go away.

- Sedat -

[1] http://marc.info/?l=linux-kernel&m=136197056415722&w=2
[2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=29cf29e1fbb875019713eb55cf27ec35f1e5fa5e
