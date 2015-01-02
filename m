Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbbABS4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:56:46 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:39127 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbABS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:56:43 -0500
Date: Fri, 2 Jan 2015 14:54:28 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 1/8] thermal: Provide stub for
 thermal_of_cooling_device_register() function
Message-ID: <20150102185426.GC12485@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-2-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <1419265668-32283-2-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2014 at 05:27:41PM +0100, Lukasz Majewski wrote:
> Odroid U3 fan can work without being registered as OF cooling device
> (with CONFIG_THERMAL_OF disabled).
> In this situation it can be controlled via PWM entry at
> /sys/class/hwmon/hwmon0/pwm1.
>=20
> Therefore, the thermal_of_cooling_device_register() function needs a stub
> to allow clean compilation.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>

> ---
> Changes for v2:
> - None
> ---
>  include/linux/thermal.h | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 2de3d9e..871123c 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -328,6 +328,10 @@ thermal_zone_of_sensor_register(struct device *dev, =
int id, void *data,
>  				const struct thermal_zone_of_device_ops *ops);
>  void thermal_zone_of_sensor_unregister(struct device *dev,
>  				       struct thermal_zone_device *tz);
> +struct thermal_cooling_device *
> +thermal_of_cooling_device_register(struct device_node *np,
> +				   char *type, void *devdata,
> +				   const struct thermal_cooling_device_ops *);
>  #else
>  static inline struct thermal_zone_device *
>  thermal_zone_of_sensor_register(struct device *dev, int id, void *data,
> @@ -342,6 +346,13 @@ void thermal_zone_of_sensor_unregister(struct device=
 *dev,
>  {
>  }
> =20
> +static inline struct thermal_cooling_device *
> +thermal_of_cooling_device_register(struct device_node *np,
> +				   char *type, void *devdata,
> +				   const struct thermal_cooling_device_ops *ops)
> +{
> +	return NULL;
> +}
>  #endif
>  struct thermal_zone_device *thermal_zone_device_register(const char *, i=
nt, int,
>  		void *, struct thermal_zone_device_ops *,
> @@ -357,9 +368,6 @@ void thermal_zone_device_update(struct thermal_zone_d=
evice *);
> =20
>  struct thermal_cooling_device *thermal_cooling_device_register(char *, v=
oid *,
>  		const struct thermal_cooling_device_ops *);
> -struct thermal_cooling_device *
> -thermal_of_cooling_device_register(struct device_node *np, char *, void =
*,
> -				   const struct thermal_cooling_device_ops *);
>  void thermal_cooling_device_unregister(struct thermal_cooling_device *);
>  struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *na=
me);
>  int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long =
*temp);
> --=20
> 2.0.0.rc2
>=20

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUpulbAAoJEMLUO4d9pOJWUq8H/2GaJ1MfMZPLIcSnovdK9wW+
gJmXYn02MMjZuop/2e4y/OUzrr4xoXmfhy5sRvOyVWb/S3wNnB6jGXhgRilsMof7
i0/92SBcm61HvVZE5SbvmGChTFBgZTH6g0Psyq3lLPaD3wtzgfLc1ORBjiAV3eVQ
CQZw+3BC05Jsjf8lhJcChvb5CrFHa2/gXEmdEfDobn9SDGW5Nx/9lh0pjXH55wAY
Ma51IAzSxux7+SOdn0GMyZPGmrMXBLfwUV1xiFaSHteHQ23euxLC5ED28fqJ2e3b
YjhIVRbow5dpTO9sbc+OIyW6Q3hNIwGpZUwWTumKD/GxFR2dKygJaPDFdWRylLU=
=Vwm8
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
