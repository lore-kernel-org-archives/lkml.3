Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587Ab3FTCcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:32:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42357 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab3FTCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:32:18 -0400
Message-ID: <51C269A7.1070709@ti.com>
Date: Wed, 19 Jun 2013 22:32:07 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 27/30] Documentation: thermal: Explain the exynos thermal
 driver model
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-28-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-28-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2VMWMSUTFBEPSTWDCQGLB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2VMWMSUTFBEPSTWDCQGLB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch updates the documentation to explain the driver model
> and file layout.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  Documentation/thermal/exynos_thermal |   43 ++++++++++++++++++++++++++=
-------
>  1 files changed, 34 insertions(+), 9 deletions(-)
>=20
> diff --git a/Documentation/thermal/exynos_thermal b/Documentation/therm=
al/exynos_thermal
> index 2b46f67..9010c44 100644
> --- a/Documentation/thermal/exynos_thermal
> +++ b/Documentation/thermal/exynos_thermal
> @@ -1,17 +1,17 @@
> -Kernel driver exynos4_tmu
> +Kernel driver exynos_tmu
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  Supported chips:
> -* ARM SAMSUNG EXYNOS4 series of SoC
> -  Prefix: 'exynos4-tmu'
> +* ARM SAMSUNG EXYNOS4, EXYNOS5 series of SoC
>    Datasheet: Not publicly available
> =20
>  Authors: Donggeun Kim <dg77.kim@samsung.com>
> +Authors: Amit Daniel <amit.daniel@samsung.com>
> =20
> -Description
> ------------
> +TMU controller Description:
> +---------------------------
> =20
> -This driver allows to read temperature inside SAMSUNG EXYNOS4 series o=
f SoC.
> +This driver allows to read temperature inside SAMSUNG EXYNOS4/5 series=
 of SoC.
> =20
>  The chip only exposes the measured 8-bit temperature code value
>  through a register.
> @@ -34,9 +34,9 @@ The three equations are:
>    TI2: Trimming info for 85 degree Celsius (stored at TRIMINFO registe=
r)
>         Temperature code measured at 85 degree Celsius which is unchang=
ed
> =20
> -TMU(Thermal Management Unit) in EXYNOS4 generates interrupt
> +TMU(Thermal Management Unit) in EXYNOS4/5 generates interrupt
>  when temperature exceeds pre-defined levels.
> -The maximum number of configurable threshold is four.
> +The maximum number of configurable threshold is five.
>  The threshold levels are defined as follows:
>    Level_0: current temperature > trigger_level_0 + threshold
>    Level_1: current temperature > trigger_level_1 + threshold
> @@ -47,6 +47,31 @@ The threshold levels are defined as follows:
>    through the corresponding registers.
> =20
>  When an interrupt occurs, this driver notify kernel thermal framework
> -with the function exynos4_report_trigger.
> +with the function exynos_report_trigger.
>  Although an interrupt condition for level_0 can be set,
>  it can be used to synchronize the cooling action.
> +
> +TMU driver description:
> +-----------------------
> +
> +The exynos thermal driver is structured as,
> +
> +					Kernel Core thermal framework
> +				(thermal_core.c, step_wise.c, cpu_cooling.c)
> +								^
> +								|
> +								|
> +TMU configuration data -------> TMU Driver  <------> Exynos Core therm=
al wrapper
> +(exynos_tmu_data.c)	      (exynos_tmu.c)	   (exynos_thermal_common.c)
> +(exynos_tmu_data.h)	      (exynos_tmu.h)	   (exynos_thermal_common.h)
> +
> +a) TMU configuration data: This consist of TMU register offsets/bitfie=
lds
> +		described through structure exynos_tmu_registers. Also several
> +		other platform data (struct exynos_tmu_platform_data) members
> +		are used to configure the TMU.
> +b) TMU driver: This component initialises the TMU controller and sets =
different
> +		thresholds. It invokes core thermal implementation with the call
> +		exynos_report_trigger.
> +c) Exynos Core thermal wrapper: This provides 3 wrapper function to us=
e the
> +		Kernel core thermal framework. They are exynos_unregister_thermal,
> +		exynos_register_thermal and exynos_report_trigger.
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2VMWMSUTFBEPSTWDCQGLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCaacACgkQCXcVR3XQvP0PvQEApavaH8SDJdhE02LmeOL3Vm78
C5HiVB1PexvyqHWcew8A/AoQULIbyB3YIQTFDUgkyIdkdJIuqYsCYqTigwdANHK6
=u1i8
-----END PGP SIGNATURE-----

------enig2VMWMSUTFBEPSTWDCQGLB--
