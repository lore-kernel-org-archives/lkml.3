Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaFCKun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:50:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51698 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFCKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:50:39 -0400
Date: Tue, 3 Jun 2014 11:36:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140603103643.GY31751@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w+MAdceOglSEzbpc"
Content-Disposition: inline
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.16
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w+MAdceOglSEzbpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014:

  Linux 3.15-rc8 (2014-06-01 19:12:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git regulator-v3.16

for you to fetch changes up to 978371cbabb4cb7a47751049d72f06dc8348cab2:

  Merge remote-tracking branch 'regulator/topic/tps6586x' into regulator-next (2014-06-02 17:08:14 +0100)

----------------------------------------------------------------

regulator: Updates for v3.16

The bulk of the changes for this release are a few new drivers however
there are a couple of noticable core changes and the usual stream of
cleanups and fixes:

 - Move disable of unused regulators later in init so it comes after
   deferred probe has iterated making startup smoother.
 - Fixes reference counting of the DT nodes for constraints from Charles
   Keepax.  This has little practical impact since all real users of
   the regulator bindings use FDT which doesn't need the reference
   counting.
 - Lots of cleanups, especially to the Samsung drivers.
 - Support for Linear Technologies LTC3589, Texas Instruments TPS658640
   and X-Powers AXP20x.

----------------------------------------------------------------
Alban Bedel (3):
      regulator: tps6586x: Prepare supporting fixed regulators
      regulator: tps6586x: Add support for the TPS658640
      regulator: core: Fix the init of DT defined fixed regulators

Arnd Bergmann (1):
      regulator: arizona-ldo1: add missing #include

Axel Lin (10):
      regulator: pbias: Convert to use regulator_[enable|is_enabled]_regmap
      regulator: tps65217: Remove *rdev[] from struct tps65217
      regulator: tps65217: Use regulator_map_voltage_ascend for LDO1
      regulator: core: Use map_voltage_linear_range by default for list_voltage_linear_range
      regulator: tps65218: Convert to use regulator_set_voltage_time_sel
      regulator: tps6586x: Remove unused to_tps6586x_dev() function
      regulator: ltc3589: Fix module dependency
      regulator: ltc3589: Remove ltc3589_list_voltage_fixed function
      regulator: pfuze100: Support enable/disable for fixed regulator
      regulator: axp20x: Use regulator_map_voltage_ascend for LDO4

Boris BREZILLON (1):
      regulator: AXP20x: fix wrong call to of_find_node_by_name

Carlo Caione (1):
      regulator: AXP20x: Add support for regulators subsystem

Charles Keepax (10):
      regulator: core: Add of_node_get to of_regulator_match
      regulator: core: Add helper to put of_nodes from matches
      regulator: core: Get and put regulator of_node
      regulator: core: Fix typo in of_regulator.h
      regulator: core: Use devres for releasing of_regulator_match of_nodes
      mfd: arizona: Factor out read of device tree GPIOs
      regulator: arizona-micsupp: Add processing of init_data from device tree
      regulator: arizona-ldo1: Move setup processing from arizona-core
      regulator: arizona-ldo1: Add processing of init_data from device tree
      regulator: arizona-micsupp: Add missing #include

Doug Anderson (5):
      regulator: tps65090: Allow setting the overcurrent wait time
      mfd: tps65090: Don't tell child devices we have an IRQ if we don't
      mfd: tps65090: Stop caching most registers
      regulator: tps65090: Make FETs more reliable by adding retries
      regulator: tps65090: Fix tps65090 crash on Tegra Dalmore

Jingoo Han (7):
      regulator: anatop: Make of_device_id array const
      regulator: palmas: Make of_device_id array const
      regulator: st-pwm: Make of_device_id array const
      regulator: vexpress: Make of_device_id array const
      regulator: max8952: Make of_device_id array const
      regulator: max8649: remove unnecessary OOM messages
      regulator: pbias: remove unnecessary OOM messages

Keerthy (1):
      regulator: palmas: Reemove open coded functions with helper functions

Krzysztof Kozlowski (10):
      regulator: s5m8767: Remove regulator_dev pointer from state container
      regulator: s2mps11: Move DTS parsing code to separate function
      regulator: s2mps11: Add external GPIO control for S2MPS14
      regulator: s2mps11: Document external GPIO control
      regulator: s5m8767: Allow GPIO 0 to be used as external control
      regulator: s2mps11: Allow GPIO 0 to be used as external control on S2MPS14
      regulator: s2mpa01: Fix accidental enable of buck4 ramp delay
      regulator: s2mps11: Fix accidental enable of buck6 ramp delay
      regulator: s2mpa01: Use rdev_get_id() to access id of regulator
      regulator: s2mpa01: Use correct register for buck1 ramp delay

Lee Jones (1):
      regulator: Constify the pointer to alias name array

Mark Brown (11):
      Merge tag 'ib-mfd-regulator-3.16' of git://git.kernel.org/.../lee/mfd into regulator-tps65090
      Merge tag 'mfd-regulator-v3.16-1' of git://git.kernel.org/.../lee/mfd into regulator-bcm590xxx
      regulator: Don't disable unused regulators we don't have permission for
      Merge remote-tracking branch 'regulator/fix/s2mpa01' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/constraints' into regulator-next
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branches 'regulator/topic/arizona', 'regulator/topic/axp20' and 'regulator/topic/bcm590xx' into regulator-next
      Merge remote-tracking branches 'regulator/topic/fixed', 'regulator/topic/id-const', 'regulator/topic/ltc3589', 'regulator/topic/max8649' and 'regulator/topic/of' into regulator-next
      Merge remote-tracking branches 'regulator/topic/palmas', 'regulator/topic/pbias', 'regulator/topic/pfuze100', 'regulator/topic/s2mpa01' and 'regulator/topic/s2mps11' into regulator-next
      Merge remote-tracking branches 'regulator/topic/s5m8767', 'regulator/topic/stub', 'regulator/topic/tps65090', 'regulator/topic/tps65217' and 'regulator/topic/tps65218' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps6586x' into regulator-next

Matt Porter (3):
      mfd: bcm590xx: Update binding with additional BCM59056 regulators
      mfd: bcm590xx: Add support for secondary I2C slave address
      regulator: bcm590xx: Add support for regulators on secondary I2C slave

Philipp Zabel (3):
      of: Add vendor prefix for Linear Technology Corporation
      regulator: ltc3589: Add DT binding documentation
      regulator: Add LTC3589 support

Saravana Kannan (1):
      regulator: core: Disable unused regulators after deferred probing is done

Sean Cross (2):
      regulator: pfuze100: Support SWB enable/disable
      regulator: pfuze100: Don't allocate an invalid gpio

Sergei Shtylyov (2):
      regulator: fixed: use of_property_read_{bool|u32}()
      regulator: use of_property_read_{bool|u32}()

Stephen Boyd (1):
      regulator: Fix regulator_get_{optional,exclusive}() documentation

Viresh Kumar (1):
      regulators: Add definition of regulator_set_voltage_time() for !CONFIG_REGULATOR

 Documentation/devicetree/bindings/mfd/bcm590xx.txt |   4 +-
 Documentation/devicetree/bindings/mfd/s2mps11.txt  |  14 +
 .../devicetree/bindings/regulator/ltc3589.txt      |  99 ++++
 .../devicetree/bindings/regulator/tps65090.txt     |   4 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/mfd/arizona-core.c                         |  41 +-
 drivers/mfd/bcm590xx.c                             |  60 ++-
 drivers/mfd/tps65090.c                             |  41 +-
 drivers/mfd/tps6586x.c                             |   4 +
 drivers/power/tps65090-charger.c                   |  11 -
 drivers/regulator/Kconfig                          |  15 +
 drivers/regulator/Makefile                         |   2 +
 drivers/regulator/anatop-regulator.c               |   2 +-
 drivers/regulator/arizona-ldo1.c                   |  58 +++
 drivers/regulator/arizona-micsupp.c                |  38 ++
 drivers/regulator/axp20x-regulator.c               | 286 +++++++++++
 drivers/regulator/bcm590xx-regulator.c             |  92 +++-
 drivers/regulator/core.c                           |  58 ++-
 drivers/regulator/devres.c                         |   6 +-
 drivers/regulator/fixed.c                          |  13 +-
 drivers/regulator/ltc3589.c                        | 554 +++++++++++++++++++++
 drivers/regulator/max8649.c                        |   4 +-
 drivers/regulator/max8952.c                        |   2 +-
 drivers/regulator/of_regulator.c                   |  68 ++-
 drivers/regulator/palmas-regulator.c               | 160 +-----
 drivers/regulator/pbias-regulator.c                |  29 +-
 drivers/regulator/pfuze100-regulator.c             |   8 +
 drivers/regulator/s2mpa01.c                        |  19 +-
 drivers/regulator/s2mps11.c                        | 113 ++++-
 drivers/regulator/s5m8767.c                        |  37 +-
 drivers/regulator/st-pwm.c                         |   2 +-
 drivers/regulator/tps65090-regulator.c             | 214 +++++++-
 drivers/regulator/tps65217-regulator.c             |   4 +-
 drivers/regulator/tps65218-regulator.c             |  37 +-
 drivers/regulator/tps6586x-regulator.c             |  68 ++-
 drivers/regulator/vexpress.c                       |   2 +-
 include/linux/mfd/arizona/core.h                   |   3 +
 include/linux/mfd/bcm590xx.h                       |   9 +-
 include/linux/mfd/core.h                           |   2 +-
 include/linux/mfd/samsung/s2mps14.h                |   2 +
 include/linux/mfd/tps65090.h                       |  19 +
 include/linux/mfd/tps65217.h                       |   1 -
 include/linux/mfd/tps6586x.h                       |   2 +
 include/linux/regulator/consumer.h                 |  42 +-
 44 files changed, 1832 insertions(+), 418 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/ltc3589.txt
 create mode 100644 drivers/regulator/axp20x-regulator.c
 create mode 100644 drivers/regulator/ltc3589.c

--w+MAdceOglSEzbpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjaU4AAoJELSic+t+oim9G48P/0Y9HanRfe+xNQoyj1eU3cZr
lQWkP7bXqGrVDLzqO2h6jtfQolSRF7d7hXM6V3B36/gsm7gKYXmYv6TRUZp9IQm9
pIRf7gbJALoco+njHDFrutA0o0hlAvPuNuGUl5XSq61iaMElH+gTV/D7a47rkQyP
/PDr6vVhpnGBlaDypDMXspV2hjOV5rcGn6DZZ5mScSbJRPYdUXfxjM1n5jWopq2N
xV6PkgCxpS6Xrv3+3oNPO8cX+JBdjh8c73b39JN6ZflkXoIglNoQhtK9BZ1Dl6Gu
1pSfsHxD2z1yARHSoqathFhpTy0R24JjDfJsRx69bXpWF0pOm/8s27li7Qj/8jFz
y1fnR+0Bd3lx3GZFXZ4I+7mVQ2CJw/XJLvwLGKq07/66PbHZ4UrfUnl9shv0AqKG
9Er9cKeGWPaWQTh60Q7hWs1MKcla6mEIH+lLx7cj5aux9/cedkjV+A7A698d3mGy
XaoBy20FYcEKBGO+05RVQPl9LPlqPgFUSJpuuznmlmZNXj1C7lHb9njvnOplecaq
jvigA/1wVtK4Xc+fBEH7fA3LJwTrtoPPq1HyEw3LkxeGBvGt47C6UDoeXhy7VR38
dRMWimBJjVFEjsSxmYyMU1VVTtZr+JPk1/qFSfa8M+uWmx/MogUYnOS3IwA/N9Hp
PAuE7UQoGxvdmrw3uKTZ
=bWwl
-----END PGP SIGNATURE-----

--w+MAdceOglSEzbpc--
