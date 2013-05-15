Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3EOOpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:45:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48511 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759297Ab3EOOpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:45:14 -0400
Message-ID: <51939F61.5020904@ti.com>
Date: Wed, 15 May 2013 10:44:49 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V4 00/30] thermal: exynos: Add thermal driver for exynos5440
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2NROSVTKJFEOGHNFKVTTN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NROSVTKJFEOGHNFKVTTN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14-05-2013 05:58, Amit Daniel Kachhap wrote:
> Changes in V4:
>  Almost all the changes in this version is as per suggestion from Eduar=
do.The
>  major ones are listed below,
> * Added kconfig symbol ARCH_HAS_TMU which needs to be enabled by platfo=
rm. With
>   this change existing symbol EXYNOS_TMU_DATA is not needed.

I was more thinking if we could have a single flag that we could use in
thermal drivers. Besides, my proposal for ARCH_HAS_BANDGAP is still not
merged yet.

> * Movement of freq_clip_table from exynos_tmu.h to exynos_thermal_commo=
n.h is
>   explained in the commit logs.
> * Wrote all register description documentation.
> * Split 5440 TMU support patch into controller change, configuration da=
ta and
>   feature addition patches.
> * Remove all *LINUX_* in the header files.
> * Still regulator enable is kept optional but a TODO: comment is added =
to fix
>   it later.
>=20
> Changes in V3:
> * Added proper dependency of different exynos thermal Kconfig symbols. =
Basically 3
>  Kconfig can be enabled now and corresponds to tmu driver. exynos commo=
n part
>  and exynos configuration data. This issue was raised by Rui Zhang.
>=20
> Changes in V2:
> * Separated SOC data from TMU driver. This is as per suggestion from Ed=
uardo.
> * Merged the new file created for exynos5440 TMU controller with the ex=
isting
>  TMU controller code.
> * Removed the DT parsing code as now the SOC specific data are cleanly =
put
>  inside the data specific file.
> * Even the register definations/bitfields are treated as data as there =
is
>  some variation across SOC's.
>=20
> This patchset adds TMU(Thermal management Unit) driver support for
> exynos5440 platform. There are 3 instances of the TMU controllers so
> necessary cleanup/re-structure is done to handle multiple thermal zone.=

>=20
> Patch (exynos4: Add documentation for Exynos SoC thermal bindings) from=

> Lukasz Majewski is already posted to mainline. Adding it here for compl=
eteness.
> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg17817=
=2Ehtml)
>=20
> Patch (thermal: exynos: Support thermal tripping ) from Jonghwan Choi i=
s
> added here with some changes.
> (https://patchwork.kernel.org/patch/1668371/)
>=20
> Patch (thermal: exynos: Support for TMU regulator defined at device tre=
e)
> is a repost of my earlier patch(https://patchwork-mail1.kernel.org/patc=
h/2510771/)=20
> and adds regulator support.
>=20
> Patch (ARM: dts: Add device tree node for exynos5440 TMU controller) an=
d
> patch (arm: exynos: enable ARCH_HAS_TMU) can be merged through exynos p=
latform
> maintainer as this can cause merge conflict.
>=20
> All these patches are based on thermal maintainers git tree,
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.
>=20
> Amit Daniel Kachhap (29):
>   thermal: exynos: Moving exynos thermal files into samsung directory
>   thermal: exynos: Add ARCH_HAS_TMU config to know the supported soc's
>   thermal: exynos: Remove CPU_THERMAL dependency for using TMU driver
>   thermal: exynos: Bifurcate exynos thermal common and tmu controller
>     code
>   thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
>   thermal: exynos: Move exynos_thermal.h from include/* to driver/*
>     folder
>   thermal: exynos: Bifurcate exynos tmu driver and configuration data
>   thermal: exynos: Add missing definations and code cleanup
>   thermal: exynos: Add extra entries in the tmu platform data
>   thermal: exynos: Support thermal tripping
>   thermal: exynos: Move register definitions from driver file to data
>     file
>   thermal: exynos: Fix to clear only the generated interrupts
>   thermal: exynos: Add support for instance based register/unregister
>   thermal: exynos: Modify private_data to appropriate name driver_data
>   thermal: exynos: Return success even if no cooling data supplied
>   thermal: exynos: Make the zone handling dependent on trip count
>   thermal: exynos: Add support to handle many instances of TMU
>   thermal: exynos: Add TMU features to check instead of using SOC type
>   thermal: exynos: use device resource management infrastructure
>   thermal: exynos: Add support to access common register for
>     multistance
>   thermal: exynos: Add support for exynos5440 TMU sensor.
>   thermal: exynos: Fix to set the second point correction value
>     properly
>   thermal: exynos: Add thermal configuration data for exynos5440 TMU
>     sensor
>   thermal: exynos: Add a compensation logic on swapped e-fuse values
>   thermal: exynos: Add hardware mode thermal calibration support
>   Documentation: thermal: Explain the exynos thermal driver model
>   thermal: exynos: Support for TMU regulator defined at device tree
>   ARM: dts: Add device tree node for exynos5440 TMU controller
>   arm: exynos: enable ARCH_HAS_TMU
>=20
> Lukasz Majewski (1):
>   ARM: dts: thermal: exynos4: Add documentation for Exynos SoC thermal
>     bindings
>=20
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   53 +
>  Documentation/thermal/exynos_thermal               |   43 +-
>  arch/arm/boot/dts/exynos5440.dtsi                  |   30 +
>  arch/arm/mach-exynos/Kconfig                       |    5 +
>  drivers/thermal/Kconfig                            |   13 +-
>  drivers/thermal/Makefile                           |    2 +-
>  drivers/thermal/exynos_thermal.c                   | 1066 ------------=
--------
>  drivers/thermal/samsung/Kconfig                    |   21 +
>  drivers/thermal/samsung/Makefile                   |    7 +
>  drivers/thermal/samsung/exynos_thermal_common.c    |  407 ++++++++
>  drivers/thermal/samsung/exynos_thermal_common.h    |   98 ++
>  drivers/thermal/samsung/exynos_tmu.c               |  741 ++++++++++++=
++
>  drivers/thermal/samsung/exynos_tmu.h               |  294 ++++++
>  drivers/thermal/samsung/exynos_tmu_data.c          |  225 ++++
>  drivers/thermal/samsung/exynos_tmu_data.h          |  155 +++
>  include/linux/platform_data/exynos_thermal.h       |  119 ---
>  16 files changed, 2076 insertions(+), 1203 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-th=
ermal.txt
>  delete mode 100644 drivers/thermal/exynos_thermal.c
>  create mode 100644 drivers/thermal/samsung/Kconfig
>  create mode 100644 drivers/thermal/samsung/Makefile
>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.c
>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.h
>  create mode 100644 drivers/thermal/samsung/exynos_tmu.c
>  create mode 100644 drivers/thermal/samsung/exynos_tmu.h
>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>  delete mode 100644 include/linux/platform_data/exynos_thermal.h
>=20
>=20
>=20



------enig2NROSVTKJFEOGHNFKVTTN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGTn2EACgkQCXcVR3XQvP2SRAEAk7NN4DRaDkovkrWtYvOhLf27
L4kpiONRagxavPVR/aQA/iL3T5H4n1SLMlRBkw8BZWPCvmWdcspWCPQpAmNFy9/b
=Vo57
-----END PGP SIGNATURE-----

------enig2NROSVTKJFEOGHNFKVTTN--
