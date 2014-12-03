Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaLCPxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:53:32 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49202 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLCPx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:53:29 -0500
Date: Wed, 3 Dec 2014 11:53:19 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] thermal-soc management updates for v3.19 #1
Message-ID: <20141203155310.GA5014@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello Rui,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git linus

to receive Thermal-SoC Management updates for v3.19 with top-most

e920f9b632a687834de5a78c60ac5c4c62327b1d:

  thermal: armada: Remove support for A375-Z1 SoC (2014-11-24 16:55:42 -0400)

on top of commitfc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

Specifics:

In this window, several changes were proposed into thermal-soc. It is a good thing
as the code is becoming better now. I am sending this first, but there is still
on going work on cpu cooling, by Viresh, and hopefully we make it for 3.19 too.
We will see.

In this pull, we have:
- First round of refactoring in Exynos driver. Bartlomiej and Lukasz are attempting
to make it lean and easier to understand.
- New thermal driver for Rockchipi (rk3288), with support for DT thermal.
- New thermal driver for Nvidia, Tegra124 SOCTHERM driver, with support for DT thermal.
- Improvements in of-thermal due to new coming drivers (more is expected here).
- New cooling device, based on common clock framework.
- We are dropping the support for Armada A375-Z1 SoC thermal. The chip is not
in the market, armada folks decided to drop its support.

BR,

Eduardo Valentin

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (33):
      thermal: exynos: remove needless triminfo_data abstraction
      thermal: exynos: remove needless tmu_status abstraction
      thermal: exynos: remove needless threshold_temp abstraction
      thermal: exynos: remove needless triminfo_ctrl abstraction
      thermal: exynos: remove needless test_mux_addr_shift abstraction
      thermal: exynos: remove needless therm_trip_[mode,mask]_shift abstractions
      thermal: exynos: remove needless therm_trip_en_shift abstraction
      thermal: exynos: remove needless emul_temp_shift abstraction
      thermal: exynos: remove needless emul_time_shift abstraction
      thermal: exynos: replace tmu_irqstatus check by Exynos5440 one
      thermal: exynos: replace tmu_pmin check by Exynos5440 one
      thermal: exynos: simplify HW_TRIP level setting
      thermal: exynos: replace threshold_falling check by Exynos SoC type one
      thermal: exynos: remove TMU_SUPPORT_READY_STATUS flag
      thermal: exynos: remove TMU_SUPPORT_TRIM_RELOAD flag
      thermal: exynos: add sanitize_temp_error() helper
      thermal: exynos: add get_th_reg() helper
      thermal: exynos: add ->tmu_initialize method
      thermal: exynos: add get_con_reg() helper
      thermal: exynos: add ->tmu_control method
      thermal: exynos: add ->tmu_read method
      thermal: exynos: add get_emul_con_reg() helper
      thermal: exynos: add ->tmu_set_emulation method
      thermal: exynos: add ->tmu_clear_irqs method
      thermal: exynos: remove TMU_SUPPORT_FALLING_TRIP flag
      thermal: exynos: remove TMU_SUPPORT_EMUL_TIME flag
      thermal: exynos: remove TMU_SUPPORT_EMULATION flag
      thermal: exynos: remove TMU_SUPPORT_ADDRESS_MULTIPLE flag
      thermal: exynos: remove TMU_SUPPORT_MULTI_INST flag
      thermal: exynos: remove test_mux pdata field
      thermal: exynos: remove SoC type ifdefs
      thermal: exynos: remove __EXYNOS5420_TMU_DATA macro
      thermal: exynos: remove exynos_tmu_data.h include

Caesar Wang (2):
      dt-bindings: document Rockchip thermal
      thermal: rockchip: add driver for thermal

Eduardo Valentin (2):
      thermal: introduce clock cooling device
      thermal: of: improve of-thermal sensor registration API

Ezequiel Garcia (1):
      thermal: armada: Remove support for A375-Z1 SoC

Mikko Perttunen (4):
      of: Add bindings for nvidia,tegra124-soctherm
      ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
      ARM: tegra: Add thermal trip points for Jetson TK1
      thermal: Add Tegra SOCTHERM thermal management driver

 .../devicetree/bindings/thermal/armada-thermal.txt |   8 -
 .../bindings/thermal/rockchip-thermal.txt          |  68 ++
 .../devicetree/bindings/thermal/tegra-soctherm.txt |  53 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  44 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  47 ++
 drivers/hwmon/lm75.c                               |   9 +-
 drivers/hwmon/ntc_thermistor.c                     |   6 +-
 drivers/hwmon/tmp102.c                             |   6 +-
 drivers/thermal/Kconfig                            |  32 +
 drivers/thermal/Makefile                           |   5 +
 drivers/thermal/armada_thermal.c                   |  20 -
 drivers/thermal/clock_cooling.c                    | 485 ++++++++++++++
 drivers/thermal/of-thermal.c                       |  39 +-
 drivers/thermal/rockchip_thermal.c                 | 693 +++++++++++++++++++++
 drivers/thermal/samsung/exynos_thermal_common.h    |   1 -
 drivers/thermal/samsung/exynos_tmu.c               | 692 +++++++++++++-------
 drivers/thermal/samsung/exynos_tmu.h               | 123 +---
 drivers/thermal/samsung/exynos_tmu_data.c          | 239 +------
 drivers/thermal/samsung/exynos_tmu_data.h          | 159 -----
 drivers/thermal/tegra_soctherm.c                   | 476 ++++++++++++++
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   8 +-
 include/dt-bindings/thermal/tegra124-soctherm.h    |  13 +
 include/linux/clock_cooling.h                      |  65 ++
 include/linux/thermal.h                            |  24 +-
 24 files changed, 2523 insertions(+), 792 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
 create mode 100644 Documentation/devicetree/bindings/thermal/tegra-soctherm.txt
 create mode 100644 drivers/thermal/clock_cooling.c
 create mode 100644 drivers/thermal/rockchip_thermal.c
 delete mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
 create mode 100644 drivers/thermal/tegra_soctherm.c
 create mode 100644 include/dt-bindings/thermal/tegra124-soctherm.h
 create mode 100644 include/linux/clock_cooling.h

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfzHdAAoJEMLUO4d9pOJWPtIH/0ztVP5WjHzG4RJWS4JmTdSs
0knSlCfdn+E/5WPVGp+Kl2eiZGSqi63aKJFo1fyKijed/9MuYkO0lfFuJT4NVRdh
3NK8PrUOfudIYz2Ujp/mcwgy5X/DZBXtzJ4uQCdxY++eLDiT6RkkXHO9/vY0aR5n
92agd5+8gOmm8Oi2Q7SbP8L3Pu8T2tMXcYwwAA9uj3REVCYlVOlqhr5A/V4SDYZv
fvvArS1/TTDGuLjEGNOY0iwed+qGLUYeQdKTT8q7Y8z9W0yJHG8Bs/WYlQZ55oTw
4ln/jGTheSG7/qYOyr9ZBFbkFzRWCAD1tzGlipIF8Enel1cT1hdXPa3b3O82Xbk=
=VcDa
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
