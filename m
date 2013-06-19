Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376Ab3FSXxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:53:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46890 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934604Ab3FSXxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:53:44 -0400
Message-ID: <51C24479.9080205@ti.com>
Date: Wed, 19 Jun 2013 19:53:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 22/30] thermal: exynos: Add support to access common
 register for multistance
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-23-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-23-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2KJAWURSHMDVJPIJUBOTU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2KJAWURSHMDVJPIJUBOTU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch adds support to parse one more common set of TMU register. F=
irst
> set of register belongs to each instance of TMU and second set belongs =
to
> common TMU registers.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

This patch is fine:

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

But please read my concern on next patch.

> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    6 +++++-
>  drivers/thermal/samsung/exynos_tmu.c               |   20 ++++++++++++=
++++++++
>  2 files changed, 25 insertions(+), 1 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 535fd0e..0ea33f7 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -7,7 +7,11 @@
>  	       "samsung,exynos4210-tmu"
>  	       "samsung,exynos5250-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
> -- reg : Address range of the thermal registers
> +- reg : Address range of the thermal registers. For soc's which has mu=
ltiple
> +	instances of TMU and some registers are shared across all TMU's like
> +	interrupt related then 2 set of register has to supplied. First set
> +	belongs	to each instance of TMU and second set belongs to common TMU
> +	registers.
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 877dab8..150a869 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -40,6 +40,7 @@
>   * @id: identifier of the one instance of the TMU controller.
>   * @pdata: pointer to the tmu platform/configuration data
>   * @base: base address of the single instance of the TMU controller.
> + * @base_common: base address of the common registers of the TMU contr=
oller.
>   * @irq: irq number of the TMU controller.
>   * @soc: id of the SOC type.
>   * @irq_work: pointer to the irq work structure.
> @@ -53,6 +54,7 @@ struct exynos_tmu_data {
>  	int id;
>  	struct exynos_tmu_platform_data *pdata;
>  	void __iomem *base;
> +	void __iomem *base_common;
>  	int irq;
>  	enum soc_type soc;
>  	struct work_struct irq_work;
> @@ -478,6 +480,24 @@ static int exynos_map_dt_data(struct platform_devi=
ce *pdev)
>  		return -ENODEV;
>  	}
>  	data->pdata =3D pdata;
> +	/*
> +	 * Check if the TMU shares some registers and then try to map the
> +	 * memory of common registers.
> +	 */
> +	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
> +		return 0;
> +
> +	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
> +		dev_err(&pdev->dev, "failed to get Resource 1\n");
> +		return -ENODEV;
> +	}
> +
> +	data->base_common =3D devm_ioremap(&pdev->dev, res.start,
> +					resource_size(&res));
> +	if (!data->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap memory\n");
> +		return -ENOMEM;
> +	}
> =20
>  	return 0;
>  }
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2KJAWURSHMDVJPIJUBOTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCRHkACgkQCXcVR3XQvP2sFQEAvKszEOLhCJxyZvnVRVoJR3rm
kwAZyTb+ge0h1w16S0IA/2UalkTnUDPYIuUHa3imIOFABrVDjkVtL9llmZbesj67
=HJCV
-----END PGP SIGNATURE-----

------enig2KJAWURSHMDVJPIJUBOTU--
