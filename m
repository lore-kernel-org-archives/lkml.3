Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbbASLnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:43:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37820 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbASLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:43:07 -0500
Date: Mon, 19 Jan 2015 11:42:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
 and pass acpi=force to enable ACPI
Message-ID: <20150119114255.GF11835@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org>
Thread-Topic: [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
 and pass acpi=force to enable ACPI
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:04:52PM +0000, Hanjun Guo wrote:
> From: Al Stone <al.stone@linaro.org>
> 
> Introduce one early parameters "off" and "force" for "acpi", acpi=off
> will be the default behavior for ARM64, so introduce acpi=force to
> enable ACPI on ARM64.
> 
> Disable ACPI before early parameters parsed, and enable it to pass
> "acpi=force" if people want use ACPI on ARM64. This ensures DT be
> the prefer one if ACPI table and DT both are provided at this moment.
[...]
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -62,6 +62,7 @@
>  #include <asm/memblock.h>
>  #include <asm/psci.h>
>  #include <asm/efi.h>
> +#include <asm/acpi.h>
>  
>  unsigned int processor_id;
>  EXPORT_SYMBOL(processor_id);
> @@ -388,6 +389,8 @@ void __init setup_arch(char **cmdline_p)
>  	early_fixmap_init();
>  	early_ioremap_init();
>  
> +	disable_acpi();
> +
>  	parse_early_param();
>  
>  	/*

Did we get to any conclusion here? DT being the preferred one is fine
when both DT and ACPI are present but do we still want the kernel to
ignore ACPI altogether if DT is not present? It's a bit harder to detect
the presence of DT at this point since the EFI_STUB added one already. I
guess we could move the "acpi=force" argument passing to EFI_STUB if no
DT is present at boot.

-- 
Catalin
