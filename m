Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3H2QnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:43:10 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:52556 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3H2QnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130829070012.GC27322@gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
Date: Thu, 29 Aug 2013 09:43:07 -0700
X-Google-Sender-Auth: nQCytZfcTM1tUKZiLsxdtWbrBMA
Message-ID: <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 12:00 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Lockrefs are combiend spinlock+count objects that fit into a
> MESI-cacheline and can be accessed via the cmpxchg8b() primitives and
> allow smart combined operations on the count field without necessarily
> taking the lock.

Side note: I'm going to finally build a new desktop, and made sure
that I got a CPU that supports TSX. I'm not convinced transactional
memory ends up being usable in general without hardware support for
predicting transaction success, but using transactions to do small
specialized things like this may well be worth it. Especially since
the cmpxchg approach has some issues.

We'll see. The real problem is that I'm not sure if I can even see the
scalability issue on any machine I actually personally want to use
(read: silent). On my current  system I can only get up to 15%
_raw_spin_lock by just stat'ing the same file over and over and over
again from lots of threads.

             Linus
