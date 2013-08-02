Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3HBJst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:48:49 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51809 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab3HBJsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:48:47 -0400
Message-ID: <51FB8081.6040501@linaro.org>
Date: Fri, 02 Aug 2013 11:48:49 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 0/3] ARM/ARM64 architected timer updates
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51FB7CB8.6080103@arm.com>
In-Reply-To: <51FB7CB8.6080103@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 11:32 AM, Sudeep KarkadaNagesha wrote:
> Hi Daniel,
> 
> On 22/07/13 12:21, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> This patch series adds support to configure the rate and enable the event
>> stream for architected timer. Since the timer control register is reset to
>> zero on warm boot, CPU PM notifier is added to re-initialse it.
>>
> This series is required to support TC2 cpuidle.
> It will be good if you can review and get this in for v3.12

So do you want me to take the series through my tree ?

> Regards,
> Sudeep
> 
>> Changes v1->v2:
>> 1. Saved event stream divider value on cold reset path and re-used it
>>    in CPU PM notifier instead of calculating every time.
>> 2. Rebased on v3.11-rc2(to avoid conflicts with __cpuinit* deletion)
>> 3. Dropped "ARM/ARM64: arch_timer: remove __cpuinit attribute for
>>    arch_counter_set_user_access"(already done as part of __cpuinit*
>>    deletion)
>>
>> Regards,
>> Sudeep
>>
>>
>> Sudeep KarkadaNagesha (2):
>>   ARM: arch_timer: add macros for bits in control register
>>   drivers: clocksource: add CPU PM notifier for ARM architected timer
>>
>> Will Deacon (1):
>>   drivers: clocksource: configure event stream for ARM arch timer
>>
>>  arch/arm/include/asm/arch_timer.h    | 10 ++++++--
>>  arch/arm64/include/asm/arch_timer.h  | 12 +++++++---
>>  drivers/clocksource/arm_arch_timer.c | 45 +++++++++++++++++++++++++++++++++++-
>>  include/clocksource/arm_arch_timer.h | 10 ++++++++
>>  4 files changed, 71 insertions(+), 6 deletions(-)
>>
> 
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

