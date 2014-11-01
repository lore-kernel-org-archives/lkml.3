Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaKACbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:31:09 -0400
Received: from ozlabs.org ([103.22.144.67]:57446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaKACbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:31:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: Re: [PATCH] x86_64, entry: Fix out of bounds read on sysenter
In-Reply-To: <a27467328f7607b4f45a6c37e731c1f3e047f4a7.1414803784.git.luto@amacapital.net>
References: <CALCETrWJ4-PaLpceb7NCm6pKgkNXh77x1F6XHHxafcvBRFAoxg@mail.gmail.com> <a27467328f7607b4f45a6c37e731c1f3e047f4a7.1414803784.git.luto@amacapital.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 01 Nov 2014 12:58:55 +1030
Message-ID: <874muj4pso.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> Rusty noticed a Really Bad Bug (tm) in my NT fix.  The entry code
> reads out of bounds, causing the NT fix to be unreliable.  But, and
> this is much, much worse, if your stack is somehow just below the
> top of the direct map (or a hole), you read out of bounds and crash.
>
> Excerpt from the crash:
>
> [    1.129513] RSP: 0018:ffff88001da4bf88  EFLAGS: 00010296
>
>   2b:*    f7 84 24 90 00 00 00     testl  $0x4000,0x90(%rsp)
>
> That read is deterministically above the top of the stack.  I
> thought I even single-stepped through this code when I wrote it to
> check the offset, but I clearly screwed it up.
>
> Fixes 8c7aa698baca x86_64, entry: Filter RFLAGS.NT on entry from userspace
>
> Reported-by: Rusty Russell <rusty@ozlabs.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Tested-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks for the fast response...
Rusty.
