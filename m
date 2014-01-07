Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaAGLUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:20:05 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13695 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751030AbaAGLUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:20:03 -0500
Date: Tue, 7 Jan 2014 11:20:01 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140107112001.GD2936@e103034-lin>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52CBCB85.8050607@linux.vnet.ibm.com>
 <20140107095039.GA2480@laptop.programming.kicks-ass.net>
 <52CBD96B.4050103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CBD96B.4050103@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:39:39AM +0000, Preeti U Murthy wrote:
> On 01/07/2014 03:20 PM, Peter Zijlstra wrote:
> > On Tue, Jan 07, 2014 at 03:10:21PM +0530, Preeti U Murthy wrote:
> >> What if we want to add arch specific flags to the NUMA domain? Currently
> >> with Peter's patch:https://lkml.org/lkml/2013/11/5/239 and this patch,
> >> the arch can modify the sd flags of the topology levels till just before
> >> the NUMA domain. In sd_init_numa(), the flags for the NUMA domain get
> >> initialized. We need to perhaps call into arch here to probe for
> >> additional flags?
> > 
> > What are you thinking of? I was hoping all NUMA details were captured in
> > the distance table.
> > 
> > Its far easier to talk of specifics in this case.
> > 
> If the processor can be core gated, then there is very little power
> savings that we could yield from consolidating all the load onto a
> single node in a NUMA domain. 6 cores on one node or 3 cores each on two
> nodes, the power is drawn by 6 cores in all.

Not being a NUMA expert, I would have thought that load consolidation at
node level would nearly always save power even when cpus can be power
gated individually. The number of cpus awake is the same, but you only
need to power the caches, memory, and other node peripherals for one
node instead of two in your example. Wouldn't that save power?

Memory/cache intensive workloads might benefit from spreading at node
level though. 

Am I missing something?

Morten
