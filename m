Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935306Ab3FSW0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:26:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55431 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935220Ab3FSW0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:26:37 -0400
Message-ID: <51C2300C.9090503@ti.com>
Date: Wed, 19 Jun 2013 18:26:20 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 12/30] thermal: exynos: Fix to clear only the generated
 interrupts
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-13-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-13-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2VIOPOKGPIGINLWESGBRR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2VIOPOKGPIGINLWESGBRR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch uses the TMU status register to know the generated interrupt=
s
> and only clear them in the interrupt handler.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

>  drivers/thermal/samsung/exynos_tmu.c      |   11 +++++------
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  2 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 33f494e..f6f63ca 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -351,17 +351,16 @@ static void exynos_tmu_work(struct work_struct *w=
ork)
>  			struct exynos_tmu_data, irq_work);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	const struct exynos_tmu_registers *reg =3D pdata->registers;
> +	unsigned int val_irq;
> =20
>  	exynos_report_trigger();
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	if (data->soc =3D=3D SOC_ARCH_EXYNOS)
> -		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> -			(reg->inten_fall_mask << reg->inten_fall_shift),
> -				data->base + reg->tmu_intclear);
> -	else
> -		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
> +	/* TODO: take action based on particular interrupt */
> +	val_irq =3D readl(data->base + reg->tmu_intstat);
> +	/* clear the interrupts */
> +	writel(val_irq, data->base + reg->tmu_intclear);
> =20
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index e7cb1cc..7fcf183 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -45,6 +45,7 @@ static const struct exynos_tmu_registers exynos4210_t=
mu_registers =3D {
>  	.inten_rise1_shift =3D EXYNOS_TMU_INTEN_RISE1_SHIFT,
>  	.inten_rise2_shift =3D EXYNOS_TMU_INTEN_RISE2_SHIFT,
>  	.inten_rise3_shift =3D EXYNOS_TMU_INTEN_RISE3_SHIFT,
> +	.tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>  };
>  struct exynos_tmu_platform_data const exynos4210_default_tmu_data =3D =
{
> @@ -112,6 +113,7 @@ static const struct exynos_tmu_registers exynos5250=
_tmu_registers =3D {
>  	.inten_rise2_shift =3D EXYNOS_TMU_INTEN_RISE2_SHIFT,
>  	.inten_rise3_shift =3D EXYNOS_TMU_INTEN_RISE3_SHIFT,
>  	.inten_fall0_shift =3D EXYNOS_TMU_INTEN_FALL0_SHIFT,
> +	.tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>  	.emul_con =3D EXYNOS_EMUL_CON,
>  	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2VIOPOKGPIGINLWESGBRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCMAwACgkQCXcVR3XQvP3cLgD/frnTlEsmII01GJFynkFwJB1b
FlaPNMeziynULbCeObkBALHkS5zlTw+Q7oMl03YtNFa8KJjl4RO4NCXPdwZH1nUD
=eu1h
-----END PGP SIGNATURE-----

------enig2VIOPOKGPIGINLWESGBRR--
