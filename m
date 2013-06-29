Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3F2WrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 18:47:20 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63660 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3F2WrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 18:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyVOSa7gOVuBVQqK+wQkgc_2+KZ3Ejx9gPYF=o_Lc3sqg@mail.gmail.com>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
	<1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com>
	<51CF422E.7030803@hp.com>
	<CA+55aFyVOSa7gOVuBVQqK+wQkgc_2+KZ3Ejx9gPYF=o_Lc3sqg@mail.gmail.com>
Date: Sat, 29 Jun 2013 15:47:17 -0700
X-Google-Sender-Auth: 0K7lvhqs4ik71YUkSyvV1mrC5kE
Message-ID: <CA+55aFxxUoJYXbN4yqeAbKNKEYpcVMLwopmDuh7sPhT5jnqOEw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 2:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> STEP 1:
>
>  - create a new set of config option (say
> "CONFIG_[ARCH_]SPINLOCK_REFCOUNT") that defaults to 'y' and isn't
> actually asked about anywhere.

That "defauls to 'y'" was incomplete/misleading. The
ARCH_SPINLOCK_REFCOUNT config option should default to 'n' (the
example code snippet did that correctly: a bool config option defaults
to 'n' unless stated otherwise).

The SPINLOCK_REFCOUNT in turn _should_ have a "default y" (the sample
snippet I posted didn't have that), but that 'y' is then obviously
normally disabled by the "depends on" logic, so it only takes effect
when ARCH_SPINLOCK_REFCOUNT is set, and none of the spinlock debug
things are enabled.

I hope that was all fairly obvious from the concept (and the real
examples of us already doing things like this with the whole
CONFIG_GENERIC_STRNLEN_USER and CONFIG_DCACHE_WORD_ACCESS examples),
but I thought I'd follow up with an explicit correction, since both
the explanation and sample snippets were somewhat misleading.

                Linus
