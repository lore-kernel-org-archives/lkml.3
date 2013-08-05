Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3HESUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:20:31 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:42662 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3HESUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <1375725328.22073.101.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
Date: Mon, 5 Aug 2013 11:20:29 -0700
X-Google-Sender-Auth: 8FGN9_yeVujS-z8jVxndz8rkrdM
Message-ID: <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 10:55 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> My main concern is with tracepoints. Which on 90% (or more) of systems
> running Linux, is completely off, and basically just dead code, until
> someone wants to see what's happening and enables them.

The static_key_false() approach with minimal inlining sounds like a
much better approach overall. Sure, it might add a call/ret, but it
adds it to just the unlikely tracepoint taken path.

Of course, it would be good to optimize static_key_false() itself -
right now those static key jumps are always five bytes, and while they
get nopped out, it would still be nice if there was some way to have
just a two-byte nop (turning into a short branch) *if* we can reach
another jump that way..For small functions that would be lovely. Oh
well.

                Linus
