Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaKGTLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:11:42 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:53159 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaKGTLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:11:40 -0500
Date: Fri, 7 Nov 2014 15:11:29 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v4] Thermal: int3406_thermal: solve the dependency build
 error
Message-ID: <20141107191127.GB27438@developer>
References: <CA+r1ZhhoskOXaRSmcrnbdgapi-FsaKf+dnPHTXGkDvkYbvwQ8Q@mail.gmail.com>
 <543F88BE.4090307@intel.com>
 <20141017070620.GA1538@aaronlu.sh.intel.com>
 <20141017072236.GA12504@aaronlu.sh.intel.com>
 <544F33AF.1000704@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <544F33AF.1000704@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 02:11:59PM +0800, Aaron Lu wrote:
> Jim found that the current kernel may trigger a build error with some
> config: drivers/built-in.o: In function `int3406_thermal_probe':
> int3406_thermal.c:(.text+0x1d10b8): undefined reference to
> `acpi_video_get_levels'. The problem happens when CONFIG_THERMAL=3Dy and
> CONFIG_ACPI_VIDEO=3Dm. Solve the problem by separating a kernel config for
> int3406 thermal driver and add dependency on ACPI video for it.
>=20
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Rui,

Any further comments on this change?

BR,

Eduardo Valentin

> ---
> v4: rebased on v3.18-rc2.
>=20
>  drivers/thermal/Kconfig                  | 26 +++-----------------
>  drivers/thermal/int340x_thermal/Kconfig  | 41 ++++++++++++++++++++++++++=
++++++
>  drivers/thermal/int340x_thermal/Makefile |  1 +
>  3 files changed, 45 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/thermal/int340x_thermal/Kconfig
>=20
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index f554d25b4399..ac391d8d76b4 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -229,29 +229,9 @@ config INTEL_SOC_DTS_THERMAL
>  	  notification methods.The other trip is a critical trip point, which
>  	  was set by the driver based on the TJ MAX temperature.
> =20
> -config INT340X_THERMAL
> -	tristate "ACPI INT340X thermal drivers"
> -	depends on X86 && ACPI
> -	select THERMAL_GOV_USER_SPACE
> -	select ACPI_THERMAL_REL
> -	select ACPI_FAN
> -	help
> -	  Newer laptops and tablets that use ACPI may have thermal sensors and
> -	  other devices with thermal control capabilities outside the core
> -	  CPU/SOC, for thermal safety reasons.
> -	  They are exposed for the OS to use via the INT3400 ACPI device object
> -	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
> -	  Enable this to expose the temperature information and cooling ability
> -	  from these objects to userspace via the normal thermal framework.
> -	  This means that a wide range of applications and GUI widgets can show
> -	  the information to the user or use this information for making
> -	  decisions. For example, the Intel Thermal Daemon can use this
> -	  information to allow the user to select his laptop to run without
> -	  turning on the fans.
> -
> -config ACPI_THERMAL_REL
> -	tristate
> -	depends on ACPI
> +menu "ACPI INT340X thermal drivers"
> +source drivers/thermal/int340x_thermal/Kconfig
> +endmenu
> =20
>  menu "Texas Instruments thermal drivers"
>  source "drivers/thermal/ti-soc-thermal/Kconfig"
> diff --git a/drivers/thermal/int340x_thermal/Kconfig b/drivers/thermal/in=
t340x_thermal/Kconfig
> new file mode 100644
> index 000000000000..b92892a6afe0
> --- /dev/null
> +++ b/drivers/thermal/int340x_thermal/Kconfig
> @@ -0,0 +1,41 @@
> +#
> +# ACPI INT340x thermal drivers configuration
> +#
> +
> +config INT340X_THERMAL
> +	tristate "ACPI INT340X thermal drivers"
> +	depends on X86 && ACPI
> +	select THERMAL_GOV_USER_SPACE
> +	select ACPI_THERMAL_REL
> +	select ACPI_FAN
> +	help
> +	  Newer laptops and tablets that use ACPI may have thermal sensors and
> +	  other devices with thermal control capabilities outside the core
> +	  CPU/SOC, for thermal safety reasons.
> +	  They are exposed for the OS to use via the INT3400 ACPI device object
> +	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
> +	  Enable this to expose the temperature information and cooling ability
> +	  from these objects to userspace via the normal thermal framework.
> +	  This means that a wide range of applications and GUI widgets can show
> +	  the information to the user or use this information for making
> +	  decisions. For example, the Intel Thermal Daemon can use this
> +	  information to allow the user to select his laptop to run without
> +	  turning on the fans.
> +
> +if INT340X_THERMAL
> +
> +config ACPI_THERMAL_REL
> +	tristate
> +	depends on ACPI
> +
> +config INT3406_THERMAL
> +	tristate "ACPI INT3406 display thermal driver"
> +	depends on ACPI_VIDEO
> +	help
> +	  The display thermal device represents the LED/LCD display panel
> +	  that may or may not include touch support. The main function of
> +	  the display thermal device is to allow control of the display
> +	  brightness in order to address a thermal condition or to reduce
> +	  power consumed by display device.
> +
> +endif
> diff --git a/drivers/thermal/int340x_thermal/Makefile b/drivers/thermal/i=
nt340x_thermal/Makefile
> index ffe40bffaf1a..a9d0429be412 100644
> --- a/drivers/thermal/int340x_thermal/Makefile
> +++ b/drivers/thermal/int340x_thermal/Makefile
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_INT340X_THERMAL)	+=3D int3400_thermal.o
>  obj-$(CONFIG_INT340X_THERMAL)	+=3D int3402_thermal.o
>  obj-$(CONFIG_INT340X_THERMAL)	+=3D int3403_thermal.o
> +obj-$(CONFIG_INT3406_THERMAL)	+=3D int3406_thermal.o
>  obj-$(CONFIG_ACPI_THERMAL_REL)	+=3D acpi_thermal_rel.o
> --=20
> 1.9.3
>=20

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXRlOAAoJEMLUO4d9pOJWvgkIAJpg5ozozIPal1HsS+IOqlmq
Q7QQzbQLwWkvvr1oDkBuGNXiqhCT0fAovGwYE0BmRDAip4AKiOE+GVoqlNr//YzD
5116NF4V5Iq+id0gh8ttgVG6pXOYHGIsOiIlLk+le4JGZE7I5hNbViLatV7twE7y
QBT/P/lacD8zLOw2l6PWQU5Sb+9DKdXZQp5cDIVajgYn/jg1OuX7Rwvro9Uqd1om
oLqsTev2NyXm6dRIojmnYTF5SIKiOiV8k/30SsRFq4VQ3hBX7GlIZcMAnZ1zUyWn
3DIA30BLqhe8UvmBKFXPV/eVd6PbaXyvlqWi5mge8GvrRGnHx45d+4GsfOi1O2M=
=H+rT
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
