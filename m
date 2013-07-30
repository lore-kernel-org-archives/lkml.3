Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3G3Dwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:52:36 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54200 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab3G3Dwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:52:35 -0400
Message-ID: <51F73847.6090002@linux.vnet.ibm.com>
Date: Tue, 30 Jul 2013 09:21:35 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/3] cpuidle/powernv: cpuidle backend driver
 for powernv
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090137.7291.36657.stgit@deepthi.in.ibm.com> <51F35A2A.1080408@linaro.org> <51F67E96.6040008@linux.vnet.ibm.com> <51F681E7.1060609@linaro.org>
In-Reply-To: <51F681E7.1060609@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073003-5490-0000-0000-000003E7E896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:23 PM, Daniel Lezcano wrote:
> On 07/29/2013 04:39 PM, Deepthi Dharwar wrote:
>> Hi Daniel,
>>
>> On 07/27/2013 10:57 AM, Daniel Lezcano wrote:
>>> On 07/23/2013 11:01 AM, Deepthi Dharwar wrote:
>>>> This patch implements a back-end cpuidle driver for
>>>> powernv calling power7_nap and snooze idle states.
>>>> This can be extended by adding more idle states
>>>> in the future to the existing framework.
>>>>
>>>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> 
> [ ... ]
> 
>>>> +static int snooze_loop(struct cpuidle_device *dev,
>>>> +			struct cpuidle_driver *drv,
>>>> +			int index)
>>>> +{
>>>> +	int cpu = dev->cpu;
>>>> +
>>>> +	local_irq_enable();
>>>> +	set_thread_flag(TIF_POLLING_NRFLAG);
>>>> +
>>>> +	while ((!need_resched()) && cpu_online(cpu)) {
>>>> +		ppc64_runlatch_off();
>>>> +		HMT_very_low();
>>>> +	}
>>>
>>> Why are you using the cpu_online test here ?
>>
>> Snooze state is an idle state where cpu executes an infinite loop by
>> reducing the priority of the thread and the idle cpu can come out of it
>> only if need_resched is set or in case the cpu is offlined. In order to
>> continue executing this loop to remain in this idle state, we need the
>> check just to be safe.
> 
> Yes, but if the cpu is offline you are no longer executing this code, no ?
> 

Yes, not needed.

Thanks !
Deepthi

