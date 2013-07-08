Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3GHXOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 19:14:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59621 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab3GHXOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:14:07 -0400
Message-ID: <51DB47A9.6070705@ti.com>
Date: Mon, 8 Jul 2013 19:13:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH V7 00/30] thermal: exynos: Re-structure driver and add
 support for exynos5440
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2JNQEMKDMAJSOUQURBTKF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2JNQEMKDMAJSOUQURBTKF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24-06-2013 06:50, Amit Daniel Kachhap wrote:
> Submitting V7 version with all comments fixed. Most of the patches are =
acked by
> Eduardo. All the un-acked patches are modified according to the review =
comments.
> If any comments please let me know.


Applied on linux-soc-thermal branch for_3.12/exynos. It will be queued
for next merge window. Too late for this one, sorry.

>=20
> Thanks,
> Amit Daniel
>=20
> Changes in V7:
> * Fixed all the coding guidelines comments given by Eduardo.
> * Moved the request irq call below the core thermal registration as per=
 discussion
>   with Eduardo.
> * Appropriate logs/TODO's/comments added for some review comments which=
 are still
>   same as before,
>   1) calibration register setting still uses enums.
>   2) very few soc check's still left in the driver.
>   3) Cooling devices stored in an array in the exynos core thermal laye=
r.=20
>=20
> Changes in V6:
> * Uses ARCH_HAS_BANDGAP config flag which is merged now in arm tree.
> (http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=3D7758/=
1).
> * In this version patches 1, 2, 3, 4 and 30 are modified. Others are sa=
me as V5.
> * Added acked by from Jonghwa Lee.
> * Rebased against Thermal Maintainer next tree.
>=20
> Changes in V5:
> * Most of the changes in this version is as per suggestion from Jonghwa=
 Lee. I
>  have retained one to one mapping of platform data with TMU instances a=
s the
>  TMU's are different devices. In exynos5440 soc there is some register
>  sharing across multiple TMU's but in exynos5420 there is no register b=
etween
>  multiple TMU's, so the current implementation is useful to support bot=
h of the
>  above.
>  This patch uses localized ARCH_HAS_TMU Kconfig option and is a tempora=
ry solution
>  until a more generic macro ARCH_HAS_BANDGAP is introduced as per discu=
ssion in
>  the link https://patchwork.kernel.org/patch/2659001/.
> * trip type is passed as platform data.
> * HW trip is allowed only for maximum level.
> * Platform data structure is now abstracted inside 1 more structure to =
support
>   multiple sensor TMU data.=20
>=20
> Changes in V4:
>  Almost all the changes in this version is as per suggestion from Eduar=
do.The
>  major ones are listed below,
> * Added kconfig symbol ARCH_HAS_TMU which needs to be enabled by platfo=
rm. With
>   this change existing symbol EXYNOS_TMU_DATA is not needed.
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

> Lukasz Majewski is already posted to mainline. Using it as it is needed=
=2E
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
> patch (arm: exynos: enable ARCH_HAS_BANDGAP) can be merged through exyn=
os platform
> maintainer as this can cause merge conflict.
>=20
> All these patches are based on thermal maintainers git tree,
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.
>=20
> Amit Daniel Kachhap (30):
>   thermal: exynos: Moving exynos thermal files into samsung directory
>   thermal: exynos: Use ARCH_HAS_BANDGAP config to know the supported
>     soc's
>   thermal: exynos: Remove un-necessary CPU_THERMAL dependency
>   thermal: exynos: Bifurcate exynos thermal common and tmu controller
>     code
>   thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
>   thermal: exynos: Move exynos_thermal.h from include/* to driver/*
>     folder
>   thermal: exynos: Bifurcate exynos tmu driver and configuration data
>   thermal: exynos: Add missing definations and code cleanup
>   thermal: exynos: Add extra entries in the tmu platform data
>   thermal: exynos: Move register definitions from driver to data file
>   thermal: exynos: Support thermal tripping
>   thermal: exynos: Fix to clear only the generated interrupts
>   thermal: exynos: Add support for instance based register/unregister
>   thermal: exynos: Modify private_data to appropriate name driver_data
>   thermal: exynos: Return success even if no cooling data supplied
>   thermal: exynos: Make the zone handling use trip information
>   thermal: exynos: Remove non DT based support
>   thermal: exynos: Add support to handle many instances of TMU
>   thermal: exynos: Add TMU features to check instead of using SOC type
>   thermal: exynos: use device resource management infrastructure
>   thermal: exynos: Add support to access common register for
>     multistance
>   thermal: exynos: Add driver support for exynos5440 TMU sensor
>   thermal: exynos: Add thermal configuration data for exynos5440 TMU
>     sensor
>   thermal: exynos: Fix to set the second point correction value
>   thermal: exynos: Add hardware mode thermal calibration support
>   thermal: exynos: Support for TMU regulator defined at device tree
>   ARM: dts: thermal: exynos: Add documentation for Exynos SoC thermal
>     bindings
>   Documentation: thermal: Explain the exynos thermal driver model
>   ARM: dts: Add device tree node for exynos5440 TMU controller
>   arm: exynos: enable ARCH_HAS_BANDGAP
>=20
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   55 +
>  Documentation/thermal/exynos_thermal               |   43 +-
>  arch/arm/boot/dts/exynos5440.dtsi                  |   30 +
>  arch/arm/mach-exynos/Kconfig                       |    5 +
>  drivers/thermal/Kconfig                            |   13 +-
>  drivers/thermal/Makefile                           |    2 +-
>  drivers/thermal/exynos_thermal.c                   | 1058 ------------=
--------
>  drivers/thermal/samsung/Kconfig                    |   18 +
>  drivers/thermal/samsung/Makefile                   |    7 +
>  drivers/thermal/samsung/exynos_thermal_common.c    |  432 ++++++++
>  drivers/thermal/samsung/exynos_thermal_common.h    |  107 ++
>  drivers/thermal/samsung/exynos_tmu.c               |  752 ++++++++++++=
++
>  drivers/thermal/samsung/exynos_tmu.h               |  309 ++++++
>  drivers/thermal/samsung/exynos_tmu_data.c          |  250 +++++
>  drivers/thermal/samsung/exynos_tmu_data.h          |  155 +++
>  include/linux/platform_data/exynos_thermal.h       |  119 ---
>  16 files changed, 2160 insertions(+), 1195 deletions(-)
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


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2JNQEMKDMAJSOUQURBTKF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHbR6kACgkQCXcVR3XQvP21NgEAp7zmaFLMDQD7GKM63DAWZi2e
nshoSjo4lIlHtx8d7cABAOXd9wlIsJYOYHKtFlNbIevnDy6u1VFUp9CgbC7i5H4Q
=IyPQ
-----END PGP SIGNATURE-----

------enig2JNQEMKDMAJSOUQURBTKF--
