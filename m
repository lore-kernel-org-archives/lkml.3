Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaAXDgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 22:36:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:11239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaAXDg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 22:36:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,710,1384329600"; 
   d="scan'208";a="470029330"
Message-ID: <1390534568.12771.58.camel@rzhang1-mobl4>
Subject: [GIT PULL] Thermal management updates for v3.14-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-devicetree <devicetree@vger.kernel.org>,
        linux-lmsensor <lm-sensors@lm-sensors.org>
Date: Fri, 24 Jan 2014 11:36:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

   git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

to receive Thermal management updates for v3.14-rc1 with
top-most commit c698a4492f01127ca90fc28cd5157f3d616fe4ff:

  Merge branch 'misc' of .git into next (2014-01-06 22:48:19 +0800)


on top of commit dea4f48a0a301b23c65af8e4fe8ccf360c272fbf:

  Merge branch 'leds-fixes-for-3.13' of
git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds
(2013-12-02 12:08:01 -0800)

This time, the biggest change is the work of representing hardware
thermal properties in device tree infrastructure.
This work includes the introduction of a device tree bindings for
describing the hardware thermal behavior and limits, and also a parser
to read and interpret the data, and build thermal zones and thermal
binding parameters. It also contains three examples on how to use the
new representation on sensor devices, using three different drivers to
accomplish it. One driver is in thermal subsystem, the TI SoC thermal,
and the other two drivers are in hwmon subsystem.
Actually, this would be the first step of the complete work because we
still need to check other potential drivers to be converted and then
validate the proposed API. But the reason why I include it in this pull
request is that, first, this change does not hurt any others without
using this approach, second, the principle and concept of this change
would not break after converting the remaining drivers. BTW, as you can
see, there are several points in this change that do not belong to
thermal subsystem. Because it has been suggested by Guenter R. that in
such cases, it is recommended to send the complete series via one single
subsystem.

Specifics:

 - representing hardware thermal properties in device tree
infrastructure.

 - fix a regression that the imx thermal driver breaks system suspend.

 - introduce ACPI INT3403 thermal driver to retrieve temperature data
from the INT3403 ACPI device object present on some systems.

 - introduce debug statement for thermal core and step_wise governor.

 - assorted fixes and cleanups for thermal core, cpu cooling, exynos
thrmal, intel powerclamp and imx thermal driver.

thanks,
rui

----------------------------------------------------------------

Aaron Lu (1):
      thermal: debug: add debug statement for core and step_wise

Anson Huang (2):
      thermal: imx: correct suspend/resume flow
      thermal: imx: add necessary clk operation

Eduardo Valentin (22):
      thermal: allow registering without .get_temp
      thermal: introduce device tree parser
      thermal: core: introduce thermal_of_cooling_device_register
      thermal: cpu_cooling: introduce of_cpufreq_cooling_register
      cpufreq: cpufreq-cpu0: add dt node parsing for cooling device
properties
      hwmon: lm75: expose to thermal fw via DT nodes
      hwmon: tmp102: expose to thermal fw via DT nodes
      thermal: ti-soc-thermal: use thermal DT infrastructure
      arm: dts: add omap4 CPU thermal data
      arm: dts: add omap4430 thermal data
      arm: dts: add omap4460 thermal data
      arm: dts: add cooling properties on omap4430 cpu node
      arm: dts: add cooling properties on omap4460 cpu node
      arm: dts: add omap5 GPU thermal data
      arm: dts: add omap5 CORE thermal data
      arm: dts: add omap5 thermal data
      arm: dts: add cooling properties on omap5 cpu node
      arm: dts: make OMAP443x bandgap node to belong to OCP
      arm: dts: make OMAP4460 bandgap node to belong to OCP
      MAINTAINERS: add thermal bindings entry in thermal domain
      thermal: fix cpu_cooling max_level behavior
      thermal: remove const flag from .ops of imx thermal

Julia Lawall (1):
      thermal: exynos: fix error return code

Laurent Pinchart (1):
      thermal: rcar-thermal: Enable driver compilation with COMPILE_TEST

Naveen Krishna Chatradhi (1):
      thermal:samsung: fix compilation warning

Rashika (1):
      drivers: thermal: Mark function as static in
x86_pkg_temp_thermal.c

Russell King (1):
      thermal: imx_thermal: add module device table

Srinivas Pandruvada (1):
      Thermal: ACPI INT3403 thermal driver

Yuxuan Shui (1):
      intel_powerclamp: Fix cstate counter detection.

Zhang Rui (5):
      Merge branch 'next' of
git://git.kernel.org/.../evalenti/linux-soc-thermal into soc-thermal
      Thermal cpu cooling: return error if no valid cpu frequency entry
      Merge branches 'misc', 'soc', 'soc-eduardo' and 'int3404-thermal'
of .git into next
      Merge branches 'misc' and 'soc' of .git into next
      Merge branch 'misc' of .git into next

lan,Tianyu (1):
      Thermal: update thermal zone device after setting emul_temp

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |    7 +
 .../devicetree/bindings/thermal/imx-thermal.txt    |    4 +
 .../devicetree/bindings/thermal/thermal.txt        |  595
++++++++++++++
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/omap4-cpu-thermal.dtsi           |   41 +
 arch/arm/boot/dts/omap443x.dtsi                    |   23 +-
 arch/arm/boot/dts/omap4460.dtsi                    |   29 +-
 arch/arm/boot/dts/omap5-core-thermal.dtsi          |   28 +
 arch/arm/boot/dts/omap5-gpu-thermal.dtsi           |   28 +
 arch/arm/boot/dts/omap5.dtsi                       |   14 +-
 drivers/cpufreq/Kconfig                            |    2 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |   16 +
 drivers/hwmon/lm75.c                               |   35 +-
 drivers/hwmon/tmp102.c                             |   19 +
 drivers/thermal/Kconfig                            |   23 +-
 drivers/thermal/Makefile                           |    2 +
 drivers/thermal/cpu_cooling.c                      |   67 +-
 drivers/thermal/imx_thermal.c                      |   54 +-
 drivers/thermal/int3403_thermal.c                  |  237 ++++++
 drivers/thermal/intel_powerclamp.c                 |   11 +-
 drivers/thermal/of-thermal.c                       |  849
++++++++++++++++++++
 drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
 drivers/thermal/samsung/exynos_tmu.c               |    1 +
 drivers/thermal/step_wise.c                        |    6 +
 drivers/thermal/thermal_core.c                     |   86 +-
 drivers/thermal/thermal_core.h                     |    9 +
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   77 +-
 drivers/thermal/x86_pkg_temp_thermal.c             |    2 +-
 include/dt-bindings/thermal/thermal.h              |   17 +
 include/linux/cpu_cooling.h                        |   25 +
 include/linux/thermal.h                            |   32 +-
 31 files changed, 2271 insertions(+), 71 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/thermal/thermal.txt
 create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
 create mode 100644 drivers/thermal/int3403_thermal.c
 create mode 100644 drivers/thermal/of-thermal.c
 create mode 100644 include/dt-bindings/thermal/thermal.h


