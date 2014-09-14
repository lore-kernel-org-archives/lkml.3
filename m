Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaINRr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:47:26 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57139 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaINRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:47:24 -0400
Message-ID: <5415D4A8.4010304@gmail.com>
Date: Sun, 14 Sep 2014 19:47:20 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Olof Johansson <olof@lixom.net>, drake@endlessm.com,
        tomeu@tomeuvizoso.net
Subject: Re: [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 26.08.2014 16:10, Tomasz Figa wrote:
> On Exynos-based boards running secure firmware the sequence of low level
> operations to enter and leave system-wide sleep mode is different than
> on those without the firmware. Namely:
>  - CP15 power control and diagnostic registers cannot be written directly,
>  - the way of setting boot address and boot flag is different,
>  - different resume handler needs to be used,
>  - dedicated SMC call needs to be performed instead of letting the CPU enter
>    WFI.
> 
> This series introduces .suspend() and .resume() firmware operations to
> perform low level firmware-specific suspend and resume and then leverages
> them to provide suspend-resume path meeting the above requirements. Three
> additional patches extend device tree sources of Trats2 board with necessary
> setup to enable suspend/resume support.
> 
> This series has been tested on Exynos4412-based Trats2 board, without any
> additional patches. Unfortunately v3.17-rc1 regressed ODROID support and
> suspend stopped working on those boards, due to unknown reasons still being
> investigated. It does not seem to be related to anything in this series,
> though, so I would not consider this as a stopper.
> 
> Changes since v2:
> (https://lkml.org/lkml/2014/7/17/431)
>  - added board-specific fixes for device tree sources of Trats2 board,
>  - rebased on next-20140826 of linux-next tree.
> 
> Changes since v1:
>  - dropped outer_resume() - will be handled in assembly in further patches,
>    as support for L2C in non-secure mode gets added,
>  - moved CP15 resume to assembly as it needs to be done before MMU is enabled,
>  - surrounded CP15 save with a check for cpuid part, because it is valid only
>    on Cortex A9,
>  - rebased on next-20140717 tag of linux-next tree.
> 
> Tomasz Figa (5):
>   ARM: firmware: Introduce suspend and resume operations
>   ARM: EXYNOS: Add support for firmware-assisted suspend/resume
>   ARM: dts: exynos4412-trats2: Keep eMMC regulators soft-disabled
>   ARM: dts: exynos4x12: Add utility macro to define pin sleep states
>   ARM: dts: exynos4412-trats2: Add sleep mode pin configuration
> 
>  Documentation/arm/firmware.txt            |  28 +--
>  arch/arm/boot/dts/exynos4412-trats2.dts   | 320 +++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/exynos4x12-pinctrl.dtsi |  16 ++
>  arch/arm/include/asm/firmware.h           |   8 +
>  arch/arm/mach-exynos/Makefile             |   1 +
>  arch/arm/mach-exynos/common.h             |   4 +
>  arch/arm/mach-exynos/firmware.c           |  45 +++++
>  arch/arm/mach-exynos/pm.c                 |  16 +-
>  arch/arm/mach-exynos/sleep.S              |  28 +++
>  arch/arm/mach-exynos/smc.h                |   4 +
>  10 files changed, 438 insertions(+), 32 deletions(-)
> 

Would you consider applying this series? It has been waiting on the ML
long enough (note no changes in core patches since last revision, just
few more board specific patches). Thanks in advance.

Best regards,
Tomasz
