Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaARXoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 18:44:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:41362 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751493AbaARXoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 18:44:14 -0500
Date: Sat, 18 Jan 2014 18:44:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption
 checks
Message-ID: <20140118184401.48b32cb3@gandalf.local.home>
In-Reply-To: <20140116211214.581197e5.akpm@linux-foundation.org>
References: <20140116235751.084728c8@gandalf.local.home>
	<20140116211214.581197e5.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 21:12:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 16 Jan 2014 23:57:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > When PROVE_LOCKING and PREEMPT is configured, the preempt state
> > tracking is active. Testing this out, I added a module that did the
> > following:
> 
> So I assume your kernel at least has no instances of this bug, so we
> don't need the patch ;) It *is* a fairly daft thing to do.
> 
> Maybe stick it in -next for a few months, see if anyone hits it?

Stephen,

Do you have any objections if I add this change to my for-next branch?
I'll do it as a merge as I do not plan on having it go into the next
release. But this is an extension to lockdep that when both
PROVE_LOCKING and PREEMPT are enabled, it can catch a certain bug. But
as Andrew has stated, it did not find any in the kernel that I'm
running.

What I propose is to have this go into linux-next, as I assume that
people test it with PROVE_LOCKING and PREEMPT enabled, and if someone
adds this bug this patch will catch it (if the bug path is taken).
Hopefully it would be reported and we know two things. One, someone
added a bug, and two, this patch is useful to add to mainline.

Here's the catch 22, it may not be worth adding to mainline if it never
catches any bugs. But we wont know that unless we add it to mainline.
Maybe adding it to linux-next might be good enough for now.

-- Steve
