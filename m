Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3LCSDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:03:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54102 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab3LCSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:03:02 -0500
Date: Tue, 3 Dec 2013 18:03:00 +0000
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
        Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [RFC part1 PATCH 5/7] ARM64 / ACPI: Introduce arm_core.c and
 its related head file
Message-ID: <20131203180300.GD16025@e106331-lin.cambridge.arm.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <1386088611-2801-6-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386088611-2801-6-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:36:49PM +0000, Hanjun Guo wrote:
> introduce arm_core.c and its related head file, after this patch,
> we can get ACPI tables from BIOS on ARM64 now.
> 
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h |   57 +++++++++++
>  arch/arm64/kernel/setup.c     |    8 ++
>  drivers/acpi/Makefile         |    2 +
>  drivers/acpi/plat/Makefile    |    1 +
>  drivers/acpi/plat/arm-core.c  |  219 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 287 insertions(+)
>  create mode 100644 drivers/acpi/plat/Makefile
>  create mode 100644 drivers/acpi/plat/arm-core.c
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index c186f5b..e9444e4 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -19,6 +19,43 @@
>  #ifndef _ASM_ARM_ACPI_H
>  #define _ASM_ARM_ACPI_H
>  
> +#include <asm/cacheflush.h>
> +
> +#include <linux/init.h>
> +
> +#define COMPILER_DEPENDENT_INT64	long long
> +#define COMPILER_DEPENDENT_UINT64	unsigned long long

Given we've already pulled in linux/init.h, which has pulled in
linux/types.h, is there any reason we can't use s64 and u64 here?

If we can, then why don't we unify this further up so each arch doesn't
have to define this redundantly?

> +
> +/*
> + * Calling conventions:
> + *
> + * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
> + * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
> + * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
> + * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
> + */
> +#define ACPI_SYSTEM_XFACE
> +#define ACPI_EXTERNAL_XFACE
> +#define ACPI_INTERNAL_XFACE
> +#define ACPI_INTERNAL_VAR_XFACE
> +
> +/* Asm macros */
> +#define ACPI_FLUSH_CPU_CACHE() flush_cache_all()

Can you elaborate on when ACPI needs to use this? 

Thanks,
Mark.
