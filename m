Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3LCQ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:58:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53398 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3LCQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:58:40 -0500
Date: Tue, 3 Dec 2013 16:57:55 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu
 possible/present maps and map logical cpu id to APIC id
Message-ID: <20131203165755.37b07796@alan.etchedpixels.co.uk>
In-Reply-To: <1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
	<1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> index 45ff625..8527ecc 100644
> --- a/drivers/acpi/plat/arm-core.c
> +++ b/drivers/acpi/plat/arm-core.c
> @@ -58,6 +58,13 @@ EXPORT_SYMBOL(acpi_pci_disabled);
>   */
>  static u64 acpi_lapic_addr __initdata;
>  
> +/* available_cpus here means enabled cpu in MADT */
> +int available_cpus;
> +
> +/* Map logic cpu id to physical GIC id. */
> +int arm_cpu_to_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
> +int boot_cpu_apic_id = -1;
> +

static ?

Really shouldn't be leaking names like "available_cpus" out of ACPI into
the global namespace


> +#ifdef CONFIG_SMP
> +	if (available_cpus == 0) {
> +		pr_info(PREFIX "Found 0 CPUs; assuming 1\n");
> +		/* FIXME: should be the real GIC id read from hardware */
> +		arm_cpu_to_apicid[available_cpus] = 0;
> +		available_cpus = 1;	/* We've got at least one of these */
> +	}
> +#endif

Isn't this true uniprocessor (by definition in fact)


> + */
> +void __init prefill_possible_map(void)

leaking more unprefixed names into the global namespace

