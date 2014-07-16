Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbaGPG6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:58:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:53377 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaGPG6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:58:13 -0400
Date: Wed, 16 Jul 2014 08:58:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 51/55] clocksource: Make delta calculation a function
In-Reply-To: <CALAqxLWE9CdXOpK=UgY19mw835woccfvGg_CqX92D-K67hr3SA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407160857320.24854@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.584242982@linutronix.de> <CALAqxLWE9CdXOpK=UgY19mw835woccfvGg_CqX92D-K67hr3SA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, John Stultz wrote:

> On Fri, Jul 11, 2014 at 6:45 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > @@ -335,16 +335,15 @@ static void timekeeping_update(struct ti
> >   */
> >  static void timekeeping_forward_now(struct timekeeper *tk)
> >  {
> > -       cycle_t cycle_now, cycle_delta;
> > +       cycle_t cycle_now, delta;
> >         struct clocksource *clock;
> >         s64 nsec;
> >
> >         clock = tk->clock;
> >         cycle_now = clock->read(clock);
> > -       cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > -       tk->cycle_last = clock->cycle_last = cycle_now;
> > +       delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
> 
> Errr.. Was dropping the update to tk->cycle_last and clock->cycle_last
> intended? That seems broken.

Grr, was definitely not intended.
