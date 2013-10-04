Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3JDSWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:22:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33901 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3JDSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:22:40 -0400
Message-ID: <524F0766.8070302@ti.com>
Date: Fri, 4 Oct 2013 14:22:30 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
References: <3702969.8rn3SOscJE@amdc1032>
In-Reply-To: <3702969.8rn3SOscJE@amdc1032>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="wpRHVa2hcSu3f8F2w2Vf873Gma7713oUT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wpRHVa2hcSu3f8F2w2Vf873Gma7713oUT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> Menu for Texas Instruments thermal support is visible on all
> platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> config option is selected by SoCs config options to fulfill
> EXYNOS_THERMAL config option dependency). Thus the code which
> is never used can be build. Fix it by making TI menu dependent
> on ARCH_OMAP2PLUS config option.
>=20
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 57e06a9..a709c63 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
>  	  notification methods.
> =20
>  menu "Texas Instruments thermal drivers"
> +depends on ARCH_OMAP2PLUS

No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
option to offer thermal control. So, the HW supported is TI bandgap IP,
not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
(different) version of this device.

However, DRA7 devices, for instance, also feature the bandgap IP
(different version of those present in OMAP devices), and it is not
ARCH_OMAP2PLUS.

And because of that, the design of this driver is different. It is not
expected to depend on an arch, but the arch code is expected to select
ARCH_HAS_BANDGAP.

>  source "drivers/thermal/ti-soc-thermal/Kconfig"
>  endmenu
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--wpRHVa2hcSu3f8F2w2Vf873Gma7713oUT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJPB2YACgkQCXcVR3XQvP2HgAEAh11LnU+2LxXX5zWuPJ7VyG+2
2PTk4/v/bJr9XsBxH28A/RvNPgsAH7UlZ2nZW/76KUZES9YGFJTFYKRBxhTYnsPC
=XcLl
-----END PGP SIGNATURE-----

--wpRHVa2hcSu3f8F2w2Vf873Gma7713oUT--
