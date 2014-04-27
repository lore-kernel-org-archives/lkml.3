Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaD0NHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 09:07:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56489 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752252AbaD0NG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 09:06:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Date: Sun, 27 Apr 2014 15:23:24 +0200
Message-ID: <1586415.tT6O0p7OWR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140426061744.GB1944@gmail.com>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <15044031.LGKXdkz8J7@vostro.rjw.lan> <20140426061744.GB1944@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 26, 2014 08:17:44 AM Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > > > Well, so now the question is whether or not we relly want to 
> > > > always go to the "power" (or "energy efficiency" if you will) 
> > > > mode if the system is on battery.  That arguably may not be a 
> > > > good thing even for energy efficiency depending on how exactly 
> > > > the modes are defined.
> > > 
> > > Nobody is talking about always. But in general it seems a good 
> > > enough approach. Hell, many of the AC/BAT switches in todays power 
> > > management crap things are not always right.
> > > 
> > > Do I want it to dim the LCD further when I unplug the laptop -- 
> > > mostly no, but still it does. And the most annoying one is that it 
> > > reduces the screen blank time to something near 5 seconds or so.
> > > 
> > > Why would this be any different?
> > 
> > And why do we have to do things that we hate it when they are done 
> > by others?
> 
> He replied to your question of 'do we want to act on power events'.
> 
> The answer is: yes, from the scheduler point of view we want to act on 
> power events by default, and if a user does not want that default 
> behavior, it's not an unprecedented request and GUIs offer various 
> ways to tweak screen dimming and other power saving details.
> 
> So "trying to save power" is the default everywhere, and the scheduler 
> wants to do the same. The main reason we couldn't do this before was 
> that the scheduler's 'power saving mode' was dysfunctional. That is 
> being fixed.
> 
> So lets try this, it's high time.

Thanks for stating your perspective clearly, this is good to know.

Still, I have a rather fundamental problem with the notion that performance
and energy efficiency are essentially at odds with each other, because quite
often they aren't.  What is good for performance is often good for energy
efficiency as well (like when it may be better to do a certain amount of work
quickly and then go idle instead of slowing down and taking more time to do
the work, because that time may turn out to be so long that energy used for
doing the work will actually be greater).  So while I'm all for acting on power
events, I'm also for being rather careful with that.

Moreover, in fact performance and energy efficiency are not the only factors
that need to be taken into account, there also is the maximum power draw (ie.
the rate of using energy) that can be sustained.  Arguably, all three of them
always matter, regardless of whether or not the system is on battery.

People often mentally translate energy efficiency into battery life, because
that's probably the most obvious case, but in fact it generally translates into
the cost of doing work (in therms of money or other things).  Going to battery
means something like "energy is now more valuable to me", but there may be other
events meaning the same (for example, energy may be cheaper in the night etc).
So it looks like we need a global mechanism to represent the current relative
value of energy to the user and to update it whenever something like "we're on
battery now" happens (other subsystems would benefit from that too IMO).

The same applies to the maximum sustainable power draw limit more or less.
While it generally changes between "on battery" and "on AC power", it may also
depend on other factors like the capacity of the available power supply for a
data center.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
