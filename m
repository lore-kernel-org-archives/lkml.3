Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaAaULn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:11:43 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:53047 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaAaULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:11:41 -0500
MIME-Version: 1.0
In-Reply-To: <1391107002-21470-3-git-send-email-galak@codeaurora.org>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
	<1391107002-21470-3-git-send-email-galak@codeaurora.org>
Date: Fri, 31 Jan 2014 14:11:40 -0600
Message-ID: <CAL_JsqKWa91vDu2oFdOb7Y8XSB-UecYDOK6CmyjXr1ZW81Snqg@mail.gmail.com>
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
From: Rob Herring <robherring2@gmail.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 12:36 PM, Kumar Gala <galak@codeaurora.org> wrote:
> Introduce a new mach-qcom that will support SoCs that intend to be
> multiplatform compatiable while keeping mach-msm to legacy SoC/board
> support that will not transition over to multiplatform.
>
> As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
> to mach-qcom.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---

[snip]

> diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
> new file mode 100644
> index 0000000..8830431
> --- /dev/null
> +++ b/arch/arm/mach-qcom/Kconfig
> @@ -0,0 +1,34 @@
> +config ARCH_QCOM
> +       bool "Qualcomm Support" if ARCH_MULTI_V7
> +       select ARCH_REQUIRE_GPIOLIB
> +       select CLKSRC_OF
> +       select GENERIC_CLOCKEVENTS
> +       select ARM_GIC
> +       select CPU_V7

CPU_V7 is already selected by MULTI_V7.


[snip]

> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-qcom/smp.c
> similarity index 97%
> rename from arch/arm/mach-msm/platsmp.c
> rename to arch/arm/mach-qcom/smp.c
> index 42eb6b7..28364cb 100644
> --- a/arch/arm/mach-msm/platsmp.c
> +++ b/arch/arm/mach-qcom/smp.c
> @@ -2,6 +2,7 @@
>   *  Copyright (C) 2002 ARM Ltd.
>   *  All Rights Reserved
>   *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *  Copyright (c) 2014 The Linux Foundation. All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -20,7 +21,6 @@
>  #include <asm/smp_plat.h>
>
>  #include "scm-boot.h"
> -#include "common.h"
>
>  #define VDD_SC1_ARRAY_CLAMP_GFS_CTL    0x35a0
>  #define SCSS_CPU1CORE_RESET            0x2d80
> @@ -48,6 +48,15 @@ extern void secondary_startup(void);
>
>  static DEFINE_SPINLOCK(boot_lock);
>
> +static void __ref msm_cpu_die(unsigned int cpu)
> +{
> +
> +       asm("wfi"
> +           :
> +           :
> +           : "memory", "cc");
> +}

I realize this is just a move, but there is a wfi() macro that can be
used here instead.

Rob
