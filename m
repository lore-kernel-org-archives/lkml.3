Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab3B0MZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:25:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:7618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955Ab3B0MZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:25:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,747,1355126400"; 
   d="scan'208";a="206855252"
Message-ID: <1361967892.2313.18.camel@rzhang1-mobl4>
Subject: [GIT PULL] thermal management updates for v3.9-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Date: Wed, 27 Feb 2013 20:24:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,


Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git release

to receive thermal management updates for v3.9 with top-most commit
f5b6d45f8cf688f51140fd21f1da3b90562762a9

thermal: rcar: remove __devinitconst (2013-02-22 17:38:40 +0800)

on top of commit 5f738967e89584f99c6a11c6bf09b16c50b6a03e

  Merge tag 'pinctrl-fixes' of
git://git./linux/kernel/git/linusw/linux-pinctrl

Highlights:

- introduction of Dove thermal sensor driver.

- introduction of Kirkwood thermal sensor driver.

- introduction of intel_powerclamp thermal cooling device driver.

- add interrupt and DT support for rcar thermal driver.

- add thermal emulation support which allows platform thermal driver to
  do software/hardware emulation for thermal issues.

thanks,
rui

----------------------------------------------------------------
Amit Daniel Kachhap (3):
      thermal: exynos: Miscellaneous fixes to support falling threshold
interrupt
      thermal: sysfs: Add a new sysfs node emul_temp for thermal
emulation
      thermal: exynos: Use the new thermal trend type for quick cooling
action.

Andrew Lunn (1):
      Thermal: Dove: Add Themal sensor support for Dove.

Arnd Bergmann (1):
      thermal: rcar: remove __devinitconst

Dan Carpenter (1):
      PM: intel_powerclamp: off by one in start_power_clamp()

Eduardo Valentin (4):
      thermal: Use thermal zone device id in netlink messages
      thermal: remove unnecessary include
      thermal: cleanup: use dev_* helper functions
      thermal: check for invalid trip setup when registering thermal
device

Jacob Pan (3):
      tick: export nohz tick idle symbols for module use
      x86/nmi: export local_touch_nmi() symbol for modules
      PM: Introduce Intel PowerClamp Driver

Jonghwa Lee (2):
      Thermal: exynos: Add sysfs node supporting exynos's emulation
mode.
      Thermal: exynos: Add support for temperature falling interrupt.

Julia Lawall (1):
      drivers/thermal/spear_thermal.c: use devm_clk_get

Kuninori Morimoto (9):
      thermal: rcar: add .get_trip_type/temp and .notify support
      thermal: rcar: use parenthesis on macro
      thermal: rcar: enable CPCTL to use hardware TSC deciding
      thermal: rcar: use mutex lock instead of spin lock
      thermal: rcar: multi channel support
      thermal: rcar: add read/write functions for common/priv data
      thermal: rcar: add interrupt support
      thermal: rcar: remove machine_power_off() from
rcar_thermal_notify()
      thermal: rcar: add Device Tree support

Nobuhiro Iwamatsu (1):
      thermal: Add support for the thermal sensor on Kirkwood SoCs

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Sachin Kamat (3):
      thermal: exynos: Use of_match_ptr() macro
      thermal: db8500: Use of_match_ptr() macro in db8500_thermal.c
      thermal: db8500: Use of_match_ptr() macro in
db8500_cpufreq_cooling.c

Zhang Rui (6):
      Introduce THERMAL_TREND_RAISE_FULL and THERMAL_TREND_DROP_FULL
      Introduce THERMAL_TREND_RAISE/DROP_FULL support for step_wise
governor
      step_wise: Unify the code for both throttle and dethrottle
      Thermal: fix a wrong comment
      Thermal: fix a build warning when CONFIG_THERMAL_EMULATION cleared
      Thermal: rename thermal governor Kconfig option to avoid generic
naming

 .../devicetree/bindings/thermal/dove-thermal.txt   |   18 +
 .../bindings/thermal/kirkwood-thermal.txt          |   15 +
 .../devicetree/bindings/thermal/rcar-thermal.txt   |   29 +
 Documentation/thermal/exynos_thermal_emulation     |   53 ++
 Documentation/thermal/intel_powerclamp.txt         |  307 ++++++++
 Documentation/thermal/sysfs-api.txt                |   18 +-
 arch/x86/kernel/nmi.c                              |    1 +
 drivers/thermal/Kconfig                            |   55 +-
 drivers/thermal/Makefile                           |   10 +-
 drivers/thermal/cpu_cooling.c                      |    4 +-
 drivers/thermal/db8500_cpufreq_cooling.c           |    5 +-
 drivers/thermal/db8500_thermal.c                   |    4 +-
 drivers/thermal/dove_thermal.c                     |  209 ++++++
 drivers/thermal/exynos_thermal.c                   |  211 ++++--
 drivers/thermal/intel_powerclamp.c                 |  794
++++++++++++++++++++
 drivers/thermal/kirkwood_thermal.c                 |  134 ++++
 drivers/thermal/rcar_thermal.c                     |  490 +++++++++---
 drivers/thermal/spear_thermal.c                    |    7 +-
 drivers/thermal/step_wise.c                        |  122 +--
 drivers/thermal/thermal_sys.c                      |  105 ++-
 include/linux/platform_data/exynos_thermal.h       |    3 +
 include/linux/thermal.h                            |   10 +-
 kernel/time/tick-sched.c                           |    2 +
 23 files changed, 2337 insertions(+), 269 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/thermal/dove-thermal.txt
 create mode 100644
Documentation/devicetree/bindings/thermal/kirkwood-thermal.txt
 create mode 100644
Documentation/devicetree/bindings/thermal/rcar-thermal.txt
 create mode 100644 Documentation/thermal/exynos_thermal_emulation
 create mode 100644 Documentation/thermal/intel_powerclamp.txt
 create mode 100644 drivers/thermal/dove_thermal.c
 create mode 100644 drivers/thermal/intel_powerclamp.c
 create mode 100644 drivers/thermal/kirkwood_thermal.c


