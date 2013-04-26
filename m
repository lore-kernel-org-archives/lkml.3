Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3DZTN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:13:59 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33340 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3DZTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:13:57 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAFTL4hyPLQQNbsoh9FYFg+VbGicREFZdP6Sc0V+EfgdWuwSOmQ@mail.gmail.com>
References: <CA+icZUVCmFeh3Xna37VJDDzvZ34sYJ_Dser7i5rRzGLhMTi5-Q@mail.gmail.com>
	<CA+icZUXeDT8x60iUtjJV2GO5KkDnm8CJsz8mntz5hREoOD+YJw@mail.gmail.com>
	<CA+icZUWkyP9TE0eeqstyvVNP++MtN8rYfGcPBT6NuMOHEHm7dw@mail.gmail.com>
	<20130426182239.GA25767@mtj.dyndns.org>
	<CA+icZUW5t8gAjBbKaJUFGabCXvxb8QXEE3Yn5=EpbDfUNHM60w@mail.gmail.com>
	<CAFTL4hyPLQQNbsoh9FYFg+VbGicREFZdP6Sc0V+EfgdWuwSOmQ@mail.gmail.com>
Date: Fri, 26 Apr 2013 21:13:55 +0200
Message-ID: <CA+icZUU5GNOmw5q8fOHdJ-MbHK5TYh6z9YkQ2JyT57C6eQRpFQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 26 [ bluetooth on suspend/resume ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 8:43 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/4/26 Sedat Dilek <sedat.dilek@gmail.com>:
>> On Fri, Apr 26, 2013 at 8:22 PM, Tejun Heo <tj@kernel.org> wrote:
>>> On Fri, Apr 26, 2013 at 07:40:20PM +0200, Sedat Dilek wrote:
>>>> Oops, NULL-pointer-deref [ __queue_work() ]
>>>>
>>>> [   25.974932] BUG: unable to handle kernel NULL pointer dereference
>>>> at 0000000000000100
>>>> [   25.974944] IP: [<ffffffff81077502>] __queue_work+0x32/0x3d0
>>>
>>> So, 0x100 deref near the top of the function.
>>>
>>> ...
>>>> [   25.975037] RIP: 0010:[<ffffffff81077502>]  [<ffffffff81077502>]
>>>> __queue_work+0x32/0x3d0
>>>> [   25.975047] RSP: 0018:ffff88008fed5c48  EFLAGS: 00010046
>>>> [   25.975052] RAX: 0000000000000096 RBX: 0000000000000292 RCX: 0000000000000000
>>>> [   25.975058] RDX: ffff880095281850 RSI: 0000000000000000 RDI: 0000000000000100
>>>> [   25.975063] RBP: ffff88008fed5c88 R08: 0000000000000000 R09: 0000000000000300
>>>> [   25.975069] R10: ffff880094981a00 R11: 0000000000000000 R12: ffff880095281850
>>>> [   25.975074] R13: 0000000000000000 R14: 0000000000000100 R15: 00000000000009c4
>>>> [   25.975081] FS:  00007f2f61707740(0000) GS:ffff88011fac0000(0000)
>>>> knlGS:0000000000000000
>>>> [   25.975088] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [   25.975093] CR2: 0000000000000100 CR3: 000000009101f000 CR4: 00000000000407e0
>>>> [   25.975099] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> [   25.975104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> ...
>>>> [   25.975143] Call Trace:
>>>> [   25.975151]  [<ffffffff81077be5>] queue_work_on+0x45/0x50
>>>> [   25.975165]  [<ffffffffa016e8ff>] hci_req_run+0xbf/0xf0 [bluetooth]
>>>> [   25.975188]  [<ffffffffa016ea06>] __hci_req_sync+0xd6/0x1c0 [bluetooth]
>>>> [   25.975217]  [<ffffffffa016fad5>] hci_dev_open+0x275/0x2e0 [bluetooth]
>>>> [   25.975230]  [<ffffffffa0182752>] hci_sock_ioctl+0x1f2/0x3f0 [bluetooth]
>>>> [   25.975238]  [<ffffffff815c6050>] sock_do_ioctl+0x30/0x70
>>>> [   25.975245]  [<ffffffff815c75f9>] sock_ioctl+0x79/0x2f0
>>>> [   25.975254]  [<ffffffff811a8046>] do_vfs_ioctl+0x96/0x560
>>>> [   25.975262]  [<ffffffff811a85a1>] SyS_ioctl+0x91/0xb0
>>>> [   25.975271]  [<ffffffff816d989d>] system_call_fastpath+0x1a/0x1f
>>>> [   25.975276] Code: 89 e5 41 57 41 56 41 89 fe 41 55 49 89 f5 41 54
>>>> 49 89 d4 53 48 83 ec 18 89 7d c8 9c 58 66 66 90 66 90 f6 c4 02 0f 85
>>>> 56 02 00 00 <41> 8b 85 00 01 00 00 a9 00 00 01 00 0f 85 b0 02 00 00 48
>>>> c7 c2
>>>
>>> All code
>>> ========
>>>    0:   89 e5                   mov    %esp,%ebp
>>>    2:   41 57                   push   %r15
>>>    4:   41 56                   push   %r14
>>>    6:   41 89 fe                mov    %edi,%r14d
>>>    9:   41 55                   push   %r13
>>>    b:   49 89 f5                mov    %rsi,%r13
>>>    e:   41 54                   push   %r12
>>>   10:   49 89 d4                mov    %rdx,%r12
>>>   13:   53                      push   %rbx
>>>   14:   48 83 ec 18             sub    $0x18,%rsp
>>>   18:   89 7d c8                mov    %edi,-0x38(%rbp)
>>>   1b:   9c                      pushfq
>>>   1c:   58                      pop    %rax
>>>   1d:   66 66 90                data32 xchg %ax,%ax
>>>   20:   66 90                   xchg   %ax,%ax
>>>   22:   f6 c4 02                test   $0x2,%ah
>>>   25:   0f 85 56 02 00 00       jne    0x281
>>>   2b:*  41 8b 85 00 01 00 00    mov    0x100(%r13),%eax     <-- trapping instruction
>>>   32:   a9 00 00 01 00          test   $0x10000,%eax
>>>   37:   0f 85 b0 02 00 00       jne    0x2ed
>>>   3d:   48                      rex.W
>>>   3e:   c7                      .byte 0xc7
>>>   3f:   c2                      .byte 0xc2
>>>
>>> The second argument %rsi is zero, which got transferred to %r13 and
>>> then offset deref on it trapped.
>>>
>>> The second argument is @wq and the oopsing code is the wq->flags deref
>>> in the following if condition.
>>>
>>>         /* if dying, only works from the same workqueue are allowed */
>>>         if (unlikely(wq->flags & __WQ_DRAINING) &&
>>>                 WARN_ON_ONCE(!is_chained_work(wq)))
>>>                 return;
>>>
>>> So, umm, don't pass in NULL as @wq. :)
>>>
>>
>> [ CC Frederic (linux-dynticks) ]
>>
>> Great, Tejun!
>> Anyway a bug...
>>
>> Just wanted to mention I switched to a full-cpu-dynticks config-setup:
>>
>> 1. TICK_CPU_ACCOUNTING -> VIRT_CPU_ACCOUNTING_GEN
>>
>> 2. [X] NO_HZ_FULL
>>
>> From [2]:
>>
>>  config VIRT_CPU_ACCOUNTING_GEN
>> bool "Full dynticks CPU time accounting"
>> - depends on HAVE_CONTEXT_TRACKING && 64BIT
>> + depends on HAVE_CONTEXT_TRACKING && 64BIT && NO_HZ_FULL
>>
>> Choosing NO_HZ_FULL depends leads to a different kernel-config which
>> seems not to show the trace.
>>
>> - Sedat -
>>
>> [1] http://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/log/?h=timers/nohz
>> [2] http://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=timers/nohz&id=7f40072a53838380e3902d94fae49efed506b34e
>
> Hmm that patch shouldn't change the kernel code itself. Do the warning
> shows unless you run full dynticks?

It changes the kernel-config with the stuff from your tree:

$ diff -uprN /boot/config-3.9.0-rc8-next20130426-3-iniza-small
/boot/config-3.9.0-rc8-next20130426-4-iniza-small | egrep
^'\+CONFIG|\-CONFIG'
-CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_COMMON=y
+CONFIG_NO_HZ_FULL=y
+CONFIG_CONTEXT_TRACKING_FORCE=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y

The -4 build did not show a trace yet... and I can s/r properly.

- Sedat -
