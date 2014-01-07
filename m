Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaAGKnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:43:13 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41870 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaAGKnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:43:11 -0500
Message-ID: <52CBD96B.4050103@linux.vnet.ibm.com>
Date: Tue, 07 Jan 2014 16:09:39 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, Morten.Rasmussen@arm.com,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@linaro.org,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net> <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52CBCB85.8050607@linux.vnet.ibm.com> <20140107095039.GA2480@laptop.programming.kicks-ass.net>
In-Reply-To: <20140107095039.GA2480@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010710-7182-0000-0000-0000097D83F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 03:20 PM, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 03:10:21PM +0530, Preeti U Murthy wrote:
>> What if we want to add arch specific flags to the NUMA domain? Currently
>> with Peter's patch:https://lkml.org/lkml/2013/11/5/239 and this patch,
>> the arch can modify the sd flags of the topology levels till just before
>> the NUMA domain. In sd_init_numa(), the flags for the NUMA domain get
>> initialized. We need to perhaps call into arch here to probe for
>> additional flags?
> 
> What are you thinking of? I was hoping all NUMA details were captured in
> the distance table.
> 
> Its far easier to talk of specifics in this case.
> 
If the processor can be core gated, then there is very little power
savings that we could yield from consolidating all the load onto a
single node in a NUMA domain. 6 cores on one node or 3 cores each on two
nodes, the power is drawn by 6 cores in all. So I was thinking under
this circumstance we might want to set the SD_SHARE_POWERDOMAIN flag at
the NUMA domain and spread the load if it favours the workload.

Regards
Preeti U Murthy

