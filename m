Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaFKJQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:16:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:22958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbaFKJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:16:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,457,1400050800"; 
   d="scan'208";a="555621997"
Message-ID: <1402478161.15050.36.camel@rzhang1-toshiba>
Subject: [GIT PULL] Thermal Management updates for v3.16-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Wed, 11 Jun 2014 17:16:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

to receive Thermal management updates for v3.16-rc1 with
top-most commit 63745aa72ed16154b82a0c9ed22a88001d6ea0fa:

  Merge branches 'armada-375-380-soc-support',
'eduardo-thermal-soc-fixes', 'intel-soc-dts-thermal' and
'thermal-soc-fixes' of .git into next (2014-05-15 17:18:02 +0800)

on top of commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

Specifics:

- fix a bug in Exynos thermal driver, which overwrites the hardware trip
  point threshold when updating software trigger levels and results in
  emergency shutdown. From: Tushar Behera.

- add thermal sensor support for Armada 375 and 38x SoCs. From Ezequiel
  Garcia.

- add TMU (Thermal Management Unit) support for Exynos5260 and
  Exynos5420 SoCs. From Naveen Krishna Chatradhi.

- add support for the additional digital temperature sensors in the
  Intel SoCs like Bay Trail. From: Srinivas Pandruvada.

- a couple of cleanups and small fixes from Jingoo Han, Bartlomiej
  Zolnierkiewicz, Geert Uytterhoeven, Jacob Pan, Paul Walmsley and
  Lan,Tianyu.
 
----------------------------------------------------------------

Bartlomiej Zolnierkiewicz (1):
      thermal: offer Samsung thermal support only when ARCH_EXYNOS is
defined

Ezequiel Garcia (7):
      thermal: armada: Rename armada_thermal_ops struct
      thermal: armada: Add infrastructure to support generic formulas
      thermal: armada: Add generic infrastructure to handle the sensor
      thermal: armada: Pass the platform_device to init_sensor()
      thermal: armada: Allow to specify an 'inverted readout' sensor
      thermal: armada: Support Armada 375 SoC
      thermal: armada: Support Armada 380 SoC

Geert Uytterhoeven (1):
      thermal: rcar: Use pm_runtime_put() i.s.o. pm_runtime_put_sync()

Jacob Pan (1):
      thermal/intel_powerclamp: add newer cpu ids

Jingoo Han (3):
      thermal: rcar: remove unnecessary OOM messages
      thermal: exynos: remove unnecessary OOM messages
      thermal: spear: remove unnecessary OOM messages

Naveen Krishna Chatradhi (4):
      thermal: samsung: replace inten_ bit fields with intclr_
      thermal: samsung: change base_common to more meaningful
base_second
      thermal: samsung: Add TMU support for Exynos5420 SoCs
      thermal: samsung: Add TMU support for Exynos5260 SoCs

Paul Walmsley (1):
      thermal: ti-soc-thermal: clk_round_rate() can return a zero upon
error

Srinivas Pandruvada (1):
      thermal: Intel SoC DTS thermal

Tushar Behera (1):
      thermal: samsung: Only update available threshold limits

Zhang Rui (2):
      Merge branch 'next' of
git://git.kernel.org/.../evalenti/linux-soc-thermal into
thermal-soc-fixes
      Merge branches 'armada-375-380-soc-support',
'eduardo-thermal-soc-fixes', 'intel-soc-dts-thermal' and
'thermal-soc-fixes' of .git into next

lan,Tianyu (1):
      Thermal/int3403: Fix thermal hysteresis unit conversion

 Documentation/devicetree/bindings/thermal/armada-thermal.txt |  12 +++-
 Documentation/devicetree/bindings/thermal/exynos-thermal.txt |  50
++++++++++++++-
 drivers/thermal/Kconfig                                      |  14 +++-
 drivers/thermal/Makefile                                     |   1 +
 drivers/thermal/armada_thermal.c                             | 158
+++++++++++++++++++++++++++++++++++++++------
 drivers/thermal/int3403_thermal.c                            |   8 ++-
 drivers/thermal/intel_powerclamp.c                           |   2 +
 drivers/thermal/intel_soc_dts_thermal.c                      | 479
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/rcar_thermal.c                               |   9 +--
 drivers/thermal/samsung/exynos_tmu.c                         |  86
+++++++++++++++++++------
 drivers/thermal/samsung/exynos_tmu.h                         |  23
++++---
 drivers/thermal/samsung/exynos_tmu_data.c                    | 211
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/thermal/samsung/exynos_tmu_data.h                    |  31
++++++++-
 drivers/thermal/spear_thermal.c                              |   4 +-
 drivers/thermal/ti-soc-thermal/ti-bandgap.c                  |   2 +-
 15 files changed, 1015 insertions(+), 75 deletions(-)
 create mode 100644 drivers/thermal/intel_soc_dts_thermal.c


