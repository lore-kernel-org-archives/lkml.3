Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab3KMSPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:15:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3KMSOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:14:51 -0500
Date: Wed, 13 Nov 2013 19:15:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: oom-kill && frozen()
Message-ID: <20131113181543.GA22041@redhat.com>
References: <1384264396-14550-1-git-send-email-geert@linux-m68k.org> <20131112141314.GQ5056@laptop.programming.kicks-ass.net> <AE90C24D6B3A694183C094C60CF0A2F6026B7405@saturn3.aculab.com> <20131112145243.GU5056@laptop.programming.kicks-ass.net> <20131112162136.GA29065@redhat.com> <20131112165643.GA31278@redhat.com> <20131113032053.GA19394@mtj.dyndns.org> <20131113170724.GA17739@redhat.com> <20131113174220.GQ21461@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113174220.GQ21461@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Peter Zijlstra wrote:
>
> On Wed, Nov 13, 2013 at 06:07:24PM +0100, Oleg Nesterov wrote:
> > 	4. Finally, change try_to_wake_up() path to do
> >
> > 		-	p->state = TASK_WAKING;
> > 		+	p->state &= ~state;
> > 		+	if (p->state & ~(TASK_DEAD | TASK_WAKEKILL | TASK_PARKED))
> > 		+		return;
> > 		+	else
> > 		+		p->state = TASK_WAKING;
> >
> > 	   IOW, if the task sleeps in, say, TASK_INTERRUPTIBLE | __TASK_FROZEN
> > 	   then it need both try_to_wake_up(TASK_INTERRUPTIBLE) and
> > 	   try_to_wake_up(__TASK_FROZEN) to wake up.
>
> > Tejun, Peter, do you think this makes any sense? I am just curious, but
> > "selective wakeup" looks potentially useful.
>
> I've never looked at any of this freeze stuff, so I cannot comment too
> much. However we should be very careful not to add too much to relative
> hot paths for the relative rare case of freezing stuff.

Yes, yes, sure.

Plus my description was confusing and incomplete (and I am sure I missed
something more). I forgot to mention that freeze_task() should also add
the FROZEN state if it sees FROZEN qualifier, this needs more changes.

So please forget. May be I'll _try_ to make something working (at least
for discussion), but I am not sure.

Oleg.

