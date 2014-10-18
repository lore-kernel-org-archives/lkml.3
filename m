Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaJRDfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 23:35:16 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:59537 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaJRDfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 23:35:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkRjk4Oe8iftfHhorjPLZ4bdi3AEveYkHmBsqbH+7R3oLSckA@mail.gmail.com>
References: <CAHFgRy-xjQk6VD1DjBRM3sNu3VMttCt5bygTvyd8voYGhbcbBw@mail.gmail.com>
	<CAHkRjk4Oe8iftfHhorjPLZ4bdi3AEveYkHmBsqbH+7R3oLSckA@mail.gmail.com>
Date: Fri, 17 Oct 2014 23:35:13 -0400
Message-ID: <CAHFgRy8R6FB_n9Ps46=AGF-42yvpdn+1qAPHVFM4hYCPAq1o0w@mail.gmail.com>
Subject: Re: Linus GIT 3.17.0+ - BUG: unable to handle kernel paging request -
 IP: [<ffffffff81109e8d>] scan_block+0x59/0x100
From: Miles Lane <miles.lane@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:02 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Hi Miles,
>
> On 15 October 2014 04:43, Miles Lane <miles.lane@gmail.com> wrote:
>> [   68.164917] BUG: unable to handle kernel paging request at ffff88021dc52000
>> [   68.164957] IP: [<ffffffff81109e8d>] scan_block+0x59/0x100
>> [   68.164987] PGD 2902067 PUD 2905067 PMD 21fdf2067 PTE 800000021dc52060
>
> My reading of the x86 _PAGE_BIT_* macros show that this is not present.
>
>> [   68.165020] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>
> And this could be caused by CONFIG_DEBUG_PAGEALLOC, though kmemleak
> should not try to access such memory.
>
>> [   68.165945] Call Trace:
>> [   68.165960]  [<ffffffff81528559>] ? _raw_spin_lock_irqsave+0x48/0x52
>> [   68.165988]  [<ffffffff8110a016>] ? scan_gray_list+0xe2/0x15f
>> [   68.166015]  [<ffffffff81109feb>] scan_gray_list+0xb7/0x15f
>> [   68.166040]  [<ffffffff8110a32f>] kmemleak_scan+0x29c/0x466
>> [   68.166066]  [<ffffffff8110a84d>] ? kmemleak_write+0x354/0x354
>> [   68.166092]  [<ffffffff8110a8cf>] kmemleak_scan_thread+0x82/0xa4
>
> I have a couple of questions:
>
> 1. Are there any messages prior to the dump you posted, like kmemleak
> getting disabled?

There are no indications of problems with kmemleak before the BUG.
This is all I see:

[    5.111054] kmemleak: Kernel memory leak detector initialized
[    5.111062] kmemleak: Automatic memory scanning thread started

> 2. Can you still reproduce the problem with !CONFIG_DEBUG_PAGEALLOC?

When I disable this option, the BUG does not occur.

> Thanks,
>
> Catalin
