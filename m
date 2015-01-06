Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbbAFN0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:26:54 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34285 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbAFN0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:26:51 -0500
Date: Tue, 6 Jan 2015 09:25:48 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Anson Huang <b20788@freescale.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, jangra.pankaj9@gmail.com
Subject: Re: [PATCH V2] Thermal: imx: add clk disable/enable for
 suspend/resume
Message-ID: <20150106132546.GB16132@developer>
References: <1420541422-27602-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <1420541422-27602-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 06:50:22PM +0800, Anson Huang wrote:
> Thermal sensor's clk is from pll3_usb_otg, per hardware
> design requirement, need to make sure pll3_usb_otg is disabled
> before STOP mode is entered, otherwise, all PFDs under it may
> enter incorrect state, this patch disables pll3_usb_otg before
> suspend and enables it after resume.
>=20
> Signed-off-by: Anson Huang <b20788@freescale.com>

adding to my -fixes branch.

> ---
>  drivers/thermal/imx_thermal.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 461bf3d..dc8bcd8 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -600,6 +600,7 @@ static int imx_thermal_suspend(struct device *dev)
>  	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP);
>  	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
>  	data->mode =3D THERMAL_DEVICE_DISABLED;
> +	clk_disable_unprepare(data->thermal_clk);
> =20
>  	return 0;
>  }
> @@ -609,6 +610,7 @@ static int imx_thermal_resume(struct device *dev)
>  	struct imx_thermal_data *data =3D dev_get_drvdata(dev);
>  	struct regmap *map =3D data->tempmon;
> =20
> +	clk_prepare_enable(data->thermal_clk);
>  	/* Enabled thermal sensor after resume */
>  	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
>  	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
> --=20
> 1.9.1
>=20

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq+IwAAoJEMLUO4d9pOJWwUIH/R3wYdyPBjN/nEcT2TmFBisC
6NiXxvJWO4GcH8x7hWZFCxQG1yjWCeEEKTFJoRVSL4seVtlF72WUQfJ68CaIEnrj
hVz91L/ruipMul2lnin740ecasrHHkQoX/9O+cwj6wZOPg/aXRYsYwq8GSgSMmjY
MlkCGY5EORR0T6h2mSpO90hgIZXJUgQpLlWwfEUp6gLRFvjGOQ2OU1ZWCP2ukJyn
H5Sy7ol62Ts9ODSVbbIV5Dndmkf1FfJmiEel+PSD/qHtboM62nEluOHDgRRLPkDm
TQhqRun2E/kLC6Ti0XI7t+wP3yk6tLb23YnvD2fe88c5QLHOjNKhIU9F6WEJGcw=
=U3xm
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
