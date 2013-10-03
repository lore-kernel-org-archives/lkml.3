Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3JCWFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:05:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35025 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab3JCWFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:05:35 -0400
Message-ID: <524DEA1D.4010100@ti.com>
Date: Thu, 3 Oct 2013 18:05:17 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 3/6] thermal: exynos: Provide initial setting for TMU's
 test MUX address at Exynos4412
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1380010102-25817-4-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1380010102-25817-4-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="x48qfQ9pksU8INCS0tQosU8inM9F5KQMK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x48qfQ9pksU8INCS0tQosU8inM9F5KQMK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24-09-2013 04:08, Lukasz Majewski wrote:
> The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal: exynos: =
Add
> missing definations and code cleanup") has removed setting of test MUX =
address
> value at TMU configuration setting.
>=20
> This field is not present on Exynos4210 and Exynos5 SoCs. However on Ex=
ynos4412
> SoC it is required to set this field after reset because without it TMU=
 shows
> maximal available temperature, which causes immediate platform shutdown=
=2E
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    3 +++
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
>  2 files changed, 7 insertions(+)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index a858cc4..21b89e4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -317,6 +317,9 @@ static void exynos_tmu_control(struct platform_devi=
ce *pdev, bool on)
> =20
>  	con =3D readl(data->base + reg->tmu_ctrl);
> =20
> +	if (pdata->type =3D=3D SOC_ARCH_EXYNOS4412)
> +		con |=3D (EXYNOS4412_MUX_ADDR_VALUE << EXYNOS4412_MUX_ADDR_SHIFT);

Amit has introduced a way to describe features instead of checking
features per type. It would be interesting to have a reasoning why not
to use it. Think what if new Exynos TMU versions come, are you guys
going to steadily increase the above check for type?

> +
>  	if (pdata->reference_voltage) {
>  		con &=3D ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
>  		con |=3D pdata->reference_voltage << reg->buf_vref_sel_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index b130b1e..a1ea19d 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -95,6 +95,10 @@
> =20
>  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> =20
> +/* Exynos4412 specific */
> +#define EXYNOS4412_MUX_ADDR_VALUE          6
> +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> +
>  /*exynos5440 specific registers*/
>  #define EXYNOS5440_TMU_S0_7_TRIM		0x000
>  #define EXYNOS5440_TMU_S0_7_CTRL		0x020
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--x48qfQ9pksU8INCS0tQosU8inM9F5KQMK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJN6h0ACgkQCXcVR3XQvP2GYgEAn8cB3ncvAllIToWVPSZk+pP4
fh2c4TvBaUoZiJBlOTIBAOxFJmwapqX8ILQMV101hSICdmPdpuzGgFayzg8P2PsK
=eUw7
-----END PGP SIGNATURE-----

--x48qfQ9pksU8INCS0tQosU8inM9F5KQMK--
