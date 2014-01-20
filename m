Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaATP2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:28:10 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47944 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaATP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:28:06 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20140121001048.778ba63226f9f87c7bb920ee@canb.auug.org.au>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
	<20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	<20140116222536.GX30183@twins.programming.kicks-ass.net>
	<20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
	<52D8625C.1000902@zytor.com>
	<20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
	<1390038366.5676.10.camel@marge.simpson.net>
	<20140120145122.a95b3e3a17d20117214098ca@canb.auug.org.au>
	<CA+icZUVNdEkE0uR2gn0iY790sKKFzG7Py2mPqqJN+pUNiuYXDw@mail.gmail.com>
	<CA+icZUWqLg+8i6RAEZbPBdoe_cbXvyjzSHSOugFeNhDw5FfJ1Q@mail.gmail.com>
	<20140121001048.778ba63226f9f87c7bb920ee@canb.auug.org.au>
Date: Mon, 20 Jan 2014 16:28:05 +0100
Message-ID: <CA+icZUW_f+bVy=u8mz+9B+sqWodOH-Wb8EKFfZAtBQzXHde-6w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Galbraith <bitbucket@online.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 2:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sedat,
>
> On Mon, 20 Jan 2014 09:46:55 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> On Mon, Jan 20, 2014 at 9:42 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > On Mon, Jan 20, 2014 at 4:51 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >> On Sat, 18 Jan 2014 10:46:06 +0100 Mike Galbraith <bitbucket@online.de> wrote:
>> >>>
>> >>> I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
>> >>> Q6600 box.  See below for an alternative.
>> >>>
>> >>> idle: kill unnecessary mwait_idle() resched IPIs
>> >>
>> >> OK, so despite even further discussion, I have applied this as a merge
>> >> fix patch for today.  Let me know when it is all sorted out.
>> >>
>> >
>> > Where is this fix?
>> > ( Browsing Linux-next remote GIT repository online. )
>> > 2x NOPE for me.
>> >
>> > - Sedat -
>> >
>> > [1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/?id=next-20140120&qt=grep&q=mwait_idle
>> > [2] http://git.kernel.org/cgit/linux/kernel/git/sfr/next-fixes.git
>> >
>>
>> Hmmm... Found this in Next/merge.log
>>
>> +$ git am -3 ../patches/0001-x86-idle-mwait_idle-merge-update.patch
>> +Applying: idle: kill unnecessary mwait_idle() resched IPIs
>> +$ git reset HEAD^
>> +Unstaged changes after reset:
>> +M arch/x86/include/asm/processor.h
>> +M arch/x86/kernel/process.c
>
> You missed the next three lines:
>
> $ git add -A .
> $ git commit -v -a --amend
> [master 65d9a14a9a41] Merge remote-tracking branch 'tip/auto-latest'
>

[ I was absent for a while from Linux-next, so I am asking for clarification. ]
[ I might be wrong. ]

What does that mean?
AFAICS you applied an important fix by yourself on top of tip/auto-latest?

>> Is this a local patch not shipped in the Linux-next (remote) GIT repo?
>> Why is this not in your next-fixes GIT repo?
>
> Its part of the conflict resolution for the merge of the tip tree.  It
> cannot go into my fixes tree - that is for fixes to bugs in Linus' tree
> until they are integrated there.  The tip and pm trees are both fine on
> their own, but combined they don't.  So this fix has to go into the actual
> merge commit for the merge of the later tree.   When Linus' merges the
> later of these trees he will also need this fix - or a better one - which
> is what is still under discussion.
>

I was asking in general about next-fixes to have a "bootable" (aka
working) Linux-next kernel.

You see next-fixes as a place to fix Linus-tree, seriously?

The question here in this special case seems to be a "logical"
(not-working-together) problem between tip and pm.

And we are in a merge-window...

>> A bit confused about your -next policies,
>
> Any better?
>

Not really.
You should clarify on what you are doing in your next-fixes tree.
Your daily report for Linux-next releases even does not mention next-fixes.

Looking through my INBOX Thierry had the initial idea of "fixes for
linux-next" when you were on vacation and he took over maintainership.

- Sedat -
