Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3HNLD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:03:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48816 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675Ab3HNLD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:03:28 -0400
Message-ID: <520B63FF.3090805@arm.com>
Date: Wed, 14 Aug 2013 12:03:27 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <520B490A.4090109@linaro.org> <520B4B2E.1040700@arm.com> <520B611D.8060500@linaro.org>
In-Reply-To: <520B611D.8060500@linaro.org>
X-OriginalArrivalTime: 14 Aug 2013 11:03:24.0957 (UTC) FILETIME=[E5B82CD0:01CE98DD]
X-MC-Unique: 113081412032603001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/13 11:51, Daniel Lezcano wrote:
> On 08/14/2013 11:17 AM, Sudeep KarkadaNagesha wrote:
>> On 14/08/13 10:08, Daniel Lezcano wrote:
>>> On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>
>>>> This patch series adds support to configure the rate and enable the
>>>> event stream for architected timer. The event streams can be used to
>>>> impose a timeout on a WFE, to safeguard against any programming error
>>>> in case an expected event is not generated or even to implement
>>>> wfe-based timeouts for userspace locking implementations.
>>>>
>>>> Since the timer control register is reset to zero on warm boot, CPU
>>>> PM notifier is added to re-initialize it.
>>>
>>> It does not apply to my tree.
>>>
>>> Against which tree is this patchset ? Who is supposed to take it ?
>>>
>> As I had mentioned in previous version, because of the conflict, I had
>> to rebase it on 3.11-rc4
> 
> 
> dlezcano@mai:~/Work/src/clockevents$ git show
> commit c095ba7224d8edc71dcef0d655911399a8bd4a3f
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Aug 4 13:46:46 2013 -0700
> 
>     Linux 3.11-rc4
> 
> diff --git a/Makefile b/Makefile
> index 95a8e55..f93d4f7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 3
>  PATCHLEVEL = 11
>  SUBLEVEL = 0
> -EXTRAVERSION = -rc3
> +EXTRAVERSION = -rc4
>  NAME = Linux for Workgroups
> 
>  # *DOCUMENTATION*
> 
> 
> dlezcano@mai:~/Work/src/clockevents$ git am -s arch_timer
> 
> Applying: ARM/ARM64: arch_timer: add macros for bits in control register
> Applying: drivers: clocksource: configure event stream for ARM arch timer
> Applying: ARM: arch_timer: configure and enable event stream
> Applying: ARM64: arch_timer: configure and enable event stream
Looks like you are missing a patch here:
[PATCH v3 5/6] drivers: clocksource: enable hwcaps for event stream on
ARM arch timer

> Applying: drivers: clocksource: add CPU PM notifier for ARM architected
> timer

Regards,
Sudeep


