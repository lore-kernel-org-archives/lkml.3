Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3HETCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3HETCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:02:36 -0400
Date: Mon, 5 Aug 2013 20:57:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805185712.GA12225@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130805184625.GA11633@redhat.com> <CA+55aFzWcOXfiJGzF1sVgZFaM_hRSF25P2kC2Ga_b0177jfjYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWcOXfiJGzF1sVgZFaM_hRSF25P2kC2Ga_b0177jfjYA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Linus Torvalds wrote:
>
> On Mon, Aug 5, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Heh. I pulled wine-git.
> >
> > set_thread_context() does a lot of PTRACE_POKEUSER requests and then
> > it calls resume_after_ptrace() which simply does PTRACE_DETACH.
> >
> > I'll recheck tomorrow, but it really looks as if it _wants_ to leak
> > the debug registers after detach. And more, it does PTRACE_ATTACH
> > only to set these regs.
> >
> > And this is exactly what fab840f tries to prevent.
>
> Ok, so I guess it's effectively the ABI, and we should just make the
> rule be that "if you don't want stale breakpoints, then remove the
> breakpoints when you detach".

I'm afraid yes.

> And thus reverting it the right thing to do. Agreed?

Yes, yes, sure. I'll write the changelog and send git-revert tomorrow,
unless you do it yourself.

Oleg.

