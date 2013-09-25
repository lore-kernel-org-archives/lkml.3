Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3IYPGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:06:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44599 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab3IYPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:06:53 -0400
Message-ID: <5242FC09.2050604@linaro.org>
Date: Wed, 25 Sep 2013 17:06:49 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v6 RESEND 0/5] ARM/ARM64 architected timer updates
References: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 01:05 PM, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Hi Olof/Kevin,

Added Olof and Kevin in Cc.

> I am reposting this series as suggested by Olof[1]. This is reviewed and
> acked by Will and Catalin. Daniel needs Ack from arm-soc maintainers
> to take these through his tree. Can you review this ?
> 
> Regards,
> Sudeep
> [1] http://www.spinics.net/lists/arm-kernel/msg270926.html
> -----------
> 
> This patch series adds support to configure the rate and enable the
> event stream for architected timer. The event streams can be used to
> impose a timeout on a wfe, to safeguard against any programming error
> in case an expected event is not generated or even to implement
> wfe-based timeouts for userspace locking implementations. This feature
> can be disabled(enabled by default).
> 
> Since the timer control register is reset to zero on warm boot, CPU
> PM notifier is added to save and restore the value.
> 
> Changes v5->v6:
> 1. Disabling event stream by default on boot and enable it
>    only if CONFIG_ARM_ARCH_TIMER_EVTSTREAM=y
>    This removes runtime configuration of timer event stream.
> 2. Moved COMPAT_ELF_HWCAP_DEFAULT to arch/arm64/kernel/setup.c
> 
> Changes v4->v5:
> 1. Removed compat_dyn_elf_hwcap and used just compat_elf_hwcap as per
>    Catalin's suggestion
> 2. Instead of resetting event stream in CPU PM callbacks, saving and
>    restoring counter control register now.
> 
> Changes v3->v4:
> 1. Added a config option to en/disable the timer event stream feature.
>    Due to this the ordering of the patches as well as some cosmetic
>    code changes are done.( So dropped previous reviewed-by tags)
> 2. Removed exporting compat_dyn_elf_hwcap as there are no modules
>    requiring it for now.
> 
> Changes v2->v3:
> 1. Moved ARM and ARM64 changes into separate patches
> 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
>    definitions(ARM64) to the users for the event stream feature. 
> 
> Changes v1->v2:
> 1. Saved event stream divider value on cold reset path and re-used it
>    in CPU PM notifier instead of calculating every time.
> 2. Rebased on v3.11-rc2(to avoid conflicts with __cpuinit* deletion)
> 3. Dropped "ARM/ARM64: arch_timer: remove __cpuinit attribute for
>    arch_counter_set_user_access"(already done as part of __cpuinit*
>    deletion)
> 
> Sudeep KarkadaNagesha (4):
>   ARM/ARM64: arch_timer: add macros for bits in control register
>   ARM: arch_timer: add support to configure and enable event stream
>   ARM64: arch_timer: add support to configure and enable event stream
>   drivers: clocksource: add CPU PM notifier for ARM architected timer
> 
> Will Deacon (1):
>   drivers: clocksource: add support for ARM architected timer event
>     stream
> 
>  arch/arm/include/asm/arch_timer.h    | 36 ++++++++++++++++++++++----
>  arch/arm/include/uapi/asm/hwcap.h    |  1 +
>  arch/arm/kernel/setup.c              |  1 +
>  arch/arm64/include/asm/arch_timer.h  | 42 ++++++++++++++++++++++++++-----
>  arch/arm64/include/asm/hwcap.h       | 11 ++++----
>  arch/arm64/include/uapi/asm/hwcap.h  |  1 +
>  arch/arm64/kernel/setup.c            | 11 ++++++++
>  drivers/clocksource/Kconfig          | 15 +++++++++++
>  drivers/clocksource/arm_arch_timer.c | 49 ++++++++++++++++++++++++++++++++++++
>  include/clocksource/arm_arch_timer.h | 10 ++++++++
>  10 files changed, 161 insertions(+), 16 deletions(-)
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

