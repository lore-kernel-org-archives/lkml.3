Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3CZNGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:06:40 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43817 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3CZNGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <1364302242.5053.19.camel@laptop>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-5-git-send-email-vincent.guittot@linaro.org>
	<1364302242.5053.19.camel@laptop>
Date: Tue, 26 Mar 2013 14:06:38 +0100
Message-ID: <CAKfTPtA0xpGmyKr6pqiV9wjv4ZQ_xQGjR=+7h_xTe_LLA+Do9A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/6] sched: secure access to other CPU statistics
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 13:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>> @@ -3364,13 +3364,16 @@ done:
>>  static bool is_buddy_busy(int cpu)
>>  {
>>         struct rq *rq = cpu_rq(cpu);
>> +       u32 sum = rq->avg.runnable_avg_sum;
>> +       u32 period = rq->avg.runnable_avg_period;
>> +
>> +       sum = min(sum, period);
>
> OK this makes sense; use a simple sanity constraint instead of going
> overboard on serialization -- however, why is this a separate patch?

There is no real reason other than explaining why I have added this
additional check

>
> That is, this could easily be part of the patch that introduces
> is_buddy_busy(); also you likely want part of this patch's changelog
> to become a comment that goes right above this min() :-)

Yes, i 'm going to do that

>
