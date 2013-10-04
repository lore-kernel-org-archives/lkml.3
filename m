Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3JDKzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:55:49 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58793 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JDKzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:55:47 -0400
Message-ID: <524E9E6F.80606@gmail.com>
Date: Fri, 04 Oct 2013 18:54:39 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Chen Gang <gang.chen@asianux.com>, Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] about calling debug_hotplug_cpu() which enabled
 by 'allmodconfig' for a x86_64 dual core laptop.
References: <524B8E97.1030707@asianux.com>  <1380727725.5429.13.camel@misato.fc.hp.com> <524C4CC9.3080402@gmail.com>  <1380742391.5429.37.camel@misato.fc.hp.com> <524CBF19.2030708@asianux.com> <1380811892.5429.40.camel@misato.fc.hp.com>
In-Reply-To: <1380811892.5429.40.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 10:51 PM, Toshi Kani wrote:
> On Thu, 2013-10-03 at 00:49 +0000, Chen Gang wrote:
>> On 10/03/2013 03:33 AM, Toshi Kani wrote:
>>> On Thu, 2013-10-03 at 00:41 +0800, Chen Gang F T wrote:
>>>> On 10/02/2013 11:28 PM, Toshi Kani wrote:
>>>>> On Wed, 2013-10-02 at 03:10 +0000, Chen Gang wrote:
>>>>>> Hello Maintainers:
>>>>>>
>>>>>> Under my x86_64 dual core laptop, I build kernel next-20130927 with
>>>>>> 'allmodconfig', and install it, the machine can not start. Related
>>>>>> information is:
>>>>>>
>>>>>>   after call debug_hotplug_cpu(), output "cpu 0 is offline" .... and then "Failed to execute /init".
>>>>>>
>>>>>> After remove "_debug_hotplug_cpu(0, 0);", can pass the issue (but will
>>>>>> fail in another place). I guess, the reason is my laptop cpu is not
>>>>>> 'hotplug', but have to call debug_hotplug_cpu() with allmodconfig.
>>>>>>
>>>>>>
>>>>>> I will continue analyzing, welcome any additional suggestions or
>>>>>> completions.
>>>>>
>>>>> allmodconfig sets CONFIG_DEBUG_HOTPLUG_CPU0 to y (which is defined as
>>>>> "def_bool n"), which puts CPU0 offline during boot for testing.  This
>>>>> debug feature is causing the problem on your laptop.  I am not familiar
>>>>> with allmodconfig, but it seems that it enables all the config options,
>>>>> preferably with 'm'.
>>>>>
>>>>
>>>> Hmm... excuse me, I don't know: for laptop, if cpu0 is offline, whether
>>>> it still can work or not. If any members know about it, please tell me,
>>>> thanks.
>>>
>>> CPU online/offline works on laptops as long as they have more than one
>>> CPU.  You can boot with other kernel and test this feature
>>> with /sys/devices/system/cpu/cpuX/online on your laptop.  cpu0 is a
>>> special case and you may need to specify "cpu0_hotplug" boot option.
>>>
>>
>> Thank you for your confirmation, "for dual core (although laptop), after
>> system boot up, can let cpu0 offline". :-)
> 
> Good. :)
> 
>>>> In my opinion, if enable DEBUG_HOTPLUG_CPU0, but "should not let cpu0
>>>> offline for laptop", we need let 'offline' operation fail.
>>>
>>> Whether it is a laptop or not should not be a matter here.  But I agree
>>> with you that enabling CONFIG_DEBUG_HOTPLUG_CPU0 is not useful (and can
>>> be harmful) unless a user really intends to test this feature.
>>>
>>
>> Hmm... I will continue analyzing. After finish analyzing (let kernel
>> boot up OK), I should give a confirmation: "during boot up, can we still
>> let cpu0 offline for dual core?".
>>
>> In fact, 'allmodconfig' is just a mad user which often does useless
>> things to intend to find issues.
> 
> I see.  If this option is used for testing, enabling DEBUG_HOTPLUG_CPU0
> does make sense.
> 

Thank you for your encouragement.

My current idea about testing/analyzing/fixing is:

  can boot up in allmodconfig for x86, smp version on dual/one core cpu.
  can boot up under other architectures in allmodconfig in kvm machine.
  can boot up with defconfig on x86 and various virtual machines.

My original idea is to use outside testing tools (e.g. LTP) for kernel,
hope I won't delay again (I have delayed several times), before outside
testing, we need pass internal test firstly (at least, can boot up).


Thanks.

> Thanks,
> -Toshi
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Chen Gang
