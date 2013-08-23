Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3HWWD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 18:03:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32885 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3HWWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 18:03:25 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <linux-pm@vger.kernel.org>, <rui.zhang@intel.com>
CC: <linux-kernel@vger.kernel.org>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/5] drivers: thermal: several fixes
Date: Fri, 23 Aug 2013 18:03:11 -0400
Message-ID: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

This is simple patch set with fixes on core thermal framework.
These fixes are a set of changes that I find needed that I
found during the process of attempting to describe thermal
data using device tree.

These patches touch several drivers, as there is an API change.
I have only compiled tested on other drivers. I have done
a runtime test on OMAP and DRA devices though.

Please feel free to perform your own test and report issues
if you find some.

All best,

Eduardo Valentin (5):
  thermal: hwmon: move hwmon support to single file
  drivers: thermal: parent virtual hwmon with thermal zone
  drivers: thermal: make usage of CONFIG_THERMAL_HWMON optional
  thermal: thermal_core: allow binding with limits on bind_params
  drivers: thermal: add check when unregistering cpu cooling

 Documentation/thermal/sysfs-api.txt                |  11 +-
 drivers/acpi/thermal.c                             |   6 +-
 drivers/platform/x86/acerhdf.c                     |   3 +-
 drivers/platform/x86/intel_mid_thermal.c           |   2 +-
 drivers/power/power_supply_core.c                  |   2 +-
 drivers/thermal/Kconfig                            |   9 +
 drivers/thermal/Makefile                           |   3 +
 drivers/thermal/armada_thermal.c                   |   2 +-
 drivers/thermal/cpu_cooling.c                      |   6 +-
 drivers/thermal/db8500_thermal.c                   |   2 +-
 drivers/thermal/dove_thermal.c                     |   2 +-
 drivers/thermal/exynos_thermal.c                   |   2 +-
 drivers/thermal/kirkwood_thermal.c                 |   2 +-
 drivers/thermal/rcar_thermal.c                     |   2 +-
 drivers/thermal/spear_thermal.c                    |   2 +-
 drivers/thermal/thermal_core.c                     | 287 ++-------------------
 drivers/thermal/thermal_hwmon.c                    | 269 +++++++++++++++++++
 drivers/thermal/thermal_hwmon.h                    |  49 ++++
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   2 +-
 drivers/thermal/x86_pkg_temp_thermal.c             |   2 +-
 include/linux/thermal.h                            |  12 +-
 21 files changed, 398 insertions(+), 279 deletions(-)
 create mode 100644 drivers/thermal/thermal_hwmon.c
 create mode 100644 drivers/thermal/thermal_hwmon.h

-- 
1.8.2.1.342.gfa7285d

