Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaKYU1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:27:41 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:51599 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaKYU1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:27:37 -0500
Date: Tue, 25 Nov 2014 04:25:26 -0400
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
Subject: Re: [PATCH v2 2/4] thermal: of: Extend of-thermal.c to provide check
 if trip point is enabled
Message-ID: <20141125082524.GA13924@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-3-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <1416500488-7232-3-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Lukasz,

Same stuff here.

On Thu, Nov 20, 2014 at 05:21:26PM +0100, Lukasz Majewski wrote:
> This patch extends the of-thermal.c to provide check if trip point is
> enabled.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v2:
> - Replace int with bool
> - Replace 1/0 with true/false
> - Add check if data pointer is not NULL
> - Add missing doxygen style comment for the function
> ---
>  drivers/thermal/of-thermal.c   | 20 ++++++++++++++++++++
>  drivers/thermal/thermal_core.h |  5 +++++
>  2 files changed, 25 insertions(+)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 7170822..336af7f 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -132,6 +132,26 @@ int of_thermal_get_ntrips(struct thermal_zone_device=
 *tz)
>  	return data->ntrips;
>  }
> =20
> +/**
> + * of_thermal_is_trip_en - function to check if trip point is enabled
> + *
> + * @tz:	pointer to a thermal zone
> + * @trip:	trip point to evaluate
> + *
> + * This function is responsible for checking if passed trip point is ena=
bled
> + *
> + * Return: true if trip point is enabled, false otherwise
> + */
> +bool of_thermal_is_trip_en(struct thermal_zone_device *tz, int trip)

This one looks more like "is this trip point valid?" than "is this trip
point enabled?", isn't it?

By having such a function to check if a trip is enabled, one would
expect to have functions to enable / disable trips points.

What do you think of naming it:
of_thermal_is_trip_valid()
?

> +{
> +	struct __thermal_zone *data =3D tz->devdata;
> +
> +	if (!data || trip >=3D data->ntrips || trip < 0)

Even your check is about looking if the trip value is within a range,
telling the caller if the trip is valid or not, right?

> +		return false;
> +
> +	return true;
> +}
> +

Missing:
EXPORT_SYMBOL_GPL(of_thermal_is_trip_en);

or

EXPORT_SYMBOL_GPL(of_thermal_is_trip_valid);

>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>  				enum thermal_trend *trend)
>  {
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_cor=
e.h
> index c3c7b82..466208c 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -90,6 +90,7 @@ static inline void thermal_gov_user_space_unregister(vo=
id) {}
>  int of_parse_thermal_zones(void);
>  void of_thermal_destroy_zones(void);
>  int of_thermal_get_ntrips(struct thermal_zone_device *);
> +bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
>  #else
>  static inline int of_parse_thermal_zones(void) { return 0; }
>  static inline void of_thermal_destroy_zones(void) { }
> @@ -97,6 +98,10 @@ static inline int of_thermal_get_ntrips(struct thermal=
_zone_device *)
>  {
>  	return 0;
>  }
> +static inline bool of_thermal_is_trip_en(struct thermal_zone_device *, i=
nt)

Same as in patch 01, this produces compilation error. Please, name your
parameters.

> +{
> +	return 0;
> +}
>  #endif
> =20
>  #endif /* __THERMAL_CORE_H__ */
> --=20
> 2.0.0.rc2
>=20

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdDzoAAoJEMLUO4d9pOJW9XMIAJMR5IDoWHWkd41TW8BmEeyf
QipUFbwkQ7g1vYBKEFmfkGfq8aOAoTlTsvSb1rHMs3TDXHv/TZGzn4rmXkk6JnrQ
Le/L5ccT0IgnaXP62NzRp+D1qRnzeGd6mK5RdSv21q+ZCbSPlVOMpgX0hanLl4D4
00vBuW7Fo1FSV485PpMkEoEByz9ClcKwDN6BOYKSJzdytJvQCCRoBoTsR2fUD48H
6DoUjCyN66g4TOIZsvwm01EC77p+bD7h3JV++1buh05tp8CHiH0hVzeVvgAWHBR7
923JgRdJ8XfiLJ95TNknSlrlAO6yHxwGgjYnE696a4+xzxPhderqaGirN6V/Tg4=
=a3ci
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
