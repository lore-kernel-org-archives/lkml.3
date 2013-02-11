Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab3BKWun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:50:43 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40182 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab3BKWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:50:42 -0500
Message-ID: <511975BD.60103@kernel.org>
Date: Mon, 11 Feb 2013 17:50:37 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 01/16] APM idle: register apm_cpu_idle via cpuidle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com> <5118B776.6090604@linaro.org>
In-Reply-To: <5118B776.6090604@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 04:18 AM, Daniel Lezcano wrote:
> On 02/10/2013 06:58 AM, Len Brown wrote:
>> From: Len Brown <len.brown@intel.com>
>>
>> Update APM to register its local idle routine with cpuidle.
>>
>> This allows us to stop exporting pm_idle to modules on x86.
>>
>> The Kconfig sub-option, APM_CPU_IDLE, now depends on on CPU_IDLE.
>>
>> Compile-tested only.
>>
>> Signed-off-by: Len Brown <len.brown@intel.com>
>> Cc: Jiri Kosina <jkosina@suse.cz>
>> ---
> 

>> +static struct cpuidle_device apm_cpuidle_device = {
>> +	.state_count = 2,
>> +};
> 
> This will make the cpuidle_register_driver to fail because the
> state_count field of the cpuidle_driver is zero, no ?
> 
> static struct cpuidle_driver apm_idle_driver = {
> 	.name = "apm_idle",
> 	...
> 	.states = {
> 	...
> 	},
> 	.state_count = 2,
> }

yup, good catch.

>> -static void apm_cpu_idle(void)
>> +static int apm_cpu_idle(struct cpuidle_device *dev,
>> +	struct cpuidle_driver *drv, int index)
>>  {
>>  	static int use_apm_idle; /* = 0 */
>>  	static unsigned int last_jiffies; /* = 0 */
...
>> @@ -964,6 +983,7 @@ recalc:
>>  		apm_do_busy();
>>  
>>  	local_irq_enable();
> 
>            ^^^^^^^^
> 
> As the 'en_core_tk_irqen' flag has been enabled in the driver, the
> caller of this function will call 'local_irq_enable'. We can remove the
> this line no ?

yup, this line is no longer necessary.

v2 on the way -- hoping somebody with an APM box can test it.

thanks,
-Len Brown, Intel Open Source Technology Center

