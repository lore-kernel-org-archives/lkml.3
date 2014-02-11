Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaBKRP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:15:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:60201 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbaBKRPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:15:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="453631750"
Message-ID: <52FA59E2.1000802@linux.intel.com>
Date: Tue, 11 Feb 2014 09:12:02 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org> <52EBC645.2040607@linux.intel.com> <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr> <20140203125441.GD19029@e103034-lin> <52EFA9D3.1030601@linux.intel.com> <20140203145605.GL8874@twins.programming.kicks-ass.net> <52EFC12B.50704@linux.intel.com> <20140211164136.GT27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140211164136.GT27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/2014 8:41 AM, Peter Zijlstra wrote:
> On Mon, Feb 03, 2014 at 08:17:47AM -0800, Arjan van de Ven wrote:
>> On 2/3/2014 6:56 AM, Peter Zijlstra wrote:
>> if there's a simple api like
>>
>> sched_cpu_cache_wiped(int llc)
>>
>> that would be very nice for this; the menuidle side knows this
>> for some cases and thus can just call it. This would be a very
>> small and minimal change
>>
>> * if you don't care about llc vs core local caches then that
>>    parameter can go away
>>
>> * I assume this is also called for the local cpu... if not then we
>>    need to add a cpu number argument
>>
>> * we can also call this from architecture code when wbinvd or the
>>    arm equivalent is called etc
>
> A little something like so?
>

is there value also in doing a cpu level cache flush?
(cpu cache flush we know from the C state, for the llc cache flush we need to read an MSR
on x86. Not insane expensive but not zero either)


