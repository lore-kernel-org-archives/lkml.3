Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3ICNSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:18:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46662 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab3ICNSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:18:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] soc-thermal: fixes on 3.12
Date: Tue, 3 Sep 2013 09:18:32 -0400
Message-ID: <1378214312-30788-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Rui,

Please consider this pull request. It contains:
- Fixes on TI-SoC-Thermal driver
- Fixes on Exynos driver
- Fixes on core thermal driver
- Reordanization of hwmon layer inside thermal driver (no functional change)


All best,

The following changes since commit f61d5b4d52e077756ce9dbc47ce737da898ad01d:

  Merge branch 'fixes' of .git into next (2013-08-15 15:49:30 +0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git next

for you to fetch changes up to 50e66c7ed8a1cd7e933628f9f5cf2617394adf5a:

  drivers: thermal: add check when unregistering cpu cooling (2013-09-03 09:10:34 -0400)

----------------------------------------------------------------
Eduardo Valentin (5):
      thermal: hwmon: move hwmon support to single file
      drivers: thermal: parent virtual hwmon with thermal zone
      drivers: thermal: make usage of CONFIG_THERMAL_HWMON optional
      thermal: thermal_core: allow binding with limits on bind_params
      drivers: thermal: add check when unregistering cpu cooling

Ranganath Krishnan (3):
      thermal: ti-soc-thermal: Initialize counter_delay field for TI DRA752 sensors
      thermal: ti-soc-thermal: Set the bandgap mask counter delay value
      thermal: ti-soc-thermal: Ensure to compute thermal trend

Sachin Kamat (3):
      thermal: exynos: Fix typos in Kconfig
      thermal: exynos: Fix potential NULL pointer dereference
      thermal: exynos: Clean up non-DT remnants

 Documentation/thermal/sysfs-api.txt                |  12 +
 drivers/thermal/Kconfig                            |   9 +
 drivers/thermal/Makefile                           |   3 +
 drivers/thermal/cpu_cooling.c                      |   6 +-
 drivers/thermal/samsung/Kconfig                    |  12 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |   6 +-
 drivers/thermal/samsung/exynos_tmu.c               |  30 +--
 drivers/thermal/thermal_core.c                     | 282 ++-------------------
 drivers/thermal/thermal_hwmon.c                    | 269 ++++++++++++++++++++
 drivers/thermal/thermal_hwmon.h                    |  49 ++++
 .../thermal/ti-soc-thermal/dra752-thermal-data.c   |   5 +
 drivers/thermal/ti-soc-thermal/ti-bandgap.c        |   6 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   7 +
 include/linux/thermal.h                            |  18 ++
 14 files changed, 424 insertions(+), 290 deletions(-)
 create mode 100644 drivers/thermal/thermal_hwmon.c
 create mode 100644 drivers/thermal/thermal_hwmon.h
