Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3GVOPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:15:00 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53969 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3GVOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:14:58 -0400
Date: Mon, 22 Jul 2013 10:14:55 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 02/16] ARM: DT/kernel: define ARM specific
 arch_match_cpu_phys_id
In-Reply-To: <1374492747-13879-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Message-ID: <alpine.LFD.2.03.1307221014270.15022@syhkavp.arg>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Sudeep KarkadaNagesha wrote:

> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> OF/DT core library now provides architecture specific hook to match the
> logical cpu index with the corresponding physical identifier. Most of the
> cpu DT node parsing and initialisation is contained in devtree.c. So it's
> better to define ARM specific arch_match_cpu_phys_id there.
> 
> This mainly helps to avoid replication of the code doing CPU node parsing
> and physical(MPIDR) to logical mapping.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/kernel/devtree.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 5859c8b..2ee8a17 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -169,6 +169,11 @@ void __init arm_dt_init_cpu_maps(void)
>  	}
>  }
>  
> +bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
> +{
> +	return (phys_id & MPIDR_HWID_BITMASK) == cpu_logical_map(cpu);
> +}
> +
>  /**
>   * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
>   * @dt_phys: physical address of dt blob
> -- 
> 1.8.1.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
