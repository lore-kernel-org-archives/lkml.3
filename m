Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaG1SfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:35:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35322 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaG1SfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:35:18 -0400
Message-ID: <53D69801.9090901@arm.com>
Date: Mon, 28 Jul 2014 19:35:45 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH 02/19] ARM64 / ACPI: Introduce early_param for "acpi"
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-3-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1406206825-15590-3-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 28 Jul 2014 18:35:14.0891 (UTC) FILETIME=[AC40D1B0:01CFAA92]
X-MC-Unique: 114072819351600301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/07/14 14:00, Hanjun Guo wrote:
> From: Al Stone <al.stone@linaro.org>
>
> Introduce two early parameters for "acpi", one is the parameter
> to disable ACPI on ARM64 and another one is acpi=strict to disable
> out-of-spec workarounds.
>
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>   Documentation/kernel-parameters.txt |    3 ++-
>   arch/arm64/kernel/acpi.c            |   21 +++++++++++++++++++++
>   2 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index b7fa2f5..d130bd5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -165,7 +165,7 @@ multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
>   bytes respectively. Such letter suffixes can also be entirely omitted.
>
>
> -	acpi=		[HW,ACPI,X86]
> +	acpi=		[HW,ACPI,X86,ARM]
>   			Advanced Configuration and Power Interface
>   			Format: { force | off | strict | noirq | rsdt }
>   			force -- enable ACPI if default was off
> @@ -175,6 +175,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   				strictly ACPI specification compliant.
>   			rsdt -- prefer RSDT over (default) XSDT
>   			copy_dsdt -- copy DSDT to memory
> +			For ARM64, ONLY "off" and "strict" are available.
>
>   			See also Documentation/power/runtime_pm.txt, pci=noacpi
>
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index c62fce6..ac78e4e 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -74,3 +74,24 @@ void __init acpi_boot_table_init(void)
>   		return;
>   	}
>   }
> +
> +static int __init parse_acpi(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	/* "acpi=off" disables both ACPI table parsing and interpreter */
> +	if (strcmp(arg, "off") == 0) {
> +		disable_acpi();
> +	}
> +	/* acpi=strict disables out-of-spec workarounds */
> +	else if (strcmp(arg, "strict") == 0) {
> +		acpi_strict = 1;

This should be default set as I mentioned in patch#1. We can introduce
this option if required in future.

Regards,
Sudeep

