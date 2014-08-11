Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaHKMHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:07:53 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56573 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaHKMHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:07:51 -0400
MIME-Version: 1.0
In-Reply-To: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
References: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Mon, 11 Aug 2014 14:07:30 +0200
X-Google-Sender-Auth: XwdNuxDo51l9m57Au21wVbKuoNs
Message-ID: <CAAObsKB3vO1KtgSvDY-+1WA4qDFVS_A6cXZM=vr9U1gVM=v=5g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Daniel Drake <drake@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For both patches, on the Odroid U2:

Tested-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Thanks,

Tomeu

On 17 July 2014 17:56, Tomasz Figa <t.figa@samsung.com> wrote:
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
> them to provide suspend-resume path meeting the above requirements.
>
> The series is based on Kgene's for-next branch and tested on:
>  - Exynos4412-based Trats2 board running in non-secure mode (under secure
>    firmware) with few board-specific fixes that will be sent separately soon,
>  - Exynos4210-based Trats board running in secure mode,
>  - Exynos4412-based ODROID-U3 board running in non-secure mode with one minor
>    board-specific fix which will be send shortly.
>
> Depends on:
>  - [PATCH v3] ARM: save/restore Cortex-A9 CP15 registers on suspend/resume
>    (http://www.spinics.net/lists/arm-kernel/msg346212.html)
>  - [PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences
>    (https://lkml.org/lkml/2014/7/15/319)
>  - [PATCH] ARM: make it easier to check the CPU part number correctly
>    (http://thread.gmane.org/gmane.linux.ports.arm.kernel/335126
>     already in linux-next)
>
> Changes since v1:
>  - dropped outer_resume() - will be handled in assembly in further patches,
>    as support for L2C in non-secure mode gets added,
>  - moved CP15 resume to assembly as it needs to be done before MMU is enabled,
>  - surrounded CP15 save with a check for cpuid part, because it is valid only
>    on Cortex A9,
>  - rebased on next-20140717 tag of linux-next tree.
>
> Tomasz Figa (2):
>   ARM: firmware: Introduce suspend and resume operations
>   ARM: EXYNOS: Add support for firmware-assisted suspend/resume
>
>  Documentation/arm/firmware.txt  | 28 +++++--------------------
>  arch/arm/include/asm/firmware.h |  8 ++++++++
>  arch/arm/mach-exynos/Makefile   |  1 +
>  arch/arm/mach-exynos/common.h   |  4 ++++
>  arch/arm/mach-exynos/firmware.c | 45 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/pm.c       | 16 ++++++++++-----
>  arch/arm/mach-exynos/sleep.S    | 28 +++++++++++++++++++++++++
>  arch/arm/mach-exynos/smc.h      |  4 ++++
>  8 files changed, 106 insertions(+), 28 deletions(-)
>
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
