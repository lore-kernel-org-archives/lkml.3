Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbbAFK3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:29:54 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37602 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbAFK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:29:53 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20150106094039.GI29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
	<20150106094039.GI29390@twins.programming.kicks-ass.net>
Date: Tue, 6 Jan 2015 11:29:51 +0100
Message-ID: <CA+icZUVPSFS343qWTEpNggnmD_ex8N72Zm5RE9vvXrcRvBFCJg@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 10:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jan 06, 2015 at 05:49:11AM +0100, Sedat Dilek wrote:
>> This has been there since just before rc1. Is there a fix for this
>> stalled in someones git tree maybe ?
>>
>> [    7.952588] WARNING: CPU: 0 PID: 299 at kernel/sched/core.c:7303
>> __might_sleep+0x8d/0xa0()
>> [    7.952592] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff910a0f7a>] prepare_to_wait+0x2a/0x90
>> [    7.952595] CPU: 0 PID: 299 Comm: systemd-readahe Not tainted 3.19.0-rc3+ #100
>
>> [    7.952620]  [<ffffffff911a63e0>] fanotify_read+0xe0/0x5b0
>
>
> http://marc.info/?l=linux-kernel&m=141874374029791

I included below include in my patch and inotify_user.c has it...
...
+#include <linux/wait.h>
...

Will you send out a proper patch when people confirm it solves their
issue within fanotify area?

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/notify/inotify/inotify_user.c#n40
