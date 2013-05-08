Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3EHPtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:49:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41739 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3EHPtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:49:49 -0400
Message-ID: <518A7410.3090605@ti.com>
Date: Wed, 8 May 2013 11:49:36 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [RESEND PATCH V3 01/21] thermal: exynos: Moving exynos thermal
 files into samsung directory
References: <1367931671-3906-2-git-send-email-amit.daniel@samsung.com> <1367932062-3974-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367932062-3974-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2XAPAEQIDJQMSFXIAWWGK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2XAPAEQIDJQMSFXIAWWGK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-05-2013 09:07, Amit Daniel Kachhap wrote:
> This movement of files is done for easy maintenance and adding more
> new sensor's support for exynos platform easily . This will also help i=
n
> bifurcating exynos common, sensor driver and sensor data related parts.=

>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/Kconfig                        |   13 +++++--------
>  drivers/thermal/Makefile                       |    2 +-
>  drivers/thermal/samsung/Kconfig                |    9 +++++++++
>  drivers/thermal/samsung/Makefile               |    4 ++++
>  drivers/thermal/{ =3D> samsung}/exynos_thermal.c |    0
>  5 files changed, 19 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/thermal/samsung/Kconfig
>  create mode 100644 drivers/thermal/samsung/Makefile
>  rename drivers/thermal/{ =3D> samsung}/exynos_thermal.c (100%)
>=20
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 5e3c025..081ddc5 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -114,14 +114,6 @@ config KIRKWOOD_THERMAL
>  	  Support for the Kirkwood thermal sensor driver into the Linux therm=
al
>  	  framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
> =20
> -config EXYNOS_THERMAL
> -	tristate "Temperature sensor on Samsung EXYNOS"
> -	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
> -	depends on CPU_THERMAL
> -	help
> -	  If you say yes here you get support for TMU (Thermal Management
> -	  Unit) on SAMSUNG EXYNOS series of SoC.
> -
>  config DOVE_THERMAL
>  	tristate "Temperature sensor on Marvell Dove SoCs"
>  	depends on ARCH_DOVE
> @@ -169,4 +161,9 @@ config INTEL_POWERCLAMP
>  	  enforce idle time which results in more package C-state residency. =
The
>  	  user interface is exposed via generic thermal framework.
> =20
> +menu "Samsung thermal drivers"
> +depends on PLAT_SAMSUNG
> +source "drivers/thermal/samsung/Kconfig"
> +endmenu
> +
>  endif
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index c054d41..b3063a9 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -17,7 +17,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+=3D cpu_cooling.o
>  obj-$(CONFIG_SPEAR_THERMAL)	+=3D spear_thermal.o
>  obj-$(CONFIG_RCAR_THERMAL)	+=3D rcar_thermal.o
>  obj-$(CONFIG_KIRKWOOD_THERMAL)  +=3D kirkwood_thermal.o
> -obj-$(CONFIG_EXYNOS_THERMAL)	+=3D exynos_thermal.o
> +obj-y				+=3D samsung/
>  obj-$(CONFIG_DOVE_THERMAL)  	+=3D dove_thermal.o
>  obj-$(CONFIG_DB8500_THERMAL)	+=3D db8500_thermal.o
>  obj-$(CONFIG_ARMADA_THERMAL)	+=3D armada_thermal.o
> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/=
Kconfig
> new file mode 100644
> index 0000000..2d3d9dc
> --- /dev/null
> +++ b/drivers/thermal/samsung/Kconfig
> @@ -0,0 +1,9 @@
> +config EXYNOS_THERMAL
> +	tristate "Temperature sensor on Samsung EXYNOS"
> +	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)

Do you really want to keep a list of Kconfig dependency here?

I was suggested to have a config entry (like ARCH_HAS_BANDBAP) and then
in the driver use:
	depends on ARCH_HAS_BANDGAP

And the arch/ code would just selects ARCH_HAS_BANDGAP (like
ARCH_HAS_CPUFREQ).

> +	depends on CPU_THERMAL
> +	help
> +	  If you say yes here you get support for TMU (Thermal Management
> +	  Unit) on SAMSUNG EXYNOS series of SoC. This helps in registering
> +	  the exynos thermal driver with the core thermal layer and cpu
> +	  cooling API's.
> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung=
/Makefile
> new file mode 100644
> index 0000000..1fe6d93
> --- /dev/null
> +++ b/drivers/thermal/samsung/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Samsung thermal specific Makefile
> +#
> +obj-$(CONFIG_EXYNOS_THERMAL)	+=3D exynos_thermal.o
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/samsung=
/exynos_thermal.c
> similarity index 100%
> rename from drivers/thermal/exynos_thermal.c
> rename to drivers/thermal/samsung/exynos_thermal.c
>=20



------enig2XAPAEQIDJQMSFXIAWWGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGKdBAACgkQCXcVR3XQvP0vxgEA/iFAjqB6otozvdK7/Aay+Q/Q
+XwNxEL1w3sdgWgyWk4A/2rTc7TUDleayct1tQSrfpXxGaScMyqxwNDl/tEq3Bdp
=vhzK
-----END PGP SIGNATURE-----

------enig2XAPAEQIDJQMSFXIAWWGK--
