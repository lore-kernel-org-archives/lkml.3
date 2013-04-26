Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3DZPqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:46:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:26015 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab3DZPq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,559,1363158000"; 
   d="scan'208";a="293659683"
Message-ID: <517AA14D.7060202@linux.intel.com>
Date: Fri, 26 Apr 2013 08:46:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC PATCH v4 00/14] sched: packing small tasks
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org> <517A969B.5040606@linux.intel.com> <CAKfTPtCwdw1mYpWRFbPo9zT=9vFANpJyubh1eX-0vJLqrqizgA@mail.gmail.com>
In-Reply-To: <CAKfTPtCwdw1mYpWRFbPo9zT=9vFANpJyubh1eX-0vJLqrqizgA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>>
>> so I got to ask the hard question; what percentage of system level (not just
>> cpu level)
>> power consumption gain can you measure (pick your favorite workload)...
>>
>
> I haven't system level figures for my patches but only for the cpu
> subsystem. If we use the MP3 results in the back of my mail, they show
> an improvement of 37 % (113/178) for the CPU subsystem of the
> platform. If we assume that the CPU subsystem contributes 25% of an
> embedded system power consumption (this can vary across platform
> depending of the use of HW accelerator but it should be a almost fair
> percentage), the patch can impact the power consumption on up to 9%.
>

sadly the math tends to not work quite that easy;
memory takes significantly more power when the system is not idle than when it is idle for example. [*]
so while reducing cpu power by making it run a bit longer (at lower frequency or
slower core or whatever) is a pure win if you only look at the cpu, but it may
(or may not) be a loss when looking at a whole system level.

I've learned the hard way that you cannot just look at the cpu numbers; you must look
at the whole-system power when playing with such tradeoffs.

That does not mean that your patch is not useful; it very well can be, but
without having looked at whole-system power that's a very dangerous conclusion to make.
So.. if you get a chance, I'd love to see data on a whole-system level... even for just one workload
and one system
(playing mp3 sounds like a quite reasonable workload for such things indeed)


[*] I assume that on your ARM systems, memory goes into self refresh during system idle just as it does on x86

