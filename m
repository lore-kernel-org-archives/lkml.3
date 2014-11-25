Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbaKYSGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:06:37 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39276 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKYSGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:06:35 -0500
Date: Tue, 25 Nov 2014 02:04:24 -0400
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
Subject: Re: [PATCH v2 1/4] thermal: of: Extend of-thermal.c to provide
 number of trip points
Message-ID: <20141125060421.GA13591@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-2-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1416500488-7232-2-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Lukasz,

On Thu, Nov 20, 2014 at 05:21:25PM +0100, Lukasz Majewski wrote:
> This patch extends the of-thermal.c to provide information about number of
> available trip points.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v2:
> - Provide detailed (doxygen like) description of the of_thermal_get_ntrip=
s()
>   method
> - Check for data pointer not being NULL
> ---
>  drivers/thermal/of-thermal.c   | 20 ++++++++++++++++++++
>  drivers/thermal/thermal_core.h |  5 +++++
>  2 files changed, 25 insertions(+)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index b7982f0..7170822 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -112,6 +112,26 @@ static int of_thermal_get_temp(struct thermal_zone_d=
evice *tz,
>  	return data->ops->get_temp(data->sensor_data, temp);
>  }
> =20
> +/**
> + * of_thermal_get_ntrips - function to export number of available trip
> + *			   points.
> + * @tz: pointer to a thermal zone
> + *
> + * This function is a globally visible wrapper to get number of trip poi=
nts
> + * stored in the local struct __thermal_zone
> + *
> + * Return: number of available trip points, -ENODEV when data not availa=
ble
> + */
> +int of_thermal_get_ntrips(struct thermal_zone_device *tz)
> +{
> +	struct __thermal_zone *data =3D tz->devdata;
> +
> +	if (!data || IS_ERR(data))
> +		return -ENODEV;
> +
> +	return data->ntrips;
> +}
> +

Missing
EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);

>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>  				enum thermal_trend *trend)
>  {
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_cor=
e.h
> index d15d243..c3c7b82 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -89,9 +89,14 @@ static inline void thermal_gov_user_space_unregister(v=
oid) {}
>  #ifdef CONFIG_THERMAL_OF
>  int of_parse_thermal_zones(void);
>  void of_thermal_destroy_zones(void);
> +int of_thermal_get_ntrips(struct thermal_zone_device *);
>  #else
>  static inline int of_parse_thermal_zones(void) { return 0; }
>  static inline void of_thermal_destroy_zones(void) { }
> +static inline int of_thermal_get_ntrips(struct thermal_zone_device *)

You need to declare the parameter name with a name     ---------------^ .

> +{

This produces a compilation error if CONFIG_THERMAL_OF is not set:
In file included from drivers/thermal/step_wise.c:28:0:
drivers/thermal/thermal_core.h: In function =E2=80=98of_thermal_get_ntrips=
=E2=80=99:
drivers/thermal/thermal_core.h:96:48: error: parameter name omitted
 static inline int of_thermal_get_ntrips(struct thermal_zone_device *)



> +	return 0;
> +}
>  #endif
> =20
>  #endif /* __THERMAL_CORE_H__ */
> --=20
> 2.0.0.rc2
>=20

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdBvcAAoJEMLUO4d9pOJW9BIH/2NrYX38n81OyIAzAlQNsSvD
U2kR7/NqI0LqL/NdMRPSxeeFo2IzvYLas3SQA8mgKKzmI8YS+sCudbx2cfCqcjws
l2jg4yM++q7Cl9OLXC2x7Fps6hGnrE/yCCfZiX3mpBNdTlAwPPO7CB3PunxaS95c
T3/B/8PZ5uOtONteXg9KFGU95C1I4ZIUoo0RiXjdqh34RwDj5Ek0zkFvHJvGa6LJ
OAEKGnkIrZepWr9bZdTBwsocSbbFQdrBYOLmmTUTPVygZj88KsHOZngs80h8eGMw
7GxwGjjlBpbIhhBg0uDRoMUTRj/heZjg6y7VasukU2v1CIfUytXZ5RSfJSYaa3c=
=IbSP
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
