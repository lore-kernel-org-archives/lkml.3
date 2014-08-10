Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaHJQII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 12:08:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38540 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaHJQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 12:08:05 -0400
Date: Sun, 10 Aug 2014 18:07:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Flipped jump labels
Message-ID: <20140810160756.GB9490@pd.tnic>
References: <20140809105742.GA5910@pd.tnic>
 <20140810061103.GA13968@gmail.com>
 <20140810061303.GA14206@gmail.com>
 <20140810153539.GA9490@pd.tnic>
 <20140810154515.GA27199@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140810154515.GA27199@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 05:45:15PM +0200, Ingo Molnar wrote:
> Indeed - but could we use that interface to cleanly expose the
> arch_static_branch_active() code you've written, or do we need new
> variants?

We could probably.

The thing is, if we want to do the _active thing, the whole jump labels
infrastructure would need to know about those, let's call them "new
types" because they'd need different handling when enabling - see
__jump_label_transform() in arch/x86/kernel/jump_label.c with all the
NOP checks.

Which begs the more important question: is adding those just to save us
a JMP penalty justify the additional code complexity. Frankly, I'm still
on the fence here and I'd rather do some perf measurements of a kernel
build with and without the JMP in native_sched_clock() to see whether it
is even noticeable or it disappears in the noise.

Because if it does disappear, the whole trouble is just for nothing.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
