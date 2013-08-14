Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3HNPAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:00:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59990 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3HNPAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:00:22 -0400
Message-ID: <520B9B84.3010409@linaro.org>
Date: Wed, 14 Aug 2013 17:00:20 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <520B490A.4090109@linaro.org> <520B4B2E.1040700@arm.com> <520B611D.8060500@linaro.org> <520B63FF.3090805@arm.com>
In-Reply-To: <520B63FF.3090805@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 01:03 PM, Sudeep KarkadaNagesha wrote:
> On 14/08/13 11:51, Daniel Lezcano wrote:
>> On 08/14/2013 11:17 AM, Sudeep KarkadaNagesha wrote:
>>> On 14/08/13 10:08, Daniel Lezcano wrote:
>>>> On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
>>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>>
>>>>> This patch series adds support to configure the rate and enable the
>>>>> event stream for architected timer. The event streams can be used to
>>>>> impose a timeout on a WFE, to safeguard against any programming error
>>>>> in case an expected event is not generated or even to implement
>>>>> wfe-based timeouts for userspace locking implementations.
>>>>>
>>>>> Since the timer control register is reset to zero on warm boot, CPU
>>>>> PM notifier is added to re-initialize it.
>>>>
>>>> It does not apply to my tree.
>>>>
>>>> Against which tree is this patchset ? Who is supposed to take it ?
>>>>
>>> As I had mentioned in previous version, because of the conflict, I had
>>> to rebase it on 3.11-rc4
>>
>>
>> dlezcano@mai:~/Work/src/clockevents$ git show
>> commit c095ba7224d8edc71dcef0d655911399a8bd4a3f
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sun Aug 4 13:46:46 2013 -0700
>>
>>     Linux 3.11-rc4
>>
>> diff --git a/Makefile b/Makefile
>> index 95a8e55..f93d4f7 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,7 +1,7 @@
>>  VERSION = 3
>>  PATCHLEVEL = 11
>>  SUBLEVEL = 0
>> -EXTRAVERSION = -rc3
>> +EXTRAVERSION = -rc4
>>  NAME = Linux for Workgroups
>>
>>  # *DOCUMENTATION*
>>
>>
>> dlezcano@mai:~/Work/src/clockevents$ git am -s arch_timer
>>
>> Applying: ARM/ARM64: arch_timer: add macros for bits in control register
>> Applying: drivers: clocksource: configure event stream for ARM arch timer
>> Applying: ARM: arch_timer: configure and enable event stream
>> Applying: ARM64: arch_timer: configure and enable event stream
> Looks like you are missing a patch here:
> [PATCH v3 5/6] drivers: clocksource: enable hwcaps for event stream on
> ARM arch timer

ah, right. Fair enough.

>> Applying: drivers: clocksource: add CPU PM notifier for ARM architected
>> timer


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

