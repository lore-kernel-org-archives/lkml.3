Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaFKLDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:03:05 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:42883 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKLDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:03:03 -0400
Date: Wed, 11 Jun 2014 07:02:51 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Yuyang Du <yuyang.du@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140611110251.GA6702@developer>
References: <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140606121305.GA8571@gmail.com>
 <20140606122740.GA9318@gmail.com>
 <alpine.LFD.2.11.1406062224090.25775@knanqh.ubzr>
 <20140609082739.GY29593@e103034-lin>
 <alpine.LFD.2.11.1406090920540.25775@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406090920540.25775@knanqh.ubzr>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 09, 2014 at 09:22:49AM -0400, Nicolas Pitre wrote:
> On Mon, 9 Jun 2014, Morten Rasmussen wrote:
> 
> > On Sat, Jun 07, 2014 at 03:33:58AM +0100, Nicolas Pitre wrote:
> > > On Fri, 6 Jun 2014, Ingo Molnar wrote:
> > > 
> > > > In any case, even with turbo frequencies, switching power use is 
> > > > probably an order of magnitude higher than leakage current power use, 
> > > > on any marketable chip, so we should concentrate on being able to 
> > > > cover this first order effect (P/work ~ V^2), before considering any 
> > > > second order effects (leakage current).
> > > 
> > > Just so that people are aware... We'll have to introduce thermal 
> > > constraint management into the scheduler mix as well at some point.  
> > > Right now what we have is an ad hoc subsystem that simply monitors 
> > > temperature and apply crude cooling strategies when some thresholds are 
> > > met. But a better strategy would imply thermal "provisioning".
> > 
> > There is already work going on to improve thermal management:
> > 
> > http://lwn.net/Articles/599598/
> > 
> > The proposal is based on power/energy models (too). The goal is to

Can you please point me to the other piece of code which is using
power/energy models too?  We are considering having these models within
the thermal software compoenents. But if we already have more than one
user, might be worth considering a separate API.
 
> > allocate power intelligently based on performance requirements.
> 
> Ah, great!  I missed that.
> 
> > While it is related to energy-aware scheduling and I fully agree that it
> > is something we need to consider, I think it is worth developing the two
> > ideas in parallel and look at sharing things like the power model later
> > once things mature. Energy-aware scheduling is complex enough on its
> > own to keep us entertained for a while :-)
> 
> Absolutely.  This is why I said "at some point".
> 
> 
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
