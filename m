Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbaGDLGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:06:08 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47426 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757877AbaGDLGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:06:06 -0400
Date: Fri, 4 Jul 2014 12:06:13 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware
 scheduling
Message-ID: <20140704110612.GA6120@e103034-lin>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140703231950.GA4881@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703231950.GA4881@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuyang,

On Fri, Jul 04, 2014 at 12:19:50AM +0100, Yuyang Du wrote:
> Hi Morten,
> 
> On Fri, Jul 04, 2014 at 12:25:47AM +0800, Morten Rasmussen wrote:
> > * Note that these energy savings are _not_ representative of what can be
> > achieved on a true SMP platform where all cpus are equally 
> > energy-efficient. There should be benefit for SMP platforms as well, 
> > however, it will be smaller.
> > 
> > The energy model led to consolidation of the short tasks on the A7
> > cluster (more energy-efficient), while sysbench made use of all cpus as
> > the A7s didn't have sufficient compute capacity to handle the five
> > tasks.
> 
> Looks like this patchset is mainly for big.LITTLE?

No, not at all. The only big.LITTLE in there is the test platform but
that has been configured to be as close as possible to an SMP platform.
That is, no performance difference between cpus. I would have preferred
a true SMP platform for testing, but this is the only dual-cluster
platform that I have access to with proper mainline kernel support.

The patch set essentially puts tasks where it is most energy-efficient
guided by the platform energy model. That should benefit any platform,
SMP and big.LITTLE. That is at least the goal.

On an SMP platform with two clusters/packages (whatever you call a group
of cpus sharing the same power domain) you get task consolidation on a
single cluster if the energy model says that it is beneficial. Very much
like your previous proposals. It is also what I'm trying to show with
the numbers I have included.

That said, we are of course keeping in mind what would be required to
make this work for big.LITTLE. However, there is nothing big.LITTLE
specific in the patch set. Just the possibility of having different
energy models for different cpus in the system. We will have to add some
tweaks eventually to get the best out of big.LITTLE later. Somewhat
similar to what exists today for better SMT support and other
architecture specialities.

> And can the patchset actually replace Global Task Scheduling?

Global Task Scheduling is (ARM) marketing speak for letting the
scheduler know about all cpus in a big.LITTLE system. It is not an
actual implementation. There is an out-of-tree implementation of GTS
available which is very big.LITTLE specific.

The energy model driven scheduling proposed here is not big.LITTLE
specific, but aims at introducing generic energy-awareness in the
scheduler. Once energy-awareness is in place, most of the support needed
for big.LITTLE will be there too. It is generic energy-aware code that
is capable of making informed decisions based on the platform model,
big.LITTLE or SMP.

The short answer is: Not in its current state, but if we get the
energy-awareness right it should be able to.

Morten
