Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3DZPke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:40:34 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:42765 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3DZPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <517A969B.5040606@linux.intel.com>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<517A969B.5040606@linux.intel.com>
Date: Fri, 26 Apr 2013 17:40:27 +0200
Message-ID: <CAKfTPtCwdw1mYpWRFbPo9zT=9vFANpJyubh1eX-0vJLqrqizgA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/14] sched: packing small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 17:00, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 4/25/2013 10:23 AM, Vincent Guittot wrote:
>>
>> Hi,
>>
>> This patchset takes advantage of the new per-task load tracking that is
>> available in the kernel for packing the tasks in as few as possible
>> CPU/Cluster/Core. It has got 2 packing modes:
>> -The 1st mode packs the small tasks when the system is not too busy. The
>> main
>> goal is to reduce the power consumption in the low system load use cases
>> by
>> minimizing the number of power domain that are enabled but it also keeps
>> the
>> default behavior which is performance oriented.
>> -The 2nd mode packs all tasks in as few as possible power domains in order
>> to
>> improve the power consumption of the system but at the cost of possible
>> performance decrease because of the increase of the rate of ressources
>> sharing
>> compared to the default mode.
>
>
>
> so I got to ask the hard question; what percentage of system level (not just
> cpu level)
> power consumption gain can you measure (pick your favorite workload)...
>

I haven't system level figures for my patches but only for the cpu
subsystem. If we use the MP3 results in the back of my mail, they show
an improvement of 37 % (113/178) for the CPU subsystem of the
platform. If we assume that the CPU subsystem contributes 25% of an
embedded system power consumption (this can vary across platform
depending of the use of HW accelerator but it should be a almost fair
percentage), the patch can impact the power consumption on up to 9%.

> on x86 (even on the low power stuff) I expect this to be very far into the
> noise
> (since we have per core power gates, and power transitions are pretty fast)
>
> you have some numbers in the back of your mail, but it's hard for me to get
> a conclusion out of
> that (they either measure only cpu power, or are just vague in general)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
