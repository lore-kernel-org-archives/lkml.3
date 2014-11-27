Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaK0Oct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:32:49 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:62317 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaK0Ocr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:32:47 -0500
Date: Thu, 27 Nov 2014 10:32:38 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Navneet Kumar <navneetk@nvidia.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] thermal: of: notify sensor driver on trip updates
Message-ID: <20141127143236.GD3342@developer>
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
 <1417050989-25405-3-git-send-email-navneetk@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1417050989-25405-3-git-send-email-navneetk@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Navneet,

On Wed, Nov 26, 2014 at 05:16:29PM -0800, Navneet Kumar wrote:
> From: navneet kumar <navneetk@nvidia.com>
>=20
> some thermal sensor hardwares include logic which
> can raise interrupts at certain programmed temperature
> thresholds.
>=20
> Drivers for such sensors should be able to learn the
> appropriate threshold temperatures for interrupts by querying
> the thermal framework.
>=20
> This change provides a mechanism to allow a sensor driver to
> update it's thresholds when userspace changes a trip point
> temperature.
>=20
> While this behavior may not make sense in thermal zones
> with more than one sensor, no such examples exist in
> the kernel.
>=20
> Signed-off-by: navneet kumar <navneetk@nvidia.com>
> ---
>  drivers/thermal/of-thermal.c | 7 +++++++
>  include/linux/thermal.h      | 1 +
>  2 files changed, 8 insertions(+)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 3d47a0cf3825..3568e4a586dc 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -258,6 +258,9 @@ static int of_thermal_set_trip_temp(struct thermal_zo=
ne_device *tz, int trip,
>  	/* thermal framework should take care of data->mask & (1 << trip) */
>  	data->trips[trip].temperature =3D temp;
> =20
> +	if (data->sops.trip_update)
> +		data->sops.trip_update(data->sensor_data, trip);
> +
>  	return 0;
>  }
> =20
> @@ -285,6 +288,9 @@ static int of_thermal_set_trip_hyst(struct thermal_zo=
ne_device *tz, int trip,
>  	/* thermal framework should take care of data->mask & (1 << trip) */
>  	data->trips[trip].hysteresis =3D hyst;
> =20
> +	if (data->sops.trip_update)
> +		data->sops.trip_update(data->sensor_data, trip);
> +
>  	return 0;
>  }
> =20
> @@ -500,6 +506,7 @@ void thermal_zone_of_sensor_unregister(struct device =
*dev,
> =20
>  	tz->sops.get_temp =3D NULL;
>  	tz->sops.get_trend =3D NULL;
> +	tz->sops.trip_update =3D NULL;
>  	tz->sensor_data =3D NULL;
>  	mutex_unlock(&tzd->lock);
>  }
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 58341c56a01f..b93e65815175 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -292,6 +292,7 @@ struct thermal_genl_event {
>  struct thermal_of_sensor_ops {
>  	int (*get_temp)(void *, long *);
>  	int (*get_trend)(void *, long *);
> +	int (*trip_update)(void *, int);

First thing I ask you is to update your work on top of my -linus branch,
as I already mentioned. Reasoning is that part of the changes you are
sending is already there.

As for this new callback, I am fine with it as long as it is also
available for drivers that do not use of-thermal. Once again, of-thermal
is not a competitor of thermal core. It will never be. It is not a new
thermal API.=20

That said, it does not make sense to have functionality in of-thermal that
do not belong to thermal core. Exceptions are, of course, for helping
doing the same operations we already have in thermal core.

All the best,

Eduardo Valentin

>  };
> =20
>  /* Function declarations */
> --=20
> 1.8.1.5
>=20

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdzX7AAoJEMLUO4d9pOJWV7EH/R8AN+eWm7eAAaUsXoLK7UdQ
K4pHHRsLwiNXPyKliZSVdBi+5uGTf/I+SPevGuX8S9mRFt/9JxF8mQb6MDyLWCay
Bqu2RaZ9Nd4NWZizpq9i0Hc2Qvj2E/kxFjJbGEM7M/P5a5XJrENIQmBqO6vLUP61
/Ih5B+7nJkI5ILg4NLy96gja1rWGvkvaotT+gnEdSNYdCKtztvCP0Q2e+6CkU8Sx
v9OoXFhvs2wat159zlO38XqwR/gSpaJpPsUdJzsc+2hIDXCyJPcVb7TYLfsRfW4K
0Bmm6oVMujKEBRVUoGNO296lxqDIZef8YdBqKM6BSpap+As1kRwI3bE1jkKCQVU=
=RcWp
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
