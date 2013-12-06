Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079Ab3LFFQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 00:16:48 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53937 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3LFFQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 00:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <871u1qwzae.fsf@tassilo.jf.intel.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131206001454.GB21717@two.firstfloor.org>
	<52A12421.2040208@zytor.com>
	<871u1qwzae.fsf@tassilo.jf.intel.com>
Date: Thu, 5 Dec 2013 21:16:43 -0800
Message-ID: <CAMEtUuz93gN3vQ7K8yVFquSabLXjW=OXj8RFjAkAO9vgY26Hrg@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 5:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> the difference is bigger now: 484-145 vs 185-145
>
> This is a obvious improvement, but imho not big enough to be extremely
> compelling (< cost 1-2 cache misses, no orders of magnitude improvements
> that would justify a lot of code)

hmm. we're comparing against ktap here…
which has 5x more kernel code and 8x slower in this test...

> Your code requires a compiler, so from my perspective it
> wouldn't be a lot easier or faster to use than just changing
> the code directly and recompile.
>
> The users want something simple too that shields them from
> having to learn all the internals. They don't want to recompile.
> As far as I can tell your code is a bit too low level for that,
> and the requirement for the compiler may also scare them.
>
> Where exactly does it fit?

the goal is to have llvm compiler next to perf, wrapped in a user friendly way.

compiling small filter vs recompiling full kernel…
inserting into live kernel vs rebooting …
not sure how you're saying it's equivalent.

In my kernel debugging experience current tools (tracing, systemtap)
were rarely enough.
I always had to add my own printks through the code, recompile and reboot.
Often just to see that it's not the place where I want to print things
or it's too verbose.
Then I would adjust printks, recompile and reboot again.
That was slow and tedious, since I would be crashing things from time to time
just because skb doesn't always have a valid dev or I made a typo.
For debugging I do really need something quick and dirty that lets me
add my own printk
of whatever structs I want anywhere in the kernel without crashing it.
That's exactly what bpf tracing filters do.
