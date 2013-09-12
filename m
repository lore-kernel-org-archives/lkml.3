Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3ILSnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:43:49 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:59180 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3ILSnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:43:47 -0400
Date: Thu, 12 Sep 2013 15:43:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912184341.GA11400@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 12, 2013 at 11:10:37AM -0700, Linus Torvalds escreveu:
> On Thu, Sep 12, 2013 at 11:03 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > When I compiled "perf" at the same time as doing a big kernel compile,
> > the kernel compile failed
 
> Oops. That may actually have been me being a bit *too* eager with a
> "make allmodconfig" build. I can't reproduce it, and I'm starting to
> suspect that I instead had two kernel compiles going, not one kernel
> compile and a tools/perf/ compile.
 
>   "Yo Dawg, I heard you like kernel compiles, so I put a kernel
> compile in your kernel compile so that you can compile the kernel
> while you compile the kernel".

:-)
 
> But at least the "make install" problem is repeatable, though.

Well, I just tried it, and the only thing that gets rebuilt are the CHK
environment tests that try to figure out what can be built into perf,
i.e. perl, python, libaudit, etc.

Its something that annoys me as well, but not so much as to make me
figure out how to make those be done only if some source file changed.

But then, if you remove, say, libelf from your system so that you get a
perf tool that uses just /proc/kallsyms, it wouldn't detect it...

Perhaps in that case we should say: want a new build with a different
environment? Do a 'make clean' first.

But if I do it as a normal user and then try installing as root... it
behaves like you described, duh :-\

Because of this:

    * new build flags or prefix

Will check...

- Arnaldo
