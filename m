Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaAWQPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:15:19 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:19141 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752194AbaAWQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:15:16 -0500
Date: Thu, 23 Jan 2014 16:15:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 02/20] ARM64 : Add dummy asm/cpu.h
Message-ID: <20140123161505.GB23939@localhost>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-3-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389961514-13562-3-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 12:24:56PM +0000, Hanjun Guo wrote:
> ACPI requires a cpu.h, add a dummy one copied from arm. This will need
> updated or replaced as ACPI based cpu hotplug or cpu topology for armv8
> is worked out.
> 
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/cpu.h |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 arch/arm64/include/asm/cpu.h
> 
> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
> new file mode 100644
> index 0000000..8625eb1
> --- /dev/null
> +++ b/arch/arm64/include/asm/cpu.h
> @@ -0,0 +1,25 @@
> +/*
> + *  Copyright (C) 2004-2005 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __ASM_ARM_CPU_H
> +#define __ASM_ARM_CPU_H
> +
> +#include <linux/percpu.h>
> +#include <linux/cpu.h>
> +#include <linux/topology.h>
> +
> +struct cpuinfo_arm {
> +	struct cpu	cpu;
> +	u64		cpuid;
> +#ifdef CONFIG_SMP
> +	unsigned int	loops_per_jiffy;
> +#endif
> +};
> +
> +DECLARE_PER_CPU(struct cpuinfo_arm, cpu_data);
> +
> +#endif

Could you not leave this file empty until you add the code that actually
makes use of cpu_data?

-- 
Catalin
