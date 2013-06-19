Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137Ab3FSTTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:19:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49590 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935074Ab3FSTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:18:58 -0400
Message-ID: <51C20416.7010809@ti.com>
Date: Wed, 19 Jun 2013 15:18:46 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 06/30] thermal: exynos: Move exynos_thermal.h from
 include/* to driver/* folder
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-7-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-7-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2NFCPENAIWDNWGNQRAIKN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NFCPENAIWDNWGNQRAIKN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch renames and moves include/linux/platform_data/exynos_thermal=
=2Eh to
> drivers/thermal/samsung/exynos_tmu.h. This file movement is needed as e=
xynos
> SOC's are not supporting non-DT based platforms and this file now just =
contains
> exynos tmu driver related definations.
> Also struct freq_clip_table is now moved to exynos_thermal_common.c as =
it fixes
> the compilation issue occuring because now this new tmu header file is =
included
> in tmu driver c file and not in the common thermal header file.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c    |    1 -
>  drivers/thermal/samsung/exynos_thermal_common.h    |   15 ++++++++++++=

>  drivers/thermal/samsung/exynos_tmu.c               |    2 +-
>  .../thermal/samsung/exynos_tmu.h                   |   24 ++++--------=
-------
>  4 files changed, 21 insertions(+), 21 deletions(-)
>  rename include/linux/platform_data/exynos_thermal.h =3D> drivers/therm=
al/samsung/exynos_tmu.h (84%)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index 92e50bc..dd49c9f 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -21,7 +21,6 @@
>   */
> =20
>  #include <linux/cpu_cooling.h>
> -#include <linux/platform_data/exynos_thermal.h>
>  #include <linux/slab.h>
>  #include <linux/thermal.h>
> =20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> index 8df1848..068f56c 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -44,6 +44,21 @@
> =20
>  #define EXYNOS_ZONE_COUNT	3
> =20
> +/**
> + * struct freq_clip_table
> + * @freq_clip_max: maximum frequency allowed for this cooling state.
> + * @temp_level: Temperature level at which the temperature clipping wi=
ll
> + *	happen.
> + * @mask_val: cpumask of the allowed cpu's where the clipping will tak=
e place.
> + *
> + * This structure is required to be filled and passed to the
> + * cpufreq_cooling_unregister function.
> + */
> +struct freq_clip_table {
> +	unsigned int freq_clip_max;
> +	unsigned int temp_level;
> +	const struct cpumask *mask_val;
> +};
>  struct	thermal_trip_point_conf {
>  	int trip_val[MAX_TRIP_COUNT];
>  	int trip_count;
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 22a8874..6aa2fd2 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -27,9 +27,9 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> -#include <linux/platform_data/exynos_thermal.h>
> =20
>  #include "exynos_thermal_common.h"
> +#include "exynos_tmu.h"
> =20
>  /* Exynos generic registers */
>  #define EXYNOS_TMU_REG_TRIMINFO		0x0
> diff --git a/include/linux/platform_data/exynos_thermal.h b/drivers/the=
rmal/samsung/exynos_tmu.h
> similarity index 84%
> rename from include/linux/platform_data/exynos_thermal.h
> rename to drivers/thermal/samsung/exynos_tmu.h
> index da7e627..9e0f887 100644
> --- a/include/linux/platform_data/exynos_thermal.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -1,8 +1,9 @@
>  /*
> - * exynos_thermal.h - Samsung EXYNOS TMU (Thermal Management Unit)
> + * exynos_tmu.h - Samsung EXYNOS TMU (Thermal Management Unit)
>   *
>   *  Copyright (C) 2011 Samsung Electronics
>   *  Donggeun Kim <dg77.kim@samsung.com>
> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
>   *
>   * This program is free software; you can redistribute it and/or modif=
y
>   * it under the terms of the GNU General Public License as published b=
y
> @@ -19,8 +20,8 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
>   */
> =20
> -#ifndef _LINUX_EXYNOS_THERMAL_H
> -#define _LINUX_EXYNOS_THERMAL_H
> +#ifndef _EXYNOS_TMU_H
> +#define _EXYNOS_TMU_H
>  #include <linux/cpu_cooling.h>
> =20
>  enum calibration_type {
> @@ -33,21 +34,6 @@ enum soc_type {
>  	SOC_ARCH_EXYNOS4210 =3D 1,
>  	SOC_ARCH_EXYNOS,
>  };
> -/**
> - * struct freq_clip_table
> - * @freq_clip_max: maximum frequency allowed for this cooling state.
> - * @temp_level: Temperature level at which the temperature clipping wi=
ll
> - *	happen.
> - * @mask_val: cpumask of the allowed cpu's where the clipping will tak=
e place.
> - *
> - * This structure is required to be filled and passed to the
> - * cpufreq_cooling_unregister function.
> - */
> -struct freq_clip_table {
> -	unsigned int freq_clip_max;
> -	unsigned int temp_level;
> -	const struct cpumask *mask_val;
> -};
> =20
>  /**
>   * struct exynos_tmu_platform_data
> @@ -116,4 +102,4 @@ struct exynos_tmu_platform_data {
>  	struct freq_clip_table freq_tab[4];

Because you have this struct right here, you need still to have:
+#include "exynos_thermal_common.h"

in your include list of exynos_tmu.h (this file).

A part from this minor issue, you can add my acked:

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

>  	unsigned int freq_tab_count;
>  };
> -#endif /* _LINUX_EXYNOS_THERMAL_H */
> +#endif /* _EXYNOS_TMU_H */
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2NFCPENAIWDNWGNQRAIKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCBBYACgkQCXcVR3XQvP2GLQD9FQzyW+y6rALLVZwjldKtaW6Z
SqEmUYhiLbKJFEE3ZMMA/16+fevKHKjT8SixR4+/lmkfPPnDs9uqhAs124wI3STD
=2rOe
-----END PGP SIGNATURE-----

------enig2NFCPENAIWDNWGNQRAIKN--
