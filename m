Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922Ab3FSXmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:42:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34273 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:42:36 -0400
Message-ID: <51C241E1.3060909@ti.com>
Date: Wed, 19 Jun 2013 19:42:25 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 20/30] thermal: exynos: use device resource management
 infrastructure
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-21-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-21-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2MRIEKUFMECEMWSXBFJEW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2MRIEKUFMECEMWSXBFJEW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch uses the device pointer stored in the configuration structur=
e
> and converts to dev_* prints and devm API's.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>


Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |   39 ++++++++++++++-=
-------
>  1 files changed, 25 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index 2873ca3..59b47e3 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -52,7 +52,8 @@ static int exynos_set_mode(struct thermal_zone_device=
 *thermal,
>  {
>  	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>  	if (!th_zone) {
> -		pr_notice("thermal zone not registered\n");
> +		dev_err(th_zone->sensor_conf->dev,
> +			"thermal zone not registered\n");
>  		return 0;
>  	}
> =20
> @@ -68,8 +69,9 @@ static int exynos_set_mode(struct thermal_zone_device=
 *thermal,
> =20
>  	th_zone->mode =3D mode;
>  	thermal_zone_device_update(thermal);
> -	pr_info("thermal polling set for duration=3D%d msec\n",
> -				thermal->polling_delay);
> +	dev_dbg(th_zone->sensor_conf->dev,
> +		"thermal polling set for duration=3D%d msec\n",
> +		thermal->polling_delay);
>  	return 0;
>  }
> =20
> @@ -159,7 +161,8 @@ static int exynos_bind(struct thermal_zone_device *=
thermal,
>  		case WARN_ZONE:
>  			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
>  								level, 0)) {
> -				pr_err("error binding cdev inst %d\n", i);
> +				dev_err(data->dev,
> +					"error unbinding cdev inst=3D%d\n", i);
>  				ret =3D -EINVAL;
>  			}
>  			th_zone->bind =3D true;
> @@ -204,7 +207,8 @@ static int exynos_unbind(struct thermal_zone_device=
 *thermal,
>  		case WARN_ZONE:
>  			if (thermal_zone_unbind_cooling_device(thermal, i,
>  								cdev)) {
> -				pr_err("error unbinding cdev inst=3D%d\n", i);
> +				dev_err(data->dev,
> +					"error unbinding cdev inst=3D%d\n", i);
>  				ret =3D -EINVAL;
>  			}
>  			th_zone->bind =3D false;
> @@ -224,7 +228,8 @@ static int exynos_get_temp(struct thermal_zone_devi=
ce *thermal,
>  	void *data;
> =20
>  	if (!th_zone->sensor_conf) {
> -		pr_info("Temperature sensor not initialised\n");
> +		dev_err(th_zone->sensor_conf->dev,
> +			"Temperature sensor not initialised\n");
>  		return -EINVAL;
>  	}
>  	data =3D th_zone->sensor_conf->driver_data;
> @@ -243,7 +248,8 @@ static int exynos_set_emul_temp(struct thermal_zone=
_device *thermal,
>  	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> =20
>  	if (!th_zone->sensor_conf) {
> -		pr_info("Temperature sensor not initialised\n");
> +		dev_err(th_zone->sensor_conf->dev,
> +			"Temperature sensor not initialised\n");
>  		return -EINVAL;
>  	}
>  	data =3D th_zone->sensor_conf->driver_data;
> @@ -337,11 +343,13 @@ int exynos_register_thermal(struct thermal_sensor=
_conf *sensor_conf)
>  	struct exynos_thermal_zone *th_zone;
> =20
>  	if (!sensor_conf || !sensor_conf->read_temperature) {
> -		pr_err("Temperature sensor not initialised\n");
> +		dev_err(sensor_conf->dev,
> +				"Temperature sensor not initialised\n");
>  		return -EINVAL;
>  	}
> =20
> -	th_zone =3D kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
> +	th_zone =3D devm_kzalloc(sensor_conf->dev,
> +				sizeof(struct exynos_thermal_zone), GFP_KERNEL);
>  	if (!th_zone)
>  		return -ENOMEM;
> =20
> @@ -350,7 +358,8 @@ int exynos_register_thermal(struct thermal_sensor_c=
onf *sensor_conf)
>  		cpumask_set_cpu(0, &mask_val);
>  		th_zone->cool_dev[0] =3D cpufreq_cooling_register(&mask_val);
>  		if (IS_ERR(th_zone->cool_dev[0])) {
> -			pr_err("Failed to register cpufreq cooling device\n");
> +			dev_err(sensor_conf->dev,
> +				"Failed to register cpufreq cooling device\n");
>  			ret =3D -EINVAL;
>  			goto err_unregister;
>  		}
> @@ -364,14 +373,16 @@ int exynos_register_thermal(struct thermal_sensor=
_conf *sensor_conf)
>  			IDLE_INTERVAL);
> =20
>  	if (IS_ERR(th_zone->therm_dev)) {
> -		pr_err("Failed to register thermal zone device\n");
> +		dev_err(sensor_conf->dev,
> +			"Failed to register thermal zone device\n");
>  		ret =3D PTR_ERR(th_zone->therm_dev);
>  		goto err_unregister;
>  	}
>  	th_zone->mode =3D THERMAL_DEVICE_ENABLED;
>  	sensor_conf->pzone_data =3D th_zone;
> =20
> -	pr_info("Exynos: Kernel Thermal management registered\n");
> +	dev_info(sensor_conf->dev,
> +		"Exynos: Thermal zone(%s) registered\n", sensor_conf->name);
> =20
>  	return 0;
> =20
> @@ -397,6 +408,6 @@ void exynos_unregister_thermal(struct thermal_senso=
r_conf *sensor_conf)
>  			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
>  	}
> =20
> -	kfree(th_zone);
> -	pr_info("Exynos: Kernel Thermal management unregistered\n");
> +	dev_info(sensor_conf->dev,
> +		"Exynos: Kernel Thermal management unregistered\n");
>  }
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2MRIEKUFMECEMWSXBFJEW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCQeEACgkQCXcVR3XQvP34KgEAyQoAoGUgbIOwCtSYFxDHcYwX
NfZF5833hAsnf60XrFkA/2gLEJsC31c7oSpLhD8C+1f3k90YZPQ6EtYh2mW2sQkY
=dXGe
-----END PGP SIGNATURE-----

------enig2MRIEKUFMECEMWSXBFJEW--
