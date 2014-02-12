Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaBLMfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:35:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53584 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBLMfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:35:17 -0500
Message-ID: <52FB6A83.9080800@linaro.org>
Date: Wed, 12 Feb 2014 13:35:15 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] cpuidle/idle: Move the cpuidle_idle_call function
 to idle.c
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org> <1392131491-5265-2-git-send-email-daniel.lezcano@linaro.org> <52FB5061.1000709@linux.vnet.ibm.com>
In-Reply-To: <52FB5061.1000709@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 11:43 AM, Preeti U Murthy wrote:
> Hi Daniel,
>
> On 02/11/2014 08:41 PM, Daniel Lezcano wrote:
>> The cpuidle_idle_call does nothing more than calling the three individuals
>> function and is no longer used by any arch specific code but only in the
>> cpuidle framework code.
>>
>> We can move this function into the idle task code to ensure better
>> proximity to the scheduler code.
>
> So my understanding of this patchset is that by moving
> cpuidle_idle_call() under kernel/sched, we now have a way of calling
> into the cpuidle governor and the cpuidle driver with additional
> parameters like cpu_load(), idle_stamp etc.. so that we can expect the
> governor and driver to take better decisions about entry and exit into
> idle states. Is this the advantage we hope to begin with?

Yes, right.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

