Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaAaOKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:10:36 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37418 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaAaOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:10:35 -0500
Message-ID: <52EBAED8.8080807@linaro.org>
Date: Fri, 31 Jan 2014 15:10:32 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 1/3] cpuidle: split cpuidle_idle_call main function
 into functions
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-2-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1401301433320.1652@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1401301433320.1652@knanqh.ubzr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 08:39 PM, Nicolas Pitre wrote:
> On Thu, 30 Jan 2014, Daniel Lezcano wrote:
>
>>   /**
>> + * cpuidle_select - ask the cpuidle framework to choose an idle state
>> + *
>> + * @drv: the cpuidle driver
>> + * @dev: the cpuidle device
>> + *
>> + * Returns the index of the idle state. On error it returns:
>> + * -NODEV : the cpuidle framework is available
>
> s/available/not available/
>
>> + * -EBUSY : the cpuidle framework is not initialized
>> + */
>> +int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>> +{
>> +	if (off || !initialized)
>> +		return -ENODEV;
>> +
>> +	if (!drv || !dev || !dev->enabled)
>> +		return -EBUSY;
>> +
>> +	return cpuidle_curr_governor->select(drv, dev);
>> +}
>> +EXPORT_SYMBOL(cpuidle_select);
>
> Peterz comment notwithstanding, is there actually a need to export those
> symbols? No modules should ever need to use this given this is going to
> be called by the scheduler code.

Yes, you are right. I will remove them.

Thanks !

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

