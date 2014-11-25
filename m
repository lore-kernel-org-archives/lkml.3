Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaKYUoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:44:16 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43802 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKYUoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:44:15 -0500
Date: Tue, 25 Nov 2014 16:44:03 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: Re: [PATCH v2 4/4] thermal: of: Extend current of-thermal.c code to
 allow setting emulated temp
Message-ID: <20141125204401.GC14292@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-5-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <1416500488-7232-5-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2014 at 05:21:28PM +0100, Lukasz Majewski wrote:
> Before this change it was only possible to set get_temp() and get_trend()
> methods to be used in the common code handling passing parameters via
> device tree to "cpu-thermal" CPU thermal zone device.
>=20
> Now it is possible to also set emulated value of temperature for debug
> purposes.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v2:
> - Rework the emulated temperature setting code to use of_thermal_sensor_o=
ps
> structure
> ---
>  drivers/thermal/of-thermal.c | 24 ++++++++++++++++++++++++
>  include/linux/thermal.h      |  1 +
>  2 files changed, 25 insertions(+)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 33921c5..ad7dc2b 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -174,6 +174,28 @@ of_thermal_get_trip_points(struct thermal_zone_devic=
e *tz)
>  	return data->gtrips;
>  }
> =20
> +/**
> + * of_thermal_set_emul_temp - function to set emulated temperature
> + *
> + * @tz:	pointer to a thermal zone
> + * @temp:	temperature to set
> + *
> + * This function gives the ability to set emulated value of temperature,
> + * which is handy for debugging
> + *
> + * Return: zero on success, error code otherwise
> + */
> +static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
> +				    unsigned long temp)
> +{
> +	struct __thermal_zone *data =3D tz->devdata;
> +
> +	if (!data->ops || !data->ops->set_emul_temp)
> +		return -EINVAL;
> +
> +	return data->ops->set_emul_temp(data->sensor_data, temp);
> +}
> +
>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>  				enum thermal_trend *trend)
>  {
> @@ -405,6 +427,7 @@ thermal_zone_of_add_sensor(struct device_node *zone,
> =20
>  	tzd->ops->get_temp =3D of_thermal_get_temp;
>  	tzd->ops->get_trend =3D of_thermal_get_trend;
> +	tzd->ops->set_emul_temp =3D of_thermal_set_emul_temp;
>  	mutex_unlock(&tzd->lock);
> =20
>  	return tzd;
> @@ -533,6 +556,7 @@ void thermal_zone_of_sensor_unregister(struct device =
*dev,
>  	mutex_lock(&tzd->lock);
>  	tzd->ops->get_temp =3D NULL;
>  	tzd->ops->get_trend =3D NULL;
> +	tzd->ops->set_emul_temp =3D NULL;
> =20
>  	tz->ops =3D NULL;
>  	tz->sensor_data =3D NULL;
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 88d7249..5eb9d44 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -301,6 +301,7 @@ struct thermal_genl_event {
>  struct thermal_zone_of_device_ops {
>  	int (*get_temp)(void *, long *);
>  	int (*get_trend)(void *, long *);
> +	int (*set_emul_temp)(void *, unsigned long);

Please add it in the list of Optional functions in the comment above
this struct.

Apart from that:


Acked-by: Eduardo Valentin <edubezval@gmail.com>


>  };
> =20
>  /**
> --=20
> 2.0.0.rc2
>=20

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdOoGAAoJEMLUO4d9pOJW3xwH/1Zqr6x/YBIxgI/C3F+nUMJd
DIM+167vjltatdqCxPuw8KxjFNPd8LI6XmKC+RMlgFByEejX+dXAcKUMGVblEhSv
FasH2yIak21Ofw9wBcQcrOB+9sMyFa8bTzVLNuzZKS5deQDQfoiVuVuZeJUlIula
SuTkvzYQGYT/tJy/kA8FzuRF2Dui3rLeDjrXzeXDQWNfUPByQFgeOVvXVSLjfH9w
VOaydBbXKXhYT0465QIvID6uDpzCUd600xLabWB24A8MJexUPFZZ81AlPwqu6Lms
gUhAX1MPNuIpKTHopkQIyFi25BUf7M6SHgAV9DMNeSPUvS38NHZmarxwnXS7iKs=
=KpoC
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
