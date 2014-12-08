Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaLHNWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:22:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52046 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaLHNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:22:15 -0500
Date: Mon, 8 Dec 2014 13:21:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141208132159.GZ11764@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fq7EdiloNwzjWdQG"
Content-Disposition: inline
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fq7EdiloNwzjWdQG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:

  Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.19

for you to fetch changes up to 176488fbc121a4670849f2d10332b0fac333886b:

  Merge remote-tracking branches 'regulator/topic/sky81452' and 'regulator/topic/stub' into regulator-next (2014-12-05 11:14:43 +0000)

----------------------------------------------------------------
regulator: Updates for v3.19

The main thing this time around is support for suspend mode
configuration from DT which will enable some very useful power savings
on systems where we can't rely on the bootloader configuration.  We
still don't really support dynamic configuration of this at runtime,
that may come later if there is any demand.

 - Support for specifying the target regulation mode and voltage during
   system suspend via DT, enabling power savings in that mode.
 - Reduce the default verbosity of the logging on boot, improving boot
   times especially for systems with very large numbers of regulators.
 - Lots of cleanups and fixes for Maxim PMIC drivers.
 - New driver for Richtek RT5033.

----------------------------------------------------------------
Axel Lin (1):
      regulator: sky81452: Remove module version

Beniamino Galvani (1):
      regulator: rn5t618: Convert to new style DT parsing

Beomho Seo (1):
      regulator: rt5033: Add RT5033 Regulator device driver

Chanwoo Choi (2):
      regulator: of: Add support for parsing regulator_state for suspend state
      regulator: Document binding for regulator suspend state for PM state

Chris Zhong (1):
      regulator: rk808: Add support setting suspend voltage

Dan Carpenter (1):
      regulator: max77802: fix a test in max77802_set_suspend_mode()

Dmitry Lavnikevich (1):
      regulator: da9063: Do not transform local IRQ to virtual

Doug Anderson (2):
      regulator: Document binding for regulator suspend voltage
      regulator: of: Add support for parsing microvolts for suspend state

Gyungoh Yoo (3):
      regulator: sky81452: Modify dependent Kconfig symbol
      regulator: sky81452: Modify Device Tree structure
      regulator: sky81452: Modify Device Tree structure

Javier Martinez Canillas (15):
      regulator: max77802: Add .set_suspend_{enable,disable} callbacks
      regulator: max77802: Split regulator operations for BUCKs
      regulator: max77802: Add .{get,set}_mode callbacks
      regulator: max77802: Add set suspend mode for BUCKs and simplify code
      regulator: max77802: Don't treat OFF as an operating mode
      regulator: max77802: Add header for operating modes
      regulator: of: Decrement refcount for suspend state nodes
      regulator: max77802: Use unsigned int for modes in max77802_map_mode()
      regulator: Document binding for initial and suspend modes
      regulator: Add mode mapping function to struct regulator_desc
      regulator: of: Add regulator desc param to of_get_regulator_init_data()
      regulator: of: Pass the regulator description in the match table
      regulator: of: Add support for parsing initial and suspend modes
      regulator: max77802: Document binding for regulator operating modes
      regulator: max77802: Fill regulator modes translation callback

Josh Cartwright (1):
      regulator: rpm: add support for RPM-controller SMB208

Krzysztof Kozlowski (16):
      regulator: s2mps11: Don't zero allocated memory for external control
      regulator: dummy: Make regulator_desc array const
      regulator: max77693: Make regulator_desc array const
      regulator: max77802: Make regulator_desc array const
      regulator: s2mpa01: Make regulator_desc array const
      regulator: max77686: Make regulator_desc array const
      regulator: max77686: Replace hard-coded opmode values with defines
      regulator: max77686: Store opmode non-shifted
      regulator: max77802: Remove suspend_enable
      regulator: max77686: Add suspend disable for some LDOs
      regulator: Staticize 'regulator_states' array
      regulator: max77686: Consistently index opmode array by rdev id
      regulator: max77686: Initialize opmode explicitly to normal mode
      regulator: max77802: Don't ignore return value of current opmode
      regulator: max77802: Remove support for board files
      regulator: max77686: Remove support for board files

Mark Brown (12):
      regulator: Return an error from stubbed regulator_get_exclusive()
      regulator: Lower priority of constraint logging
      Merge branch 'topic/suspend' of git://git.kernel.org/.../broonie/regulator into regulator-max77802
      Merge tag 'v3.18-rc4' into regulator-max77802
      Merge tag 'v3.18-rc4' into regulator-max77686
      Merge branch 'topic/suspend' of git://git.kernel.org/.../broonie/regulator into regulator-sky81452
      Merge remote-tracking branch 'regulator/fix/da9063' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branches 'regulator/topic/anatop', 'regulator/topic/disable', 'regulator/topic/dummy' and 'regulator/topic/gpio' into regulator-next
      Merge remote-tracking branches 'regulator/topic/max77686', 'regulator/topic/max77693', 'regulator/topic/max77802', 'regulator/topic/power-off' and 'regulator/topic/rk808' into regulator-next
      Merge remote-tracking branches 'regulator/topic/rn5t618', 'regulator/topic/rpm', 'regulator/topic/rt5033', 'regulator/topic/s2mpa01' and 'regulator/topic/s2mps11' into regulator-next
      Merge remote-tracking branches 'regulator/topic/sky81452' and 'regulator/topic/stub' into regulator-next

Markus Pargmann (7):
      regulator: anatop: Set default voltage selector for vddpu
      regulator: anatop: Fail on invalid voltage selector
      regulator: Add ena_gpio_initialized to regulator_config
      regulator: Set ena_gpio_initialized in regulator drivers
      regulator: fixed: Use gpio_is_valid
      regulator: gpio: Use gpio_is_valid
      regulator: tps65090: Fix gpio initialization

Richard Fitzgerald (2):
      regulator: gpio: fix parsing of gpio list
      regulator: core: Add PRE_DISABLE notification

Romain Perier (6):
      of: Add standard property for poweroff capability
      regulator: act8865: Add support to turn off all outputs
      dt-bindings: Document the standard property "poweroff-source"
      dt-bindings: Document the property poweroff-source for act8865 regulator
      of: Rename "poweroff-source" property to "system-power-controller"
      dt-bindings: Update documentation for "system-power-controller" and fix misspellings

Seung-Woo Kim (1):
      regulator: core: Fix regualtor_ena_gpio_free not to access pin after freeing

 .../devicetree/bindings/power/power-controller.txt |  18 ++
 .../bindings/regulator/act8865-regulator.txt       |   4 +
 .../devicetree/bindings/regulator/max77802.txt     |  35 +++
 .../devicetree/bindings/regulator/regulator.txt    |  22 ++
 .../bindings/regulator/sky81452-regulator.txt      |  10 +-
 drivers/regulator/88pm8607.c                       |   3 +-
 drivers/regulator/Kconfig                          |  10 +-
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/act8865-regulator.c              |  31 +++
 drivers/regulator/anatop-regulator.c               |  18 +-
 drivers/regulator/arizona-ldo1.c                   |  10 +-
 drivers/regulator/arizona-micsupp.c                |   8 +-
 drivers/regulator/core.c                           |  23 +-
 drivers/regulator/da9052-regulator.c               |   3 +-
 drivers/regulator/da9063-regulator.c               |  19 +-
 drivers/regulator/da9210-regulator.c               |   2 +-
 drivers/regulator/dummy.c                          |   2 +-
 drivers/regulator/fan53555.c                       |  17 +-
 drivers/regulator/fixed.c                          |  24 +-
 drivers/regulator/gpio-regulator.c                 | 115 +++++-----
 drivers/regulator/max77686.c                       | 172 +++++++-------
 drivers/regulator/max77693.c                       |   2 +-
 drivers/regulator/max77802.c                       | 254 +++++++++++----------
 drivers/regulator/max8952.c                        |   4 +-
 drivers/regulator/max8973-regulator.c              |   3 +-
 drivers/regulator/max8997.c                        |   3 +-
 drivers/regulator/max8998.c                        |   5 +-
 drivers/regulator/mc13xxx-regulator-core.c         |   3 +-
 drivers/regulator/of_regulator.c                   |  87 ++++++-
 drivers/regulator/pwm-regulator.c                  |   3 +-
 drivers/regulator/qcom_rpm-regulator.c             |  28 ++-
 drivers/regulator/rk808-regulator.c                |  57 ++++-
 drivers/regulator/rn5t618-regulator.c              |  51 +----
 drivers/regulator/rt5033-regulator.c               | 123 ++++++++++
 drivers/regulator/s2mpa01.c                        |   2 +-
 drivers/regulator/s2mps11.c                        |   3 +-
 drivers/regulator/s5m8767.c                        |   4 +-
 drivers/regulator/sky81452-regulator.c             |  46 +---
 drivers/regulator/stw481x-vmmc.c                   |   3 +-
 drivers/regulator/ti-abb-regulator.c               |   3 +-
 drivers/regulator/tps51632-regulator.c             |  43 ++--
 drivers/regulator/tps62360-regulator.c             |  31 +--
 drivers/regulator/tps65090-regulator.c             |   4 +
 drivers/regulator/tps65218-regulator.c             |   3 +-
 drivers/regulator/twl-regulator.c                  |   3 +-
 drivers/regulator/vexpress.c                       |   3 +-
 drivers/regulator/wm8994-regulator.c               |   6 +-
 include/dt-bindings/regulator/maxim,max77802.h     |  18 ++
 include/linux/mfd/max77686.h                       |   7 -
 include/linux/of.h                                 |  11 +
 include/linux/regulator/consumer.h                 |   6 +-
 include/linux/regulator/driver.h                   |   8 +
 include/linux/regulator/of_regulator.h             |   9 +-
 53 files changed, 919 insertions(+), 464 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power-controller.txt
 create mode 100644 drivers/regulator/rt5033-regulator.c
 create mode 100644 include/dt-bindings/regulator/maxim,max77802.h

--Fq7EdiloNwzjWdQG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhaX3AAoJECTWi3JdVIfQxOQH/2uoOq0gC/4r4umCsLJesbm2
bBsEUEKgb0FR6aGnw07VIONxFdp9QQUqMp7U+iyhwe440uf2JDUZ6THScS6fA+iR
w9QqJhABC0Jez/De8z64pWPTFFLEtKvIdHvgyGmECQ1hg9PuXljOCNrpOQIs3NVh
cm4kMX2B1upXPWEHtVYtm7y/q82/tggyQPXTtl/gugCi6MM+smyiLEZTu3+0UD5Z
Rfxf8hYfSzyyaUaNrk90415pGQ/oOJnKx4ME28QxuD5Rk7SlPMq3gsBpRk20Emmi
CHgBGimKFxELT3rcaQSZ524mOR6smxAKNNc/m0Jy6Y3DN6+haKLK1e+iDUYeTpI=
=18w6
-----END PGP SIGNATURE-----

--Fq7EdiloNwzjWdQG--
