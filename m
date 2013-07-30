Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3G3Jf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:35:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41788 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab3G3JfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:35:25 -0400
Date: Tue, 30 Jul 2013 11:35:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
Message-ID: <20130730093519.GP3008@twins.programming.kicks-ass.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:12:49PM +0800, Ethan Zhao wrote:
> On Mon, Jul 29, 2013 at 6:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The test case does not involve anything hrtimer related. Do you have
> > CONFIG_SCHED_HRTICK enabled?
> >
> 
> Yes.  it is default configured in stable release.
> CONFIG_SCHED_HRTICK=y

Should still be disabled by default even if supported:

# grep HRTICK kernel/sched/features.h
SCHED_FEAT(HRTICK, false)


> > First of all we want to know, which particular hrtimer is causing that
> > issue. If it is the hrtick one, then I really have to ask why you want
> > to use it at all in such a high performance scenario.
> >
> >  Any advice about the HZ in high performance scenario ? hrtimer tick
> Is not fit for high performance ?

Hence why its disabled, programming the timer hardware is too expensive.
But since you didn't even know that I suspect you aren't in fact using
it.

It would be good if you could do what Thomas suggested and look at which
timer is actually active during your workload.
