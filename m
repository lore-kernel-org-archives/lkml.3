Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaHUMZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:25:37 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:6799
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755110AbaHUMZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:25:33 -0400
Date: Thu, 21 Aug 2014 14:25:22 +0200
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
Subject: Re: [PATCH 4/9] ARM: zynq: PM: Enable DDR self-refresh and clock
 stop
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-5-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408567315-28479-5-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="j9hBfSE6ExCPXO9W95jgk3Vf7EkqUDxHF"
X-RCIS-Action: ALLOW
Message-ID: <57cd5124-bd1d-47b9-b467-647937c15fff@BN1BFFO11FD052.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(479174003)(377454003)(164054003)(199003)(51704005)(24454002)(87936001)(83506001)(31966008)(76176999)(64706001)(85852003)(80022001)(65956001)(20776003)(83072002)(84326002)(65806001)(106466001)(31696002)(77982001)(74502001)(104016003)(74662001)(512874002)(568964001)(19580395003)(102836001)(15202345003)(46102001)(6806004)(107046002)(86362001)(33646002)(54356999)(71186001)(50986999)(70736001)(83322001)(44976005)(4396001)(81542001)(79102001)(19580405001)(99396002)(76482001)(85306004)(81342001)(1496007)(92566001)(74316001)(92726001)(15975445006)(95666004)(64126003)(575784001)(21056001)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB062;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--j9hBfSE6ExCPXO9W95jgk3Vf7EkqUDxHF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> The DDR controller can detect idle periods and leverage low power
> features like self-refresh and clock stop.
> When new requests occur, the DDRC resumes normal operation.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/mach-zynq/Makefile |  2 +-
>  arch/arm/mach-zynq/common.c |  1 +
>  arch/arm/mach-zynq/common.h |  2 ++
>  arch/arm/mach-zynq/pm.c     | 84 +++++++++++++++++++++++++++++++++++++=
++++++++
>  4 files changed, 88 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/mach-zynq/pm.c
>=20
> diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> index 1b25d92ebf22..820dff6e1eba 100644
> --- a/arch/arm/mach-zynq/Makefile
> +++ b/arch/arm/mach-zynq/Makefile
> @@ -3,7 +3,7 @@
>  #
> =20
>  # Common support
> -obj-y				:=3D common.o slcr.o
> +obj-y				:=3D common.o slcr.o pm.o
>  CFLAGS_REMOVE_hotplug.o		=3D-march=3Darmv6k
>  CFLAGS_hotplug.o 		=3D-Wa,-march=3Darmv7-a -mcpu=3Dcortex-a9
>  obj-$(CONFIG_HOTPLUG_CPU)	+=3D hotplug.o
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 3cb7c198615a..6bd13e5ce6b7 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -101,6 +101,7 @@ static int __init zynq_get_revision(void)
>  static void __init zynq_init_late(void)
>  {
>  	zynq_core_pm_init();
> +	zynq_pm_late_init();
>  }
> =20
>  /**
> diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> index 596ef0b5067c..87945fa2a179 100644
> --- a/arch/arm/mach-zynq/common.h
> +++ b/arch/arm/mach-zynq/common.h
> @@ -40,6 +40,8 @@ extern void __iomem *zynq_scu_base;
>  /* Hotplug */
>  extern void zynq_platform_cpu_die(unsigned int cpu);
> =20
> +int zynq_pm_late_init(void);
> +
>  static inline void zynq_core_pm_init(void)
>  {
>  	/* A9 clock gating */
> diff --git a/arch/arm/mach-zynq/pm.c b/arch/arm/mach-zynq/pm.c
> new file mode 100644
> index 000000000000..19955917aac8
> --- /dev/null
> +++ b/arch/arm/mach-zynq/pm.c
> @@ -0,0 +1,84 @@
> +/*
> + * Zynq power management
> + *
> + *  Copyright (C) 2012 - 2014 Xilinx
> + *
> + *  S=C3=B6ren Brinkmann <soren.brinkmann@xilinx.com>
> + *
> + * This program is free software: you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/=
>.

IRC this paragraph is not necessary and can be just removed.

> + */
> +
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include "common.h"
> +
> +/* register offsets */
> +#define DDRC_CTRL_REG1_OFFS		0x60
> +#define DDRC_DRAM_PARAM_REG3_OFFS	0x20
> +
> +/* bitfields */
> +#define DDRC_CLOCKSTOP_MASK	BIT(23)
> +#define DDRC_SELFREFRESH_MASK	BIT(12)
> +
> +static void __iomem *ddrc_base;
> +
> +/**
> + * zynq_pm_ioremap() - Create IO mappings
> + * @comp:	DT compatible string
> + * Returns a pointer to the mapped memory or NULL.
> + *
> + * Remap the memory region for a compatible DT node.
> + */

[linux]$ ./scripts/kernel-doc -man -v arch/arm/mach-zynq/pm.c > /dev/null=

Info(arch/arm/mach-zynq/pm.c:38): Scanning doc for
Warning(arch/arm/mach-zynq/pm.c:45): No description found for return valu=
e of 'zynq_pm_ioremap'

> +static void __iomem *zynq_pm_ioremap(const char *comp)
> +{
> +	struct device_node *np;
> +	void __iomem *base =3D NULL;
> +
> +	np =3D of_find_compatible_node(NULL, NULL, comp);
> +	if (np) {
> +		base =3D of_iomap(np, 0);
> +		of_node_put(np);
> +	} else {
> +		pr_warn("%s: no compatible node found for '%s'\n", __func__,
> +				comp);
> +	}
> +
> +	return base;
> +}
> +
> +int __init zynq_pm_late_init(void)

kernel doc will be nice to have here.

> +{
> +	u32 reg;
> +
> +	ddrc_base =3D zynq_pm_ioremap("xlnx,zynq-ddrc-a05");
> +	if (!ddrc_base) {
> +		pr_warn("%s: Unable to map DDRC IO memory.\n", __func__);
> +	} else {
> +		/*
> +		 * Enable DDRC self-refresh and clock stop features. The HW
> +		 * takes care of entering/exiting the correct modes depending
> +		 * on activity state.
> +		 */
> +		reg =3D readl(ddrc_base + DDRC_CTRL_REG1_OFFS);
> +		reg |=3D DDRC_SELFREFRESH_MASK;
> +		writel(reg, ddrc_base + DDRC_CTRL_REG1_OFFS);
> +
> +		reg =3D readl(ddrc_base + DDRC_DRAM_PARAM_REG3_OFFS);
> +		reg |=3D DDRC_CLOCKSTOP_MASK;
> +		writel(reg, ddrc_base + DDRC_DRAM_PARAM_REG3_OFFS);
> +	}
> +
> +	return 0;

You are not using this return value that's why I would just remove it and=

change function return type to void.

Thanks,
Michal


--j9hBfSE6ExCPXO9W95jgk3Vf7EkqUDxHF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP15TIACgkQykllyylKDCG4ogCeLZvhtmZ5x/CgliMX7yKNMKNZ
9IUAoJnLR4Sg4teMfG0vag2GitKmUHJb
=9FMd
-----END PGP SIGNATURE-----

--j9hBfSE6ExCPXO9W95jgk3Vf7EkqUDxHF--
