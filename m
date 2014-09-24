Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaIXIXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:23:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9676 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaIXIX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:23:28 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-30-54227f7d1d7a
Message-id: <54227F7B.80702@samsung.com>
Date: Wed, 24 Sep 2014 10:23:23 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, swarren@nvidia.com,
        acourbot@nvidia.com, "'Olof Johansson'" <olof@lixom.net>,
        drake@endlessm.com, tomeu@tomeuvizoso.net
Subject: Re: [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
 <5415D4A8.4010304@gmail.com> <0d2401cfd07b$0e21e190$2a65a4b0$@kernel.org>
 <54227893.7020808@samsung.com>
In-reply-to: <54227893.7020808@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xy7q19UohBo3neC2+PzzFavF30jF2
	i0fzHzNb9C64ymbR//g1s8Wmx9dYLS7vmsNmMeP8PiaL25d5LU5d/8xmcWN6C6vFql1/GC0u
	N5o58Hq0NPewefz+NYnRY9H3LI+ds+6ye2xa1cnmsXlJvceVE02sHr3N79g8+rasYvQ4+pfN
	4/MmuQDuKC6blNSczLLUIn27BK6M2fe9CpaoVHSs/c/cwHhCpouRk0NCwERixdGHzBC2mMSF
	e+vZuhi5OIQEljJKHHr0khXC+cQo8fDEC6YuRg4OXgENiY3XFEAaWARUJaYv+MoOYrMJGEp0
	ve1iA7FFBWIkln7cwwJi8woISvyYfA/MFhFwlZhzZRIjyExmgadMEp0vdzGCJIQFvCVe9f+E
	WraeUWLGpt1gHZwC2hLrdr9gBbGZBcwkvrw8DGXLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG
	0dTS5ILipPRcI73ixNzi0rx0veT83E2MkKj6uoNx6TGrQ4wCHIxKPLwTxZVChFgTy4orcw8x
	SnAwK4nwnigFCvGmJFZWpRblxxeV5qQWH2Jk4uCUamAstW6/WLVFyF96b5jdcz2L9Z766r+T
	v+8Wurteke9Uw3Vd3sMbJh2oyey9smHvzqnf4q780HsjPbHhVLfPrb8LD9VrqWi7Kgbee+Xr
	t2eR+X1et7J7Is1rnx9Xk+ssFLM9Z7F0v0vR33kLrptE/tgww/qkz93npkdFnmw7LPY9NaBR
	JNf3u81TJZbijERDLeai4kQARXMrr4gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 2014-09-24 09:53, Kukjin Kim wrote:
>
> On 09/15/14 09:21, Kukjin Kim wrote:
>>
>>> On 26.08.2014 16:10, Tomasz Figa wrote:
>>>> On Exynos-based boards running secure firmware the sequence of low 
>>>> level
>>>> operations to enter and leave system-wide sleep mode is different than
>>>> on those without the firmware. Namely:
>>>>   - CP15 power control and diagnostic registers cannot be written 
>>>> directly,
>>>>   - the way of setting boot address and boot flag is different,
>>>>   - different resume handler needs to be used,
>>>>   - dedicated SMC call needs to be performed instead of letting the 
>>>> CPU enter
>>>>     WFI.
>>>>
>>>> This series introduces .suspend() and .resume() firmware operations to
>>>> perform low level firmware-specific suspend and resume and then 
>>>> leverages
>>>> them to provide suspend-resume path meeting the above requirements. 
>>>> Three
>>>> additional patches extend device tree sources of Trats2 board with 
>>>> necessary
>>>> setup to enable suspend/resume support.
>>>>
>>>> This series has been tested on Exynos4412-based Trats2 board, 
>>>> without any
>>>> additional patches. Unfortunately v3.17-rc1 regressed ODROID 
>>>> support and
>>>> suspend stopped working on those boards, due to unknown reasons 
>>>> still being
>>>> investigated. It does not seem to be related to anything in this 
>>>> series,
>>>> though, so I would not consider this as a stopper.
>>>>
>>>> Changes since v2:
>>>> (https://lkml.org/lkml/2014/7/17/431)
>>>>   - added board-specific fixes for device tree sources of Trats2 
>>>> board,
>>>>   - rebased on next-20140826 of linux-next tree.
>>>>
>>>> Changes since v1:
>>>>   - dropped outer_resume() - will be handled in assembly in further 
>>>> patches,
>>>>     as support for L2C in non-secure mode gets added,
>>>>   - moved CP15 resume to assembly as it needs to be done before MMU 
>>>> is enabled,
>>>>   - surrounded CP15 save with a check for cpuid part, because it is 
>>>> valid only
>>>>     on Cortex A9,
>>>>   - rebased on next-20140717 tag of linux-next tree.
>>>>
>>>> Tomasz Figa (5):
>>>>    ARM: firmware: Introduce suspend and resume operations
>>>>    ARM: EXYNOS: Add support for firmware-assisted suspend/resume
>>>>    ARM: dts: exynos4412-trats2: Keep eMMC regulators soft-disabled
>>>>    ARM: dts: exynos4x12: Add utility macro to define pin sleep states
>>>>    ARM: dts: exynos4412-trats2: Add sleep mode pin configuration
>>>>
>>>>   Documentation/arm/firmware.txt            |  28 +--
>>>>   arch/arm/boot/dts/exynos4412-trats2.dts   | 320 
>>>> +++++++++++++++++++++++++++++-
>>>>   arch/arm/boot/dts/exynos4x12-pinctrl.dtsi |  16 ++
>>>>   arch/arm/include/asm/firmware.h           |   8 +
>>>>   arch/arm/mach-exynos/Makefile             |   1 +
>>>>   arch/arm/mach-exynos/common.h             |   4 +
>>>>   arch/arm/mach-exynos/firmware.c           |  45 +++++
>>>>   arch/arm/mach-exynos/pm.c                 |  16 +-
>>>>   arch/arm/mach-exynos/sleep.S              |  28 +++
>>>>   arch/arm/mach-exynos/smc.h                |   4 +
>>>>   10 files changed, 438 insertions(+), 32 deletions(-)
>>>>
>>>
>>> Would you consider applying this series? It has been waiting on the ML
>>> long enough (note no changes in core patches since last revision, just
>>> few more board specific patches). Thanks in advance.
>>>
>> Sure, I will. Thanks for your gentle reminder.
>>
> I've reverted this series because of following.
>
> In file included from arch/arm/mach-tegra/cpuidle-tegra114.c:17:0:
> arch/arm/mach-tegra/cpuidle-tegra114.c: In function 
> 'tegra114_idle_power_down':
> arch/arm/include/asm/firmware.h:64:24: error: too few arguments to 
> function 'firmware_ops->do_idle'
>   ((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
>                         ^
> arch/arm/mach-tegra/cpuidle-tegra114.c:52:6: note: in expansion of 
> macro 'call_firmware_op'
>   if (call_firmware_op(do_idle) == -ENOSYS)
>       ^
>
> Caused by commit f5217f3b9332 ("ARM: EXYNOS: add AFTR mode support to
> firmware do_idle method").
>
> Need to fix...

I don't get why you have reverted the main feature of "Firmware-assisted 
suspend/resume
of Exynos SoCs" because of an issue on the completely independent 
patchset which adds
AFTR idle mode support. Could you please keep the "ARM: firmware: 
Introduce suspend
and resume operations" and "ARM: EXYNOS: Add support for firmware-assisted
suspend/resume" patches?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

