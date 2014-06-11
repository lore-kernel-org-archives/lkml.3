Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaFKMCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:02:41 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:65322 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaFKMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:02:40 -0400
Date: Wed, 11 Jun 2014 07:43:26 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Yuyang Du <yuyang.du@intel.com>,
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
Message-ID: <20140611114325.GA7094@developer>
References: <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140606121305.GA8571@gmail.com>
 <20140606122740.GA9318@gmail.com>
 <alpine.LFD.2.11.1406062224090.25775@knanqh.ubzr>
 <20140609082739.GY29593@e103034-lin>
 <alpine.LFD.2.11.1406090920540.25775@knanqh.ubzr>
 <20140611110251.GA6702@developer>
 <20140611114218.GI1581@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611114218.GI1581@e103034-lin>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:42:18PM +0100, Morten Rasmussen wrote:
> On Wed, Jun 11, 2014 at 12:02:51PM +0100, Eduardo Valentin wrote:
> > Hello,
> > 
> > On Mon, Jun 09, 2014 at 09:22:49AM -0400, Nicolas Pitre wrote:
> > > On Mon, 9 Jun 2014, Morten Rasmussen wrote:
> > > 
> > > > On Sat, Jun 07, 2014 at 03:33:58AM +0100, Nicolas Pitre wrote:
> > > > > On Fri, 6 Jun 2014, Ingo Molnar wrote:
> > > > > 
> > > > > > In any case, even with turbo frequencies, switching power use is 
> > > > > > probably an order of magnitude higher than leakage current power use, 
> > > > > > on any marketable chip, so we should concentrate on being able to 
> > > > > > cover this first order effect (P/work ~ V^2), before considering any 
> > > > > > second order effects (leakage current).
> > > > > 
> > > > > Just so that people are aware... We'll have to introduce thermal 
> > > > > constraint management into the scheduler mix as well at some point.  
> > > > > Right now what we have is an ad hoc subsystem that simply monitors 
> > > > > temperature and apply crude cooling strategies when some thresholds are 
> > > > > met. But a better strategy would imply thermal "provisioning".
> > > > 
> > > > There is already work going on to improve thermal management:
> > > > 
> > > > http://lwn.net/Articles/599598/
> > > > 
> > > > The proposal is based on power/energy models (too). The goal is to
> > 
> > Can you please point me to the other piece of code which is using
> > power/energy models too?  We are considering having these models within
> > the thermal software compoenents. But if we already have more than one
> > user, might be worth considering a separate API.
> 
> The link above is to the thermal management proposal which includes a
> power model. This one might work better:
> 
> http://article.gmane.org/gmane.linux.power-management.general/45000
> 
> The power/energy model in this energy-aware scheduling proposal is
> different. An example of the model data is in patch 6 (the start of this
> thread) and the actual use of the model is in patch 11 and the following
> patches. As said below, the two proposals are independent, but there
> might be potential for merging the power/energy models once the
> proposals are more mature.

Morten,

For the power allocator thermal governor, I am aware, as I am reviewing
it. I am more interested in other users of power models, a part from
thermal subsystem.

> 
> Morten
> 
> >  
> > > > allocate power intelligently based on performance requirements.
> > > 
> > > Ah, great!  I missed that.
> > > 
> > > > While it is related to energy-aware scheduling and I fully agree that it
> > > > is something we need to consider, I think it is worth developing the two
> > > > ideas in parallel and look at sharing things like the power model later
> > > > once things mature. Energy-aware scheduling is complex enough on its
> > > > own to keep us entertained for a while :-)
> > > 
> > > Absolutely.  This is why I said "at some point".
> > > 
> > > 
> > > Nicolas
