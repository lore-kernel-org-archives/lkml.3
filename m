Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbbAWIIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:08:22 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:46597 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbAWIIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:08:17 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v2] ARM: at91: fix PM initialization for newer SoCs
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1421942867-11309-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 23 Jan 2015 15:50:13 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, Wenyou Yang <wenyou.yang@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D0221EB9-B6B3-4860-83D6-427E3C718193@jcrosoft.com>
References: <1421942584-2364-1-git-send-email-nicolas.ferre@atmel.com> <1421942867-11309-1-git-send-email-nicolas.ferre@atmel.com>
To: Nicolas FERRE <nicolas.ferre@atmel.com>
X-Mailer: Apple Mail (2.1993)
X-Ovh-Tracer-Id: 18246615366633040748
X-Ovh-Remote: 80.15.34.121 (lmontsouris-656-1-34-121.w80-15.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jan 23, 2015, at 12:07 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
> Newer SoCs: at91sam9x5, at91sam9n12, sama5d3 and sama5d4 embed a DDR controller
> and have a different PMC status register layout than the at91sam9g45. Create
> another at91_sam9x5_pm_init() function to match this compatibility.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> arch/arm/mach-at91/board-dt-sam9.c  | 20 ++++++++++++++++++++
> arch/arm/mach-at91/board-dt-sama5.c |  2 +-
> arch/arm/mach-at91/generic.h        |  2 ++
> arch/arm/mach-at91/pm.c             |  7 +++++++
> 4 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
> index 0fe1ced608c5..c8252ddac6f0 100644
> --- a/arch/arm/mach-at91/board-dt-sam9.c
> +++ b/arch/arm/mach-at91/board-dt-sam9.c
> @@ -61,3 +61,23 @@ DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
> 	.init_machine	= sam9g45_dt_device_init,
> 	.dt_compat	= at91_9g45_board_compat,
> MACHINE_END
> +
> +static void __init sam9x5_dt_device_init(void)
> +{
> +	at91_sam9x5_pm_init();
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}
> +
> +static const char *at91_9x5_board_compat[] __initconst = {
> +	"atmel,at91sam9x5",
> +	"atmel,at91sam9n12",
> +	NULL
> +};
> +
> +DT_MACHINE_START(at91sam9x5_dt, "Atmel AT91SAM9”)
sam9? sam9x5
> +	/* Maintainer: Atmel */
> +	.map_io		= at91_map_io,
> +	.init_early	= at91_dt_initialize,
> +	.init_machine	= sam9x5_dt_device_init,
> +	.dt_compat	= at91_9x5_board_compat,
> +MACHINE_END

why a second START instead of a pdata?

and create a second dt compatible
e
Best Regards,
J.
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 44d372a22a29..b7338966c8ab 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -28,7 +28,7 @@
> 
> static void __init sama5_dt_device_init(void)
> {
> -	at91_sam9260_pm_init();
> +	at91_sam9x5_pm_init();
> 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> }
> 
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index 1e60faec2eba..709570cbef2b 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -32,10 +32,12 @@ extern void at91sam9_idle(void);
> extern void __init at91_rm9200_pm_init(void);
> extern void __init at91_sam9260_pm_init(void);
> extern void __init at91_sam9g45_pm_init(void);
> +extern void __init at91_sam9x5_pm_init(void);
> #else
> void __init at91_rm9200_pm_init(void) { }
> void __init at91_sam9260_pm_init(void) { }
> void __init at91_sam9g45_pm_init(void) { }
> +void __init at91_sam9x5_pm_init(void) { }
> #endif
> 
> #endif /* _AT91_GENERIC_H */
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 81f2f12d3cc1..87c1fd8aa1b6 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -306,3 +306,10 @@ void __init at91_sam9g45_pm_init(void)
> 	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
> 	return at91_pm_init();
> }
> +
> +void __init at91_sam9x5_pm_init(void)
> +{
> +	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
> +	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
> +	return at91_pm_init();
> +}
> -- 
> 2.1.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

