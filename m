Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaA0FLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:11:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaA0FLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:11:02 -0500
Message-ID: <1390799444.5425.61.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: paulmck@linux.vnet.ibm.com, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 27 Jan 2014 06:10:44 +0100
In-Reply-To: <1390626760.3625.17.camel@marge.simpson.net>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <20131224193636.GD19211@linux.vnet.ibm.com>
	 <1387940854.5373.8.camel@marge.simpson.net>
	 <20131225075544.GE19211@linux.vnet.ibm.com>
	 <1387993057.5346.17.camel@marge.simpson.net>
	 <20140117171441.GG5785@linutronix.de>
	 <1390015514.5444.46.camel@marge.simpson.net>
	 <20140124195014.GB29981@linutronix.de>
	 <1390626760.3625.17.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:WCvccncKRa+tlvPVgZJp9z3Xe49zbRSz/NA9VciSY4x
 51zho2EbOTz2vyjrQRA6fZIRmg1AGRNREGJqF+iIu1HIq830jn
 x4qupGN8TOGAiUs8wRuhDyUM/C7bGdWIczdQKqpOLlEqAMj4Ze
 Y1wWpoJmJATpmLpp+uhK/Q5TfCfNrptDJevinV511xeT1+ETv7
 uinYW/HoLy7y1BdJbDRgVCvebFs5k0MQkQVRoFzo6VXoPvnM8V
 eII1lL32gzGglDTwk6HKsA1/S/vXsRIHPXk+HTNb6L5/4Gv1z6
 q79Sfcz3FnDct6yPpYOKFGPmsdmeaPNp3J4ribR62AUkVRAITU
 ooUghreWQlpXuwGzk9HZq/TMD0rdQNNbUkrX14jny9OXhM3uLU
 8Ily5ThnHhW+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-25 at 06:12 +0100, Mike Galbraith wrote: 
> On Fri, 2014-01-24 at 20:50 +0100, Sebastian Andrzej Siewior wrote: 
> > * Mike Galbraith | 2014-01-18 04:25:14 [+0100]:
> > 
> > >> ># timers-do-not-raise-softirq-unconditionally.patch
> > >> ># rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch
> > >> >
> > >> >..those two out does seem to have stabilized the thing.
> > >> 
> > >> timers-do-not-raise-softirq-unconditionally.patch is on its way out.
> > >> 
> > >> rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch confues me.
> > >> Didn't you report once that your box deadlocks without this patch? Now
> > >> your 64way box on the other hand does not work with it?
> > >
> > >If 'do not raise' is applied, 'use a trylock' won't save you.  If 'do
> > is this just an observation or you do know why it won't save me?
> 
> It's an observation from beyond the grave from the 64 core box that it
> repeatedly did NOT save :)  Autopsy photos below.
> 
> I've built 3.12.8-rt9 with Stevens v2 "timer: Raise softirq if there's
> irq_work" to see if it'll survive.

And it did, configured both as nohz_tick, and nohz_full_all.  The irqs
are enabled warning in can_stop_full_tick() fired for nohz_full_all, but
that's it.

For grins, I also applied Paul's v3 timer latency series while testing
nohz_full_all config.   The box was heavily loaded the vast majority of
the time, but it didn't explode or do anything obviously evil.

-Mike

