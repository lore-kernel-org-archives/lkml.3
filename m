Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaAGNlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:41:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGNlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:41:24 -0500
Date: Tue, 7 Jan 2014 14:40:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Alex Shi <alex.shi@linaro.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
Message-ID: <20140107134055.GA31570@twins.programming.kicks-ass.net>
References: <20131217153809.GP21999@twins.programming.kicks-ass.net>
 <52B2F5D0.2050707@linaro.org>
 <20131220111926.GA11605@e103034-lin>
 <52BAF292.1070404@linaro.org>
 <20140102160404.GA3000@e103034-lin>
 <52CAB12B.4090701@linaro.org>
 <20140107125518.GE2936@e103034-lin>
 <20140107125930.GW31570@twins.programming.kicks-ass.net>
 <20140107131523.GX3694@twins.programming.kicks-ass.net>
 <CAKfTPtDPc0xQ22f+-5bduK3bEObeUu=QCdOPDL3Xxecgy9VzSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDPc0xQ22f+-5bduK3bEObeUu=QCdOPDL3Xxecgy9VzSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:32:07PM +0100, Vincent Guittot wrote:
> On 7 January 2014 14:15, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Jan 07, 2014 at 01:59:30PM +0100, Peter Zijlstra wrote:
> >> On Tue, Jan 07, 2014 at 12:55:18PM +0000, Morten Rasmussen wrote:
> >> > My understanding is that should_we_balance() decides which cpu is
> >> > eligible for doing the load balancing for a given domain (and the
> >> > domains above). That is, only one cpu in a group is allowed to load
> >> > balance between the local group and other groups. That cpu would
> >> > therefore be reponsible for pulling enough load that the groups are
> >> > balanced even if it means temporarily overloading itself. The other cpus
> >> > in the group will take care of load balancing the extra load within the
> >> > local group later.
> >>
> >> Correct.
> >
> > On that; one of the things I wanted to (and previously did attempt but
> > failed) is trying to rotate this cpu. Currently its always the first cpu
> > (of the group) and that gives a noticeable bias.
> 
> Isn't the current policy (it's the 1st idle cpu in priority). a good
> enough way to rotate the cpus ? Are you need the rotation for loaded
> use case too ?

Yeah its for the fully loaded case. And like I said, there's not been
many complaints on this.

The 'problem' is that its always same cpu that does the most expensive
full machine balance; and always that cpu that is the one that gains
extra load to redistribute in the group. So its penalized twice.

Like said, really minor issue. Just something I thought I'd mention.
