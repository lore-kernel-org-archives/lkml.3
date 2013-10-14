Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3JNPzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:55:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56056 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3JNPzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:55:51 -0400
Date: Mon, 14 Oct 2013 16:55:55 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 3/7] sched: power: go_faster/slower power driver
 hints
Message-ID: <20131014155555.GN31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
 <20131014134809.GE28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20131014134809.GE28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Oct 2013 15:55:47.0531 (UTC) FILETIME=[D91B49B0:01CEC8F5]
X-MC-Unique: 113101416554900301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:48:09PM +0100, Peter Zijlstra wrote:
> On Fri, Oct 11, 2013 at 06:19:13PM +0100, Morten Rasmussen wrote:
> > +static inline void inc_cpu_capacity(int cpu)
> > +{
> > +	if (weighted_cpuload(cpu) > power_of(cpu))
> > +		go_faster(cpu, 0);
> > +}
> > +
> > +static inline void dec_cpu_capacity(int cpu)
> > +{
> > +	if (weighted_cpuload(cpu) < power_of(cpu))
> > +		go_slower(cpu, 0);
> > +}
> 
> It seems wrong to me to use weighted_cpuload() here; that contains the
> task weight, which is irrelevant to power usage. I would expect a pure
> utilization term here.
> 
> Something like:
> 
>   se->avg.runnable_avg_sum / se->avg.runnable_avg_period
> 

Fully agree. There is no unweighted equivalent to cfs.runnable_load_avg
but we could add it. It would be very useful for the power-aware
scheduling. It will add some overhead though.

Morten

