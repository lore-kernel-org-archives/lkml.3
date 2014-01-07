Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaAGMcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:32:01 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:50566 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAGMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:31:54 -0500
MIME-Version: 1.0
In-Reply-To: <52CBD96B.4050103@linux.vnet.ibm.com>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52CBCB85.8050607@linux.vnet.ibm.com> <20140107095039.GA2480@laptop.programming.kicks-ass.net>
 <52CBD96B.4050103@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 7 Jan 2014 13:31:33 +0100
Message-ID: <CAKfTPtAVTW6w5QPQW5c3Gcf6VSU07E5PA+MrFdp-aP1m9twNLA@mail.gmail.com>
Subject: Re: [RFC] sched: CPU topology try
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jon Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, james.hogan@imgtec.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2014 11:39, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 01/07/2014 03:20 PM, Peter Zijlstra wrote:
>> On Tue, Jan 07, 2014 at 03:10:21PM +0530, Preeti U Murthy wrote:
>>> What if we want to add arch specific flags to the NUMA domain? Currently
>>> with Peter's patch:https://lkml.org/lkml/2013/11/5/239 and this patch,
>>> the arch can modify the sd flags of the topology levels till just before
>>> the NUMA domain. In sd_init_numa(), the flags for the NUMA domain get
>>> initialized. We need to perhaps call into arch here to probe for
>>> additional flags?
>>
>> What are you thinking of? I was hoping all NUMA details were captured in
>> the distance table.
>>
>> Its far easier to talk of specifics in this case.
>>
> If the processor can be core gated, then there is very little power
> savings that we could yield from consolidating all the load onto a
> single node in a NUMA domain. 6 cores on one node or 3 cores each on two
> nodes, the power is drawn by 6 cores in all. So I was thinking under
> this circumstance we might want to set the SD_SHARE_POWERDOMAIN flag at
> the NUMA domain and spread the load if it favours the workload.

The policy of keeping the tasks running on cores that are close (same
node) to the memory, is the more power efficient, isn't it ? so it's
probably more about where to place the memory than about where to
place the tasks ?

Vincent

>
> Regards
> Preeti U Murthy
>
