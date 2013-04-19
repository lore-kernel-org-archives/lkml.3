Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967815Ab3DSBhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 21:37:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20977 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967641Ab3DSBhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 21:37:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,505,1363158000"; 
   d="scan'208";a="39768883"
Message-ID: <51709FE1.20807@codeaurora.org>
Date: Thu, 18 Apr 2013 18:37:37 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] hrtimer: Consider preemption when migrating hrtimer
 cpu_bases
References: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org> <1365628068-32738-2-git-send-email-mbohan@codeaurora.org> <alpine.LFD.2.02.1304181138290.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304181138290.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/2013 2:40 AM, Thomas Gleixner wrote:
> On Wed, 10 Apr 2013, Michael Bohan wrote:
>
>> When switching to a new cpu_base in switch_hrtimer_base(), we
>> briefly enable preemption by unlocking the cpu_base lock in two
>> places. During this interval it's possible for the running thread
>> to be swapped to a different CPU.
>>
>> Consider the following example:
>>
>> CPU #0                                 CPU #1
>> ----                                   ----
>> hrtimer_start()                        ...
>>   lock_hrtimer_base()
>>   switch_hrtimer_base()
>>    this_cpu = 0;
>>    target_cpu_base = 0;
>>    raw_spin_unlock(&cpu_base->lock)
>> <migrate to CPU 1>
>
> Errm. switch_hrtimer_base() is called with interrupts disabled and
> they stay disabled, so how exactly is the task going to be migrated?

My mistake - I missed that important fact. Please disregard this.

Thanks,
Mike

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
