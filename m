Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaFDQcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbaFDQct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:32:49 -0400
Date: Wed, 4 Jun 2014 18:31:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140604163129.GB23724@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <20140603140529.048701b9@gandalf.local.home> <20140603192525.GA1105@redhat.com> <20140603211651.79263d7e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603211651.79263d7e@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Steven Rostedt wrote:
>
> On Tue, 3 Jun 2014 21:25:25 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 06/03, Steven Rostedt wrote:
> > >
> > > You know, this code could use some comments. I may send you a patch,
> > > because that __lock_task_sighand() is doing a lot of subtle things and
> > > there's not a single comment explaining it :-(
> >
> > Yes, agreed. Not only SLAB_DESTROY_BY_RCU is not obvious, local_irq_save()
> > is not clear at all. The latter already has a doc patch from Paul, I'll try
> > to add more comments on top once I see that patch in Linus's tree.
> >
> > But I would be happy if you send the patch ;)
> >
> > And this reminds me... I still think that __lock_task_sighand() should be
> > de-uglified. I already sent the patch, probably I'll resend it.
>
> I'd be happy to document the hell out of that function, but it sounds
> like you have some updates to it.

Paul has, I don't know where ;) That patch adds the comments to explain the
mysterious local_irq_disable() at the start. On top of another patch which
documents the subtle problems with preemption and rcu_read_unlock().

As for the cleanup I have, it is nowhere and I'll resend it later.

Oleg.

