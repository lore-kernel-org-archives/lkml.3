Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaJKRSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:18:00 -0400
Received: from ring0.de ([5.45.105.125]:57095 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaJKRR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:17:57 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ring0.de]
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 11 Oct 2014 19:17:47 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [GIT PULL] power supply and reset changes for 3.18
Message-ID: <20141011171747.GA21084@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Torvalds,

The following pull request should include a fix for the broken
allmodconfig introduced by the MFD subsystem.

-- Sebastian

The following changes since commit 86ba8b0aee711b01fa5a14868035a3f4d6b1e1d9:

  Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kern=
el/git/wsa/linux (2014-09-05 13:45:09 -0700)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.18

for you to fetch changes up to 7881c64716f3a7d60b325ed0ad4d15f49b474a43:

  power: ab8500_fg: Fix build warning (2014-10-05 02:10:20 +0200)

----------------------------------------------------------------
power supply and reset changes for the v3.18 series

 - Initial support for the following chips
  * max77836 (charger)
  * max14577 (charger)
  * bq27742 (battery gauge)
  * ltc2952 (poweroff)
  * stih416 (restart)
  * syscon-reboot (restart)
  * gpio-restart (restart)
 - cleanup of power supply core
 - misc. fixes in power supply and reset drivers

----------------------------------------------------------------
Chanwoo Choi (2):
      power: charger-manager: Fix checking of wrong return type
      power: charger-manager: Check charging state right after completed in=
itialization

Cheng-Yi Chiang (1):
      sbs-battery: export manufacturer and model name to sysfs

David Riley (1):
      power: Add simple gpio-restart driver

Feng Kan (3):
      power: reset: Add generic SYSCON register mapped reset
      Documentation: power: reset: Add documentation for generic SYSCON reb=
oot driver
      power: reset: corrections for simple syscon reboot driver

Guenter Roeck (9):
      kernel: add support for kernel restart handler call chain
      power/restart: call machine_restart instead of arm_pm_restart
      arm64: support restart through restart handler call chain
      arm: support restart through restart handler call chain
      watchdog: moxart: register restart handler with kernel restart handler
      watchdog: alim7101: register restart handler with kernel restart hand=
ler
      watchdog: sunxi: register restart handler with kernel restart handler
      arm/arm64: unexport restart handlers
      power: ab8500_fg: Fix build warning

Heiko Stuebner (1):
      power: gpio-charger: do not use gpio value directly

Jingoo Han (1):
      power: charger-manager: Remove casting the return value which is a vo=
id pointer

Krzysztof Kozlowski (13):
      mfd: max14577: Add defines for MAX77836 charger
      mfd: max14577: Map charger device to its own of_node
      charger: max14577: Add support for MAX77836 charger
      regulator/mfd: max14577: Export symbols for calculating charger curre=
nt
      charger: max14577: Configure battery-dependent settings from DTS and =
sysfs
      power: max17040: Add ID for MAX77836 Fuel Gauge block
      devicetree: mfd: max14577: Add device tree bindings document
      Documentation: charger: max14577: Document exported sysfs entry
      power: max8925: Fix NULL ptr dereference on memory allocation failure
      power: max8925: Use of_get_child_by_name
      power: max14577: Fix circular config SYSFS dependency
      power: charger-manager: Fix NULL pointer exception with missing cm-fu=
el-gauge
      Documentation: charger: max14577: Update the date of introducing ABI

Lee Jones (2):
      power: reset: Add restart functionality for STiH41x platforms
      power: reset: st: Provide DT bindings for ST's Power Reset driver

Mark Brown (1):
      power/reset: xgene-reset: Fix prototype of xgene_restart()

Pramod Gurav (1):
      power: reset: use restart_notifier mechanism for msm-poweroff

Puthikorn Voravootivat (2):
      bq27x00_battery: Add support to bq27742
      bq27x00_battery: Fix flag reading for bq27742

Ramakrishna Pallala (1):
      power_supply: Add boot and calibration attributes

Ren=E9 Moll (2):
      power: reset: add LTC2952 poweroff driver
      Documentation: DT: Add LTC2952 poweroff bindings

Sebastian Reichel (2):
      Merge tag 'tags/mfd-power-charger-regulator-v3.18' into next
      Merge tag 'tags/restart-handler-for-v3.18' into next

Simon Que (1):
      sbs-battery: add min design voltage to sbs-battery

Viresh Kumar (15):
      power-supply: Don't over-allocate memory for "supplied-from" array
      power-supply: Return early if "power-supplies" property isn't valid
      Documentation: Charger Manager: Fix spelling mistakes
      power-supply: Forward declare structs together
      power-supply: Drop unnecessary typecasts
      power-supply: Use 'break' instead of 'continue' to end loop
      power-supply: Rearrange code to remove duplicate lines
      power-supply: Propagate error returned by power_supply_find_supply_fr=
om_node()
      power-supply: Don't return -EINVAL from __power_supply_find_supply_fr=
om_node()
      power-supply: Drop useless 'if (ret.intval)' statements
      power-supply: Mark 'if' blocks in power_supply_changed_work() with 'l=
ikely'
      power-supply: Use PTR_ERR_OR_ZERO() routine
      power-supply: Check for failures only when we can fail
      power-supply: Avoid unnecessary 'goto' statements
      power_supply: Don't iterate over devices to return -EPROBE_DEFER

 Documentation/ABI/testing/sysfs-class-power        |  14 +
 .../devicetree/bindings/gpio/gpio-restart.txt      |  54 +++
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 ++++++++
 .../bindings/power/reset/ltc2952-poweroff.txt      |  26 ++
 .../devicetree/bindings/power/reset/st-reset.txt   |  11 +
 .../bindings/power/reset/syscon-reboot.txt         |  23 ++
 Documentation/power/charger-manager.txt            |   2 +-
 Documentation/power/power_supply_class.txt         |   6 +
 arch/arm/kernel/process.c                          |  12 +-
 arch/arm64/kernel/process.c                        |   3 +-
 drivers/mfd/max14577.c                             | 100 +++++-
 drivers/power/Kconfig                              |   5 +-
 drivers/power/ab8500_fg.c                          |   9 +-
 drivers/power/bq27x00_battery.c                    |  57 ++-
 drivers/power/charger-manager.c                    |  16 +-
 drivers/power/gpio-charger.c                       |   2 +-
 drivers/power/max14577_charger.c                   | 370 +++++++++++++++++=
+--
 drivers/power/max17040_battery.c                   |   3 +-
 drivers/power/max8925_power.c                      |   7 +-
 drivers/power/power_supply_core.c                  | 100 +++---
 drivers/power/power_supply_leds.c                  |  19 +-
 drivers/power/power_supply_sysfs.c                 |  24 +-
 drivers/power/reset/Kconfig                        |  27 ++
 drivers/power/reset/Makefile                       |   4 +
 drivers/power/reset/gpio-restart.c                 | 149 ++++++++
 drivers/power/reset/ltc2952-poweroff.c             | 386 +++++++++++++++++=
++++
 drivers/power/reset/msm-poweroff.c                 |  20 +-
 drivers/power/reset/restart-poweroff.c             |   3 +-
 drivers/power/reset/st-poweroff.c                  | 151 ++++++++
 drivers/power/reset/syscon-reboot.c                |  91 +++++
 drivers/power/reset/xgene-reboot.c                 |   2 +-
 drivers/power/sbs-battery.c                        | 125 ++++++-
 drivers/regulator/max14577.c                       |  80 +----
 drivers/watchdog/alim7101_wdt.c                    |  42 ++-
 drivers/watchdog/moxart_wdt.c                      |  32 +-
 drivers/watchdog/sunxi_wdt.c                       |  31 +-
 include/linux/mfd/max14577-private.h               |  95 +++--
 include/linux/mfd/max14577.h                       |  30 ++
 include/linux/power_supply.h                       |   8 +-
 include/linux/reboot.h                             |   3 +
 kernel/reboot.c                                    |  81 +++++
 41 files changed, 2080 insertions(+), 289 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-restart.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
 create mode 100644 Documentation/devicetree/bindings/power/reset/ltc2952-p=
oweroff.txt
 create mode 100644 Documentation/devicetree/bindings/power/reset/st-reset.=
txt
 create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-re=
boot.txt
 create mode 100644 drivers/power/reset/gpio-restart.c
 create mode 100644 drivers/power/reset/ltc2952-poweroff.c
 create mode 100644 drivers/power/reset/st-poweroff.c
 create mode 100644 drivers/power/reset/syscon-reboot.c

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUOWY7AAoJENju1/PIO/qa40IP/0pn1Qznm7ySu/ULdLerzDAM
hCrLXNTUPyDplFtpA6tBy6sWVbi0QDh7sd/pnpTHXYkM3mXFaJiaRSMFpvT0qwrX
g53TiPa2HQP2UJCbTx0LHcnUQOQSviPs4Ut1LtsoI2diePkliqsIZRlKsDeH2Ghg
Wm5+mo5uEZrowXKMoggmY9CTRrXOBP6L4U/j0IbX4jw+ISXX/kq8N75zCD7H7Gbz
ZSb5j6I7HPhLJ/nX9HoJk10jitOrfunHpKPcFVHrMUXEDBIRfrb2hz4V1I+S2v27
UQrhWEDL4OFLf0p8PO/tx2Aojj8d5AA2gTnx8Dgo8aeETrQuG+RalE8PhTPPqpQ3
KOGBN+DS30HXS1TeSuJ0DgXSwewAvo5nuR9tO817wi9T7PRmPY3CTxkwFFM0X+ZR
CRca//2SKWEVWwUxO8LF9tFnO+pr44JFWk9SzdklWkaKHdfzPKKZc7m4DsMhpTVf
BVvdOBKXOjW6VsHj40QBghAYOt41T6XJjglWHDSaHFzzO6ceuRIfXzAZC0kuv1MT
/dO8c7tHT52k65xx/Ob/O/kGTcWjmSnhqQLFwWrgUI2wXH1iFeYDfRIljBR9x4sI
7xPIGl20ofwOo+zqSIDcvf+oFvGkRomcDIk80M+2D5SB4OiiSjBaq/+W1KDbsEcB
Fo5BG5utk2JvzL9lKK+b
=P268
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
