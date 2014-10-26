Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaJZO3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:29:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:52271 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZO3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:29:09 -0400
Date: Sun, 26 Oct 2014 15:29:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Silverman <bsilver16384@gmail.com>
cc: Austin Schuh <austin.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Darren Hart <darren@dvhart.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task
 death
In-Reply-To: <CAP01z6LmQfacDzrHmbW=hBGjn35qhMcNTTp8XhdM3DDnhoX9Xw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410261528270.5308@nanos>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com> <alpine.DEB.2.11.1410252047570.5308@nanos> <CAP01z6LmQfacDzrHmbW=hBGjn35qhMcNTTp8XhdM3DDnhoX9Xw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Brian Silverman wrote:
> On Sat, 25 Oct 2014, Thomas Gleixner wrote:
> 
> > > pi_state_free and exit_pi_state_list both clean up futex_pi_state's.
> > > exit_pi_state_list takes the hb lock first, and most callers of
> > > pi_state_free do too. requeue_pi didn't, which causes lots of problems.
> >
> > "causes lots of problems" is not really a good explanation of the root
> > cause. That wants a proper description of the race, i.e.
> >
> > CPU 0              CPU 1
> > ...                ....
> >
> > I'm surely someone who is familiar with that code, but it took me
> > quite some time to understand whats going on. The casual reader will
> > just go into brain spiral mode and give up.
> 
> Thinking about it again, I'm no longer so sure that exit_pi_state_list is the
> only place that it can race against. However, I did catch that one with a
> particularly lucky crashdump, so I know it _can_ happen there. Is just
> giving an example for that good?

Sure. That immediately makes clear whats going on.

Thanks,

	tglx
