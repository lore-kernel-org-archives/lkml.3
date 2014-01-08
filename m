Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbaAHNde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:33:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57986 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbaAHNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:33:32 -0500
Date: Wed, 8 Jan 2014 14:32:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140108133257.GF31570@twins.programming.kicks-ass.net>
References: <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
 <20140107154154.GH2936@e103034-lin>
 <20140107204951.GD2480@laptop.programming.kicks-ass.net>
 <20140108123534.GI2936@e103034-lin>
 <20140108124534.GD31570@twins.programming.kicks-ass.net>
 <20140108132739.GK2936@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108132739.GK2936@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:27:39PM +0000, Morten Rasmussen wrote:
> On Wed, Jan 08, 2014 at 12:45:34PM +0000, Peter Zijlstra wrote:
> > On Wed, Jan 08, 2014 at 12:35:34PM +0000, Morten Rasmussen wrote:
> > > > Currently we detect overload by sg.nr_running >= sg.capacity, which can
> > > > be very misleading because while a cpu might have a task running 'now'
> > > > it might be 99% idle.
> > > > 
> > > > At which point I argued we should change the capacity thing anyhow. Ever
> > > > since the runnable_avg patch set I've been arguing to change that into
> > > > an actual utilization test.
> > > > 
> > > > So I think that if we measure overload by something like >95% utilization
> > > > on the entire group the load scaling again makes perfect sense.
> > > 
> > > I agree that it make more sense to change the overload test to be based
> > > on some tracked load. How about the non-overloaded case? Load balancing
> > > would have to be based on unweighted task loads in that case?
> > 
> > Yeah, until we're overloaded our goal is to minimize idle time.
> 
> I would say, make the most of the available cpu cycles. Minimizing idle
> time is not always the right thing to do when considering power
> awareness.
> 
> If we know the actual load of the tasks, we may be able to consolidate

I think we must start to be careful with the word load, I think you
meant to say utilization. 

> them on fewer cpus and save power by idling cpus. In that case the idle
> time (total) is unchanged (unless the P-state is changed). Somewhat
> similar to the video use-case running on 1, 2, and 4 cpu that I reposted
> yesterday.

But fair enough.. Its idle time when you consider CPUs to always run at
max frequency, but clearly I must stop thinking about CPUs like that :-)
