Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaAGPmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:42:03 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48642 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750933AbaAGPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:41:54 -0500
Date: Tue, 7 Jan 2014 15:41:54 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20140107154154.GH2936@e103034-lin>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52B87149.4010801@arm.com>
 <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107141059.GY3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:10:59PM +0000, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 02:22:20PM +0100, Peter Zijlstra wrote:
> 
> I just realized there's two different p's in there.
> 
> > Ah, another way of looking at it is that the avg without blocked
> > component is a 'now' picture. It is the load we are concerned with right
> > now.
> > 
> > The more blocked we add the further out we look; with the obvious limit
> > of the entire averaging period.
> > 
> > So the avg that is runnable is right now, t_0; the avg that is runnable +
> > blocked is t_0 + p, where p is the avg period over which we expect the
> > blocked contribution to appear.
> 
> So the above p for period, is unrelated to the below p which is a
> probability function.
> 
> > So something like:
> > 
> >   avg = runnable + p(i) * blocked; where p(i) \e [0,1]
> > 
> > could maybe be used to replace the cpu_load array and still represent
> > the concept of looking at a bigger picture for larger sets. Leaving open
> > the details of the map p.
> 
> We probably want to assume task wakeup is constant over time, so p (our
> probability function) should probably be an exponential distribution.

Ah, makes more sense now.

You propose that we don't actually try keep track of which tasks that
might wake up when, but just factor in more and more of the blocked load
depending on how conservative the load estimate we want?

I think that could work if we sort of the priority scaling issue that I
mentioned before.
