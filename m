Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaHXOqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:46:06 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43957 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaHXOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:46:05 -0400
Date: Sun, 24 Aug 2014 16:45:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] nohz: Fix double clock write on idle ticks
Message-ID: <20140824144559.GA9455@gmail.com>
References: <1408727373-8166-1-git-send-email-frederic@kernel.org>
 <20140824100734.GA1309@gmail.com>
 <CAFTL4hz8OELwXZ603UUWZQwOQE677CBeS37rB9F1OYNuM9ByOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFTL4hz8OELwXZ603UUWZQwOQE677CBeS37rB9F1OYNuM9ByOA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Le dimanche 24 août 2014, Ingo Molnar <mingo@kernel.org> a écrit :
> 
> > * Frederic Weisbecker <fweisbec@gmail.com <javascript:;>> wrote:
> >
> > > From: Frederic Weisbecker <fweisbec@gmail.com <javascript:;>>
> > >
> > > Ingo,
> > >
> > > Please pull the nohz/drop-double-write-v3 branch that can be found at:
> > >
> > > git://
> > git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > >       nohz/drop-double-write-v3
> > >
> > > Although the 1st patch fixes a bug, it was a longstanding issue so
> > > that branch doesn't need to be applied in 3.17. The next merge window
> > > looks better.
> > >
> > > --
> > > The tick reschedules itself unconditionally. It's relevant in periodic
> > > mode but not in dynticks mode where it results in spurious double clock
> > > writes and even spurious periodic behaviour for low-res case.
> > >
> > > This set fixes that:
> > >
> > > * 1st patch removes low-res periodic tick rescheduling in nohz mode.
> > > This fixes spurious periodic behaviour.
> > >
> > > * 2nd patch does the same for high-res mode. Here there is no such
> > > spurious periodic behaviour but it still spares a double clock write
> > > in some cases.
> > > ---
> > >
> > >
> > > Thanks,
> > >       Frederic
> > > ---
> > >
> > > Viresh Kumar (2):
> > >       nohz: Fix spurious periodic tick behaviour in low-res dynticks mode
> > >       nohz: Avoid tick's double reprogramming in highres mode
> > >
> > >
> > >  kernel/time/tick-sched.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> >
> > > These fixes are pretty small - any objections
> 
> > against putting it into
> > > timers/urgent and including it in v3.17?
> 
> 
> OK sounds good to me. They are easily reverted if any problem arises.

On a second thought, 'spurious periodic behavior' is really just 
sub-optimal full-nohz behavior - it's not an outright 
user-noticeable bug, correct?

Thanks,

	Ingo
