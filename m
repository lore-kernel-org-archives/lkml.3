Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab3FSSqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:46:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38646 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841Ab3FSSqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:46:45 -0400
Message-ID: <51C1FC8A.9000602@ti.com>
Date: Wed, 19 Jun 2013 14:46:34 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 01/30] thermal: exynos: Moving exynos thermal files
 into samsung directory
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-2-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-2-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2QJOQDHRSMHKSTCLMVAES"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2QJOQDHRSMHKSTCLMVAES
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This movement of files is done for easy maintenance and adding more
> new sensor's support for exynos platform easily . This will also help i=
n
> bifurcating exynos common, sensor driver and sensor data related parts.=

>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

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
> index b13c2bc..ef10cf2 100644
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
> @@ -185,4 +177,9 @@ menu "Texas Instruments thermal drivers"
>  source "drivers/thermal/ti-soc-thermal/Kconfig"
>  endmenu
> =20
> +menu "Samsung thermal drivers"
> +depends on PLAT_SAMSUNG
> +source "drivers/thermal/samsung/Kconfig"
> +endmenu
> +
>  endif
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 67184a2..1f27ada 100644
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


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2QJOQDHRSMHKSTCLMVAES
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHB/IoACgkQCXcVR3XQvP0V0wD/V7WtMmmizxUm1KwS7HEu3Lro
mfLVbCN6as6f6XB3cH8A/i7cwcf3MNEieE22dAlcfH9ccfZRDx1fIH43PWQhN+cO
=wJTx
-----END PGP SIGNATURE-----

------enig2QJOQDHRSMHKSTCLMVAES--
