Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaHUMUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:20:07 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:23005
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751335AbaHUMUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:20:03 -0400
Date: Thu, 21 Aug 2014 14:19:51 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 1/9] ARM: zynq: PM: Enable A9 internal clock gating feature
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408567315-28479-2-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="u9B6IdofbnURCF0hptOP8LLwkN7nPivIW"
X-RCIS-Action: ALLOW
Message-ID: <26994133-6c3c-45c0-af09-3cb55ad35b13@BY2FFO11FD028.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(51704005)(377454003)(479174003)(164054003)(189002)(24454002)(568964001)(106466001)(107046002)(83072002)(70736001)(74316001)(65806001)(83506001)(87936001)(76482001)(512944002)(85306004)(104016003)(1496007)(54356999)(31966008)(95666004)(74662001)(102836001)(81542001)(77982001)(64126003)(79102001)(21056001)(65956001)(99396002)(4396001)(31696002)(80022001)(575784001)(86362001)(6806004)(92726001)(19580405001)(83322001)(46102001)(92566001)(76176999)(20776003)(50986999)(84326002)(44976005)(81342001)(85852003)(64706001)(71186001)(74502001)(19580395003)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB023;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u9B6IdofbnURCF0hptOP8LLwkN7nPivIW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/mach-zynq/common.c  |  6 ++++++
>  arch/arm/mach-zynq/common.h  | 11 +++++++++++
>  arch/arm/mach-zynq/platsmp.c |  9 +++++++++
>  3 files changed, 26 insertions(+)
>=20
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 31a6fa40ba37..3cb7c198615a 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -98,6 +98,11 @@ static int __init zynq_get_revision(void)
>  	return revision;
>  }
> =20
> +static void __init zynq_init_late(void)
> +{
> +	zynq_core_pm_init();
> +}
> +
>  /**
>   * zynq_init_machine - System specific initialization, intended to be
>   *		       called from board specific initialization.
> @@ -204,6 +209,7 @@ DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platfor=
m")
>  	.map_io		=3D zynq_map_io,
>  	.init_irq	=3D zynq_irq_init,
>  	.init_machine	=3D zynq_init_machine,
> +	.init_late	=3D zynq_init_late,
>  	.init_time	=3D zynq_timer_init,
>  	.dt_compat	=3D zynq_dt_match,
>  	.reserve	=3D zynq_memory_init,
> diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> index f652f0a884a6..596ef0b5067c 100644
> --- a/arch/arm/mach-zynq/common.h
> +++ b/arch/arm/mach-zynq/common.h
> @@ -40,4 +40,15 @@ extern void __iomem *zynq_scu_base;
>  /* Hotplug */
>  extern void zynq_platform_cpu_die(unsigned int cpu);
> =20
> +static inline void zynq_core_pm_init(void)
> +{
> +	/* A9 clock gating */
> +	asm volatile ("mrc  p15, 0, r12, c15, c0, 0\n"
> +		      "orr  r12, r12, #1\n"
> +		      "mcr  p15, 0, r12, c15, c0, 0\n"
> +		      : /* no outputs */
> +		      : /* no inputs */
> +		      : "r12");
> +}
> +
>  #endif
> diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.=
c
> index abc82ef085c1..616b99e07c60 100644
> --- a/arch/arm/mach-zynq/platsmp.c
> +++ b/arch/arm/mach-zynq/platsmp.c
> @@ -112,6 +112,14 @@ static void __init zynq_smp_prepare_cpus(unsigned =
int max_cpus)
>  	scu_enable(zynq_scu_base);
>  }
> =20
> +/*
> + * This function is in the hotplug path. Don't move it into the init s=
ection!!
> + */

Worth to use kernel-doc format here.

Thanks,
Michal


--u9B6IdofbnURCF0hptOP8LLwkN7nPivIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP14+cACgkQykllyylKDCF06wCaAxSiK5U5pSBIg7xsHPvP+Epq
OykAoJETtPKdaaopxOSH4si8TSQ/Hkid
=7ib3
-----END PGP SIGNATURE-----

--u9B6IdofbnURCF0hptOP8LLwkN7nPivIW--
