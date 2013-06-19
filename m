Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339Ab3FSWog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:44:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43940 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935028Ab3FSWof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:44:35 -0400
Message-ID: <51C23447.4020909@ti.com>
Date: Wed, 19 Jun 2013 18:44:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 14/30] thermal: exynos: Modify private_data to appropriate
 name driver_data
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-15-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-15-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2LSANGEMNCQLHRICHUGLE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2LSANGEMNCQLHRICHUGLE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch renames member private_data to driver_data of the thermal
> zone registration structure as this item stores the driver related
> data and uses it to call the driver related callbacks.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |    4 ++--
>  drivers/thermal/samsung/exynos_thermal_common.h |    2 +-
>  drivers/thermal/samsung/exynos_tmu.c            |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index 2af1e3b..7064eb7 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -221,7 +221,7 @@ static int exynos_get_temp(struct thermal_zone_devi=
ce *thermal,
>  		pr_info("Temperature sensor not initialised\n");
>  		return -EINVAL;
>  	}
> -	data =3D th_zone->sensor_conf->private_data;
> +	data =3D th_zone->sensor_conf->driver_data;
>  	*temp =3D th_zone->sensor_conf->read_temperature(data);
>  	/* convert the temperature into millicelsius */
>  	*temp =3D *temp * MCELSIUS;
> @@ -240,7 +240,7 @@ static int exynos_set_emul_temp(struct thermal_zone=
_device *thermal,
>  		pr_info("Temperature sensor not initialised\n");
>  		return -EINVAL;
>  	}
> -	data =3D th_zone->sensor_conf->private_data;
> +	data =3D th_zone->sensor_conf->driver_data;
>  	if (th_zone->sensor_conf->write_emul_temp)
>  		ret =3D th_zone->sensor_conf->write_emul_temp(data, temp);
>  	return ret;
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> index a845c2d..1e9a326 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -83,7 +83,7 @@ struct thermal_sensor_conf {
>  	int (*write_emul_temp)(void *drv_data, unsigned long temp);
>  	struct thermal_trip_point_conf trip_data;
>  	struct thermal_cooling_conf cooling_data;
> -	void *private_data;
> +	void *driver_data;
>  	void *pzone_data;
>  };
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index a7bba69..40e0cfd 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -504,7 +504,7 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  	exynos_tmu_control(pdev, true);
> =20
>  	/* Register the sensor with thermal management interface */
> -	(&exynos_sensor_conf)->private_data =3D data;
> +	(&exynos_sensor_conf)->driver_data =3D data;
>  	exynos_sensor_conf.trip_data.trip_count =3D pdata->trigger_enable[0] =
+
>  			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
>  			pdata->trigger_enable[3];
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2LSANGEMNCQLHRICHUGLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCNEcACgkQCXcVR3XQvP0UqAEAv8eN4xD80qBX2aJeEIcr2lds
CrzGEzp6+E/ASmIgtOwBAJCUQQOtQ0woZcs/ruViuMM0SUSQMKiJNS5nmXJfzJMA
=8LOP
-----END PGP SIGNATURE-----

------enig2LSANGEMNCQLHRICHUGLE--
