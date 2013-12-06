Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3LFAPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:15:04 -0500
Received: from one.firstfloor.org ([193.170.194.197]:54166 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3LFAO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:14:57 -0500
Date: Fri, 6 Dec 2013 01:14:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131206001454.GB21717@two.firstfloor.org>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
 <87fvq9cwlk.fsf@tassilo.jf.intel.com>
 <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
 <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1M skb alloc/free 185660 (usecs)
> 
> the difference is bigger now: 484-145 vs 185-145

Thanks for the data. 

This is a obvious improvement, but imho not big enough to be extremely
compelling (< cost 1-2 cache misses, no orders of magnitude improvements
that would justify a lot of code)

One larger problem I have with your patchkit is where exactly it fits
with the user base.

In my experience there are roughly two groups of trace users:
kernel hackers and users. The kernel hackers want something
convenient and fast, but for anything complicated or performance
critical they can always hack the kernel to include custom 
instrumentation.

Your code requires a compiler, so from my perspective it 
wouldn't be a lot easier or faster to use than just changing 
the code directly and recompile.

The users want something simple too that shields them from
having to learn all the internals. They don't want to recompile.
As far as I can tell your code is a bit too low level for that,
and the requirement for the compiler may also scare them.

Where exactly does it fit?

-Andi

