Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3EJNuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:50:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45848 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3EJNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:50:42 -0400
Message-ID: <518CFB25.3040603@ti.com>
Date: Fri, 10 May 2013 09:50:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-pm@vger.kernel.org>, <eduardo.valentin@ti.com>
Subject: Re: [RFC 26/42] drivers/thermal: don't check resource with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-27-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368173847-5661-27-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2THEHHFVQTUAICTMNLNAU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2THEHHFVQTUAICTMNLNAU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Wolfram,

On 10-05-2013 04:17, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need=
 to
> duplicate this in the driver.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/thermal/dove_thermal.c     |   11 +----------
>  drivers/thermal/exynos_thermal.c   |    5 -----
>  drivers/thermal/kirkwood_thermal.c |    7 +------
>  drivers/thermal/rcar_thermal.c     |    6 +-----

You missed drivers/thermal/armada_thermal.c ?

For the changes below:

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

>  4 files changed, 3 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_ther=
mal.c
> index 3078c40..5c53c53 100644
> --- a/drivers/thermal/dove_thermal.c
> +++ b/drivers/thermal/dove_thermal.c
> @@ -133,25 +133,16 @@ static int dove_thermal_probe(struct platform_dev=
ice *pdev)
>  	struct resource *res;
>  	int ret;
> =20
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
> -
>  	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> =20
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	priv->sensor =3D devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->sensor))
>  		return PTR_ERR(priv->sensor);
> =20
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
>  	priv->control =3D devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->control))
>  		return PTR_ERR(priv->control);
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_=
thermal.c
> index b777ae6..a7bef42 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -967,11 +967,6 @@ static int exynos_tmu_probe(struct platform_device=
 *pdev)
>  	INIT_WORK(&data->irq_work, exynos_tmu_work);
> =20
>  	data->mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!data->mem) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENOENT;
> -	}
> -
>  	data->base =3D devm_ioremap_resource(&pdev->dev, data->mem);
>  	if (IS_ERR(data->base))
>  		return PTR_ERR(data->base);
> diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkw=
ood_thermal.c
> index e5500ed..e3ca1b4 100644
> --- a/drivers/thermal/kirkwood_thermal.c
> +++ b/drivers/thermal/kirkwood_thermal.c
> @@ -75,16 +75,11 @@ static int kirkwood_thermal_probe(struct platform_d=
evice *pdev)
>  	struct kirkwood_thermal_priv *priv;
>  	struct resource *res;
> =20
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
> -
>  	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> =20
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	priv->sensor =3D devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->sensor))
>  		return PTR_ERR(priv->sensor);
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_ther=
mal.c
> index 2cc5b61..b2217b3 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -385,11 +385,6 @@ static int rcar_thermal_probe(struct platform_devi=
ce *pdev)
>  		 * platform has IRQ support.
>  		 * Then, drier use common register
>  		 */
> -		res =3D platform_get_resource(pdev, IORESOURCE_MEM, mres++);
> -		if (!res) {
> -			dev_err(dev, "Could not get platform resource\n");
> -			return -ENODEV;
> -		}
> =20
>  		ret =3D devm_request_irq(dev, irq->start, rcar_thermal_irq, 0,
>  				       dev_name(dev), common);
> @@ -401,6 +396,7 @@ static int rcar_thermal_probe(struct platform_devic=
e *pdev)
>  		/*
>  		 * rcar_has_irq_support() will be enabled
>  		 */
> +		res =3D platform_get_resource(pdev, IORESOURCE_MEM, mres++);
>  		common->base =3D devm_ioremap_resource(dev, res);
>  		if (IS_ERR(common->base))
>  			return PTR_ERR(common->base);
>=20



------enig2THEHHFVQTUAICTMNLNAU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGM+yUACgkQCXcVR3XQvP2zfgEA9NkKKRPIc7SF2WuecCpoRxxm
XXfFS7e7MJ1jUNL/oFQBAPhGVoA8OEd7O6TBRwqqghKbqC3R3H3X81RMQlednoKc
=dVVD
-----END PGP SIGNATURE-----

------enig2THEHHFVQTUAICTMNLNAU--
