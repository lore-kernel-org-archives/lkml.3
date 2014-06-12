Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaFLPNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:13:14 -0400
Received: from fbr03.mfg.siteprotect.com ([64.26.60.138]:39912 "EHLO
	fbr03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaFLPNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:13:11 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2014 11:13:10 EDT
Date: Thu, 12 Jun 2014 11:05:12 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Morten Rasmussen <morten.rasmussen@arm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
In-Reply-To: <20140606142958.GX29593@e103034-lin>
Message-ID: <alpine.DEB.2.10.1406121101110.23499@pianoman.cluster.toy>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com> <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com> <20140603114428.GY11096@twins.programming.kicks-ass.net> <20140604154227.GR29593@e103034-lin> <20140604161618.GQ30445@twins.programming.kicks-ass.net>
 <20140606131510.GV29593@e103034-lin> <20140606134303.GQ13930@laptop.programming.kicks-ass.net> <20140606142958.GX29593@e103034-lin>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.5399C1A1.025F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Morten Rasmussen wrote:

> On Fri, Jun 06, 2014 at 02:43:03PM +0100, Peter Zijlstra wrote:
> > On Fri, Jun 06, 2014 at 02:15:10PM +0100, Morten Rasmussen wrote:
> > > > > ARM TC2 has on-chip energy counters for counting energy consumed by the
> > > > > A7 and A15 clusters. They are fairly accurate. 
> > > > 
> > > > Recent Intel chips have that too; they come packaged as:
> > > > 
> > > >   perf stat -a -e "power/energy-cores/" -- cmd
> > > > 
> > > > (through the perf_event_intel_rapl.c driver), It would be ideal if the
> > > > ARM equivalent was available through a similar interface.
> > > > 
> > > > http://lwn.net/Articles/573602/
> > > 
> > > Nice. On ARM it is not mandatory to have energy counters and what they
> > > actually measure if they are implemented is implementation dependent.
> > > However, each vendor does extensive evaluation and characterization of
> > > their implementation already, so I don't think would be a problem for
> > > them to provide the numbers.
> > 
> > How is the ARM energy thing exposed? Through the regular PMU but with
> > vendor specific events, or through a separate interface, entirely vendor
> > specific?
> 
> There is an upstream hwmon driver for TC2 already with an easy to use
> sysfs interface for all the energy counters. So it is somewhat vendor
> specific at the moment unfortunately.

What is the plan about future interfaces for energy info?

Intel RAPL of course has a perf_event interface.

However AMD's (somewhat unfortunately acronymed) Application Power 
Management exports similar information via hwmon and the fam15h_power
driver.

And it sounds like ARM systems also put things in hwmon.

User tools like PAPI can sort of abstract this (for example it supports 
getting RAPL data from perf_event while it also has a driver for getting 
info from hwmon).  But users stuck with perf end up having to use multiple 
tools to get energy and performance info simultaneously on non-intel 
hardware.

Vince
