Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab3HNJIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:08:32 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47021 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455Ab3HNJI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:08:28 -0400
Message-ID: <520B490A.4090109@linaro.org>
Date: Wed, 14 Aug 2013 11:08:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This patch series adds support to configure the rate and enable the
> event stream for architected timer. The event streams can be used to
> impose a timeout on a WFE, to safeguard against any programming error
> in case an expected event is not generated or even to implement
> wfe-based timeouts for userspace locking implementations.
> 
> Since the timer control register is reset to zero on warm boot, CPU
> PM notifier is added to re-initialize it.

It does not apply to my tree.

Against which tree is this patchset ? Who is supposed to take it ?

> Changes v2->v3:
> 1. Moved ARM and ARM64 changes into separate patches
> 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
>    definitions(ARM64) to the users for the event stream feature. 

Ok, we have the choice:
 1. split the patchset into arch/arm changes and drivers/clocksource
 2. I ack the patchset and Olof/Kevin take it
 3. Olof/Kevin ack the patchset and I take it in my tree.

This is really becoming fuzzy.

If you want a maintainer to take a patchset you have to send an email
--to him and --cc mailing list and others concerned by the patchset.


> Changes v1->v2:
> 1. Saved event stream divider value on cold reset path and re-used it
>    in CPU PM notifier instead of calculating every time.
> 2. Rebased on v3.11-rc2(to avoid conflicts with __cpuinit* deletion)
> 3. Dropped "ARM/ARM64: arch_timer: remove __cpuinit attribute for
>    arch_counter_set_user_access"(already done as part of __cpuinit*
>    deletion)
> 
> Regards,
> Sudeep
> 
> 
> Sudeep KarkadaNagesha (5):
>   ARM/ARM64: arch_timer: add macros for bits in control register
>   ARM: arch_timer: configure and enable event stream
>   ARM64: arch_timer: configure and enable event stream
>   drivers: clocksource: enable hwcaps for event stream on ARM arch timer
>   drivers: clocksource: add CPU PM notifier for ARM architected timer
> 
> Will Deacon (1):
>   drivers: clocksource: configure event stream for ARM arch timer
> 
>  arch/arm/include/asm/arch_timer.h    | 18 +++++++++++---
>  arch/arm/include/uapi/asm/hwcap.h    |  1 +
>  arch/arm/kernel/setup.c              |  1 +
>  arch/arm64/include/asm/arch_timer.h  | 22 +++++++++++++----
>  arch/arm64/include/asm/hwcap.h       |  4 ++-
>  arch/arm64/include/uapi/asm/hwcap.h  |  1 +
>  arch/arm64/kernel/setup.c            |  1 +
>  drivers/clocksource/arm_arch_timer.c | 48 +++++++++++++++++++++++++++++++++++-
>  include/clocksource/arm_arch_timer.h | 10 ++++++++
>  9 files changed, 96 insertions(+), 10 deletions(-)
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

