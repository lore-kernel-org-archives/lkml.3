Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3C0EsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:48:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:43233 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3C0EsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="308969029"
Message-ID: <51527A08.8060207@intel.com>
Date: Wed, 27 Mar 2013 12:48:08 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364301443.5053.9.camel@laptop> <5152768B.3020306@linux.vnet.ibm.com>
In-Reply-To: <5152768B.3020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 12:33 PM, Preeti U Murthy wrote:
> Hi Peter,
> 
> On 03/26/2013 06:07 PM, Peter Zijlstra wrote:
>> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>>> +static bool is_light_task(struct task_struct *p)
>>> +{
>>> +       /* A light task runs less than 20% in average */
>>> +       return ((p->se.avg.runnable_avg_sum  * 5) <
>>> +                       (p->se.avg.runnable_avg_period));
>>> +}
>>
>> OK, so we have a 'problem' here, we initialize runnable_avg_* to 0, but
>> we want to 'assume' a fresh task is fully 'loaded'. IIRC Alex ran into
>> this as well.
>>
>> PJT, do you have any sane solution for this, I forgot what the result
>> of the last discussion was -- was there any?
> 
> The conclusion after last discussion between PJT and Alex was that the
> load contribution of a fresh task be set to "full" during "__sched_fork()".
> 
> task->se.avg.load_avg_contrib = task->se.load.weight during
> __sched_fork() is reflected in the latest power aware scheduler patchset
> by Alex.

Yes, the new forked runnable load was set as full utilisation in V5
power aware scheduling. PJT, Mike and I both agree on this. PJT just
discussion how to give the full load to new forked task. and we get
agreement in my coming V6 power aware scheduling patchset.

> 
> Thanks
> 
> Regards
> Preeti U Murthy
>>
> 


-- 
Thanks Alex
