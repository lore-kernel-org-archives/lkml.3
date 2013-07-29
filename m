Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3G2Oxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:53:30 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57250 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3G2Ox2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:53:28 -0400
Message-ID: <51F681E7.1060609@linaro.org>
Date: Mon, 29 Jul 2013 16:53:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/3] cpuidle/powernv: cpuidle backend driver
 for powernv
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090137.7291.36657.stgit@deepthi.in.ibm.com> <51F35A2A.1080408@linaro.org> <51F67E96.6040008@linux.vnet.ibm.com>
In-Reply-To: <51F67E96.6040008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 04:39 PM, Deepthi Dharwar wrote:
> Hi Daniel,
> 
> On 07/27/2013 10:57 AM, Daniel Lezcano wrote:
>> On 07/23/2013 11:01 AM, Deepthi Dharwar wrote:
>>> This patch implements a back-end cpuidle driver for
>>> powernv calling power7_nap and snooze idle states.
>>> This can be extended by adding more idle states
>>> in the future to the existing framework.
>>>
>>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

[ ... ]

>>> +static int snooze_loop(struct cpuidle_device *dev,
>>> +			struct cpuidle_driver *drv,
>>> +			int index)
>>> +{
>>> +	int cpu = dev->cpu;
>>> +
>>> +	local_irq_enable();
>>> +	set_thread_flag(TIF_POLLING_NRFLAG);
>>> +
>>> +	while ((!need_resched()) && cpu_online(cpu)) {
>>> +		ppc64_runlatch_off();
>>> +		HMT_very_low();
>>> +	}
>>
>> Why are you using the cpu_online test here ?
> 
> Snooze state is an idle state where cpu executes an infinite loop by
> reducing the priority of the thread and the idle cpu can come out of it
> only if need_resched is set or in case the cpu is offlined. In order to
> continue executing this loop to remain in this idle state, we need the
> check just to be safe.

Yes, but if the cpu is offline you are no longer executing this code, no ?

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

