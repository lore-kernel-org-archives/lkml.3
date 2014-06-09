Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaFII1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:27:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:22453 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755221AbaFII1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:27:44 -0400
Date: Mon, 9 Jun 2014 09:27:39 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20140609082739.GY29593@e103034-lin>
References: <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140606121305.GA8571@gmail.com>
 <20140606122740.GA9318@gmail.com>
 <alpine.LFD.2.11.1406062224090.25775@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406062224090.25775@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 03:33:58AM +0100, Nicolas Pitre wrote:
> On Fri, 6 Jun 2014, Ingo Molnar wrote:
> 
> > In any case, even with turbo frequencies, switching power use is 
> > probably an order of magnitude higher than leakage current power use, 
> > on any marketable chip, so we should concentrate on being able to 
> > cover this first order effect (P/work ~ V^2), before considering any 
> > second order effects (leakage current).
> 
> Just so that people are aware... We'll have to introduce thermal 
> constraint management into the scheduler mix as well at some point.  
> Right now what we have is an ad hoc subsystem that simply monitors 
> temperature and apply crude cooling strategies when some thresholds are 
> met. But a better strategy would imply thermal "provisioning".

There is already work going on to improve thermal management:

http://lwn.net/Articles/599598/

The proposal is based on power/energy models (too). The goal is to
allocate power intelligently based on performance requirements.

While it is related to energy-aware scheduling and I fully agree that it
is something we need to consider, I think it is worth developing the two
ideas in parallel and look at sharing things like the power model later
once things mature. Energy-aware scheduling is complex enough on its
own to keep us entertained for a while :-)

Morten
