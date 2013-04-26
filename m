Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3DZPAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:00:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:39415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3DZPAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:00:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,559,1363158000"; 
   d="scan'208";a="326630349"
Message-ID: <517A969B.5040606@linux.intel.com>
Date: Fri, 26 Apr 2013 08:00:43 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, amit.kucheria@linaro.org,
        corbet@lwn.net, l.majewski@samsung.com
Subject: Re: [RFC PATCH v4 00/14] sched: packing small tasks
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2013 10:23 AM, Vincent Guittot wrote:
> Hi,
>
> This patchset takes advantage of the new per-task load tracking that is
> available in the kernel for packing the tasks in as few as possible
> CPU/Cluster/Core. It has got 2 packing modes:
> -The 1st mode packs the small tasks when the system is not too busy. The main
> goal is to reduce the power consumption in the low system load use cases by
> minimizing the number of power domain that are enabled but it also keeps the
> default behavior which is performance oriented.
> -The 2nd mode packs all tasks in as few as possible power domains in order to
> improve the power consumption of the system but at the cost of possible
> performance decrease because of the increase of the rate of ressources sharing
> compared to the default mode.


so I got to ask the hard question; what percentage of system level (not just cpu level)
power consumption gain can you measure (pick your favorite workload)...

on x86 (even on the low power stuff) I expect this to be very far into the noise
(since we have per core power gates, and power transitions are pretty fast)

you have some numbers in the back of your mail, but it's hard for me to get a conclusion out of
that (they either measure only cpu power, or are just vague in general)


