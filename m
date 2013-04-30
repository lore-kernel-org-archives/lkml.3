Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab3D3RzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab3D3RzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:55:11 -0400
Date: Tue, 30 Apr 2013 19:51:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ptrace: PTRACE_DETACH should do
	flush_ptrace_hw_breakpoint(child)
Message-ID: <20130430175138.GA30014@redhat.com>
References: <20130418184350.GA4407@redhat.com> <20130418184425.GA4454@redhat.com> <20130429160931.GD31230@somewhere> <20130429164038.GA27132@redhat.com> <20130429233647.GD1760@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429233647.GD1760@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Frederic Weisbecker wrote:
>
> On Mon, Apr 29, 2013 at 06:40:38PM +0200, Oleg Nesterov wrote:
>
> > No, I think this (minor) problem is very old... At least, when I look
> > at 2.6.26 code I do not see anything which coould clear db regs on
> > detach.
>
> Ok, if so then the conversion to perf hasn't changed much the picture I think.

God knows ;) afaik there are not too much users.

But fyi, this conversion fixed some problems. For example, the content
of db registers we copied by copy_process iirc.

And, I didn't verify this, it seems that the old code didn't set _RF
bit so PTRACE_CONT should probably trigger the same bp again...

> The breakpoints have just stayed persistent across
> tracers.

Yes.

And. This conversion allows us to implement the generic arch-independent
PTRACE_GET/SET_HWBP api, the current PTRACE_{PEEK,POKE}USR(u_debugreg)
api is really awkward.

> > Btw. perhaps flush_ptrace_hw_breakpoint() should also clear the
> > virtual registers like thread.debugreg7 ? Even without this patch,
> > flush_ is also called exec.
>
> Yeah makes sense.

OK, and probably debugreg6 too, but I need to recheck.


Thanks Frederic for your review!

Oleg.

