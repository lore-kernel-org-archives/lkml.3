Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaFDVjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:39:41 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56629 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890AbaFDVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:39:39 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and provide it to scheduler
Date: Wed, 04 Jun 2014 23:56:55 +0200
Message-ID: <2484761.vkWavnsDx3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com> <20140604160230.GS29593@e103034-lin> <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 04, 2014 07:27:12 PM Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 05:02:30PM +0100, Morten Rasmussen wrote:
> > On Tue, Jun 03, 2014 at 12:50:15PM +0100, Peter Zijlstra wrote:
> > > On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> > > > +static struct capacity_state cap_states_cluster_a7[] = {
> > > > +	/* Cluster only power */
> > > > +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> > > > +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> > > > +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> > > > +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> > > > +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> > > > +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> > > > +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> > > > +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> > > > +	};
> > > 
> > > So one thing I remember was that we spoke about restricting this to
> > > frequency levels where the voltage changed.
> > > 
> > > Because voltage jumps were the biggest factor to energy usage.
> > > 
> > > Any word on that?
> > 
> > Since we don't drive P-state changes from the scheduler, I think we
> > could leave out P-states from the table without too much trouble. Good
> > point.
> 
> Well, we eventually want to go there I think. Although we still needed
> to come up with something for Intel, because I'm not at all sure how all
> that works.

Do you mean power numbers or how P-states work on Intel in general?

Rafael

