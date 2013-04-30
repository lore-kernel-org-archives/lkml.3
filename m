Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123Ab3D3QXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:23:08 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51530 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761071Ab3D3QXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:23:05 -0400
Date: Tue, 30 Apr 2013 18:23:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v3.10
Message-ID: <20130430162300.GB28821@gmail.com>
References: <20130430065808.GA19736@gmail.com>
 <CA+55aFwcX3oKYCFbq4XcX7Y2Yk6BWWKY4TRNOyfeZ9rYrQMRNQ@mail.gmail.com>
 <20130430153512.GA21930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430153512.GA21930@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Tue, Apr 30, 2013 at 07:49:43AM -0700, Linus Torvalds wrote:
> > On Mon, Apr 29, 2013 at 11:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > Please pull the latest sched-core-for-linus git tree from:
> > >
> > > The main changes in this development cycle were:
> > >
> > >   - full dynticks preparatory work by Frederic Weisbecker
> > 
> > Why does this have the crappy cputime scaling overflow code, when we
> > had a long thread about how to do it right *without* any 64-bit
> > divides, including a quality-tested patch?
> > 
> > This still has the garbage "div64_u64_rem()" crap which actually SLOWS
> > DOWN 32-bit code even when not used (becuse it makes "div64_u64()"
> > calculate it even when unnecessary.
> > 
> > WTF happened here? I and others spent efforts so that we wouldn't need
> > this kind of crap.
> 
> I'm sorry, I was on vacations and has some other work to do, so I didn't
> send patches in timely manner. I just posted them today.

Linus, would you like me to revert d9a3c9823a2e and re-send the pull 
request?

I intended to queue up Stanislaw's fixes in sched/urgent as the real 
solution, but they arrived earlier today and are too fresh.

Thanks,

	Ingo
