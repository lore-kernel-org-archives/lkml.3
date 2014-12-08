Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaLHUBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:01:30 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35628 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLHUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:01:28 -0500
Date: Mon, 8 Dec 2014 15:52:49 -0400
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
        Caesar Wang <caesar.wang@rock-chips.com>,
        navneet kumar <navneetk@nvidia.com>
Subject: Re: [PATCH v3 1/5] thermal: of: Extend of-thermal.c to provide
 number of trip points
Message-ID: <20141208195247.GA31126@developer>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-2-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1418058261-25251-2-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 06:04:17PM +0100, Lukasz Majewski wrote:
> This patch extends the of-thermal.c to provide information about number of
> available trip points.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v3:
> - Exporting of_thermal_get_ntrips symbol as a GPL
> - Fix build error when CONFIG_THERMAL_OF is disabled
>=20
> Changes for v2:
> - Provide detailed (doxygen like) description of the of_thermal_get_ntrip=
s()
>   method
> - Check for data pointer not being NULL
> ---
>  drivers/thermal/of-thermal.c   | 21 +++++++++++++++++++++
>  drivers/thermal/thermal_core.h |  5 +++++
>  2 files changed, 26 insertions(+)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index b7982f0..7facd23 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -112,6 +112,27 @@ static int of_thermal_get_temp(struct thermal_zone_d=
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
> +EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);
> +
>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>  				enum thermal_trend *trend)
>  {
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_cor=
e.h
> index d15d243..1cc5041 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -89,9 +89,14 @@ static inline void thermal_gov_user_space_unregister(v=
oid) {}
>  #ifdef CONFIG_THERMAL_OF
>  int of_parse_thermal_zones(void);
>  void of_thermal_destroy_zones(void);
> +int of_thermal_get_ntrips(struct thermal_zone_device *);

Lukasz,

Here is a question that applies to all patches in this series adding
functions in this header.

i suppose you intend to use these new functions in driver code, right?
Add them here, will limit their usage to code inside drivers/thermal.

Shouldn't these new APIs be declared under include/linux/thermal.h?

This way, they can be be available to other parts of the kernel too.


>  #else
>  static inline int of_parse_thermal_zones(void) { return 0; }
>  static inline void of_thermal_destroy_zones(void) { }
> +static inline int of_thermal_get_ntrips(struct thermal_zone_device *tz)
> +{
> +	return 0;
> +}
>  #endif
> =20
>  #endif /* __THERMAL_CORE_H__ */
> --=20
> 2.0.0.rc2
>=20

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhgGGAAoJEMLUO4d9pOJW5CoIAJkLstXbYH8fH5b3xUQQAgXu
hguT0+WkWh8nsOAsbPWVeBbCj/TJ1IZqAOzs2CmGY5DJVZCINgAdxIwRzAzx3i8r
GsL8xKtBSdiphSEKKTdAOWEzOgsRE1YxU/WD+DV2/llFppx/N5my6ne1dpo50bCH
G1+vbTPJZgItOX3QhpjPHrGGDxXONiAuGS0t9rfp9zzgo6LekDuHut0CvYNinaK0
WXXyJVQt5T1O3FZquyCk3P+blZabaNDxPVi8HcOTbEGDHZcAHgHG4jC/UM37WIal
zuhHIEpDnLbBLjcVFSrkKLNswS3Z2SMfAe3T45pArnsFHQSQEXRwgsar67tPd5I=
=K0K/
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
