Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3JDSZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:25:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36145 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3JDSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:25:20 -0400
Message-ID: <524F0802.3070004@ti.com>
Date: Fri, 4 Oct 2013 14:25:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] thermal: TI: always register sensor driver with core
 thermal framework
References: <1466554.jrelSVKzU4@amdc1032>
In-Reply-To: <1466554.jrelSVKzU4@amdc1032>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="uUGdUw0thefHoBlwvGHnIaeI6VT6btH8O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uUGdUw0thefHoBlwvGHnIaeI6VT6btH8O
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04-10-2013 08:40, Bartlomiej Zolnierkiewicz wrote:
> There is little sense in having separate config option for
> registering the sensor driver with the core thermal framework.
> Fix it by integrating TI_THERMAL config option with TI_SOC_THERMAL
> one.

I am a bit confused of what is exactly wrong or needs fixing. The code
organization is so that the file ti-bandgap.c adds the support for TI
Bandgap IP. It is not aware of thermal framework. And the
ti-thermal-common.c file is expected to talk to thermal framework. Can
you please elaborate a bit more why this split is hurting you?

>=20
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/ti-soc-thermal/Kconfig      | 15 +++-----------
>  drivers/thermal/ti-soc-thermal/Makefile     |  2 +-
>  drivers/thermal/ti-soc-thermal/ti-thermal.h | 31 ---------------------=
--------
>  3 files changed, 4 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/t=
i-soc-thermal/Kconfig
> index bf5d6e4..c64e78b 100644
> --- a/drivers/thermal/ti-soc-thermal/Kconfig
> +++ b/drivers/thermal/ti-soc-thermal/Kconfig
> @@ -7,18 +7,9 @@ config TI_SOC_THERMAL
>  	  OMAP4460+ on die bandgap temperature sensor support. The register
>  	  set is part of system control module.
> =20
> -	  This includes alert interrupts generation and also the TSHUT
> -	  support.
> -
> -config TI_THERMAL
> -	bool "Texas Instruments SoCs thermal framework support"
> -	depends on TI_SOC_THERMAL
> -	help
> -	  If you say yes here you want to get support for generic thermal
> -	  framework for the Texas Instruments on die bandgap temperature sens=
or.
> -
> -	  This includes trip points definitions, extrapolation rules and
> -	  CPU cooling device bindings.
> +	  This includes alert interrupts generation, the TSHUT support,
> +	  trip points definitions, extrapolation rules and CPU cooling
> +	  device bindings.
> =20
>  config OMAP4_THERMAL
>  	bool "Texas Instruments OMAP4 thermal support"
> diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/=
ti-soc-thermal/Makefile
> index 1226b24..c75cc91 100644
> --- a/drivers/thermal/ti-soc-thermal/Makefile
> +++ b/drivers/thermal/ti-soc-thermal/Makefile
> @@ -1,6 +1,6 @@
>  obj-$(CONFIG_TI_SOC_THERMAL)		+=3D ti-soc-thermal.o
>  ti-soc-thermal-y			:=3D ti-bandgap.o
> -ti-soc-thermal-$(CONFIG_TI_THERMAL)	+=3D ti-thermal-common.o
> +ti-soc-thermal-y			+=3D ti-thermal-common.o
>  ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+=3D dra752-thermal-data.o
>  ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+=3D omap4-thermal-data.o
>  ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+=3D omap5-thermal-data.o
> diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal.h b/drivers/ther=
mal/ti-soc-thermal/ti-thermal.h
> index f8b7ffe..5fb427c 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-thermal.h
> +++ b/drivers/thermal/ti-soc-thermal/ti-thermal.h
> @@ -83,41 +83,10 @@
>  #define ti_thermal_is_valid_trip(trip)				\
>  	((trip) >=3D 0 && (trip) < OMAP_TRIP_NUMBER)
> =20
> -#ifdef CONFIG_TI_THERMAL
>  int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *dom=
ain);
>  int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id);
>  int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int i=
d);
>  int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id);
>  int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id);=

> -#else
> -static inline
> -int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *dom=
ain)
> -{
> -	return 0;
> -}
> =20
> -static inline
> -int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
> -{
> -	return 0;
> -}
> -
> -static inline
> -int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int i=
d)
> -{
> -	return 0;
> -}
> -
> -static inline
> -int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
> -{
> -	return 0;
> -}
> -
> -static inline
> -int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
> -{
> -	return 0;
> -}
> -#endif
>  #endif
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--uUGdUw0thefHoBlwvGHnIaeI6VT6btH8O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJPCAIACgkQCXcVR3XQvP0yOgD6AsDAkvicOev4No0cMZg2IKNe
GpB9dN8jy3WS2x2/1GgBAKFkRUX6xeP5WsgMIdC6rdJuwkyD1KDyqIl+ZSSfEI2P
=hewo
-----END PGP SIGNATURE-----

--uUGdUw0thefHoBlwvGHnIaeI6VT6btH8O--
