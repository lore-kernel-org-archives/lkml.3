Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3LCRNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:13:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52971 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab3LCRNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:13:46 -0500
Date: Tue, 3 Dec 2013 17:13:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Jon Masters <jonathan@jonmasters.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [RFC part1 PATCH 2/7] ARM64 : Add dummy asm/cpu.h
Message-ID: <20131203171345.GC16025@e106331-lin.cambridge.arm.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <1386088611-2801-3-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386088611-2801-3-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:36:46PM +0000, Hanjun Guo wrote:
> ACPI requires a cpu.h, add a dummy one copied from arm. This will need
> updated or replaced as ACPI based cpu hotplug for armv8 is worked out.

What exactly requires cpu.h, and why?

Why copy the file verbatim rather than factoring it out?

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
> index 0000000..dbeb98d
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
> +	u32		cpuid;

We use a u64 elsewhere for the mpidr_el1 in arm64.

Thanks,
Mark.
