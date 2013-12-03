Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3LCRMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:12:20 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44217 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3LCRMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:12:15 -0500
MIME-Version: 1.0
In-Reply-To: <1386088611-2801-5-git-send-email-hanjun.guo@linaro.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
	<1386088611-2801-5-git-send-email-hanjun.guo@linaro.org>
Date: Tue, 3 Dec 2013 11:12:14 -0600
Message-ID: <CAL_JsqKmKsZtYgFrLBU+vOnHkC6x5nB9WfhM7hC=DipzEj8qhg@mail.gmail.com>
Subject: Re: [RFC part1 PATCH 4/7] ARM64 / ACPI: Introduce the skeleton of
 _PDC related for ARM64
From: Rob Herring <robherring2@gmail.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>, Linaro Patches <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:36 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> The _PDC (Processor Driver Capabilities) object provides OSPM a
> mechanism to convey to the platform the capabilities supported
> by OSPM for processor power management.
>
> OSPM evaluates _PDC prior to evaluating any other processor
> power management objects returning configuration information.
>
> This patch introduces the skeleton of _PDC related file to make
> ACPI core can be compiled on ARM64.
>
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h      |   32 ++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/processor.h |   11 +++++++++++
>  arch/arm64/kernel/process.c        |    5 +++++
>  3 files changed, 48 insertions(+)
>  create mode 100644 arch/arm64/include/asm/acpi.h
>
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> new file mode 100644
> index 0000000..c186f5b
> --- /dev/null
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -0,0 +1,32 @@
> +/*
> + *  Copyright (C) 2013, Al Stone <al.stone@linaro.org>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#ifndef _ASM_ARM_ACPI_H
> +#define _ASM_ARM_ACPI_H
> +
> +static inline bool arch_has_acpi_pdc(void)
> +{
> +       return false;   /* always false for now */
> +}
> +
> +static inline void arch_acpi_set_pdc_bits(u32 *buf)
> +{
> +       return;
> +}
> +
> +#endif /*_ASM_ARM_ACPI_H*/
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 45b20cd..73b1d3a 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -162,6 +162,17 @@ static inline void spin_lock_prefetch(const void *x)
>
>  #define HAVE_ARCH_PICK_MMAP_LAYOUT
>
> +#ifdef CONFIG_ACPI

The ifdef is not necessary.

> +/*
> + * FIXME: there is no MWAIT on ARM, should be WFI or something else,
> + * and modify drivers/acpi/processor_core.c too.
> + */
> +enum idle_boot_override { IDLE_NO_OVERRIDE = 0, IDLE_HALT, IDLE_NOMWAIT,
> +                       IDLE_POLL, IDLE_FORCE_MWAIT };
> +
> +extern unsigned long    boot_option_idle_override;
> +#endif
