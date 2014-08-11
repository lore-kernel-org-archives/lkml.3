Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaHKF5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:57:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:33896 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaHKF5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="370701510"
Message-ID: <1407736621.2339.11.camel@rzhang1-toshiba>
Subject: [GIT PULL] thermal management updates for v3.17-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Aug 2014 13:57:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

please pull from 

 git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

to receive Thermal Management updates for v3.17-rc1 with top-most commit

47d104ba5879790c7c91c3390b0b08399e168efe:

  Merge branches 'exynos-fix', 'for-rc', 'int3403-fix', 'misc',
'rcar-thermal' and 'sti-thermal' of .git into next (2014-07-22 10:13:00
+0800)

on top of commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

Specifics:

- adds full support for 2 types of Thermal Controllers
produced by STMicroelectronics. One is a more traditional memory
mapped variant, the other is controlled solely by system configuration
registers. From: Lee Jones.

- add TMU (Thermal Management Unit) support for Exynos3250 Soc. From:
Chanwoo Choi.

- add critical and passive trip point support for int3403 thermal
driver. From: Srinivas Pandruvada.

- a couple of small fixes/cleanups from Javi Merino, and Geert
Uytterhoeven.

----------------------------------------------------------------

Bartlomiej Zolnierkiewicz (1):
      thermal: exynos: fix ordering in exynos_tmu_remove()

Chanwoo Choi (1):
      thermal: samsung: Add TMU support for Exynos3250 SoC

Geert Uytterhoeven (1):
      thermal: rcar: Document SoC-specific bindings

Javi Merino (2):
      thermal: cpu_cooling: fix typo highjack -> hijack
      thermal: document struct thermal_zone_device and thermal_governor

Lee Jones (4):
      thermal: sti: Supply Device Tree documentation
      thermal: sti: Introduce ST Thermal core code
      thermal: sti: Add support for ST's System Config Register based
Thermal controller
      thermal: sti: Add support for ST's Memory Mapped based Thermal
controller

Riku Voipio (1):
      thermal: allow building dove_thermal with mvebu

Srinivas Pandruvada (1):
      Thermal: int3403: Add CRT and PSV trip

Zhang Rui (1):
      Merge branches 'exynos-fix', 'for-rc', 'int3403-fix', 'misc',
'rcar-thermal' and 'sti-thermal' of .git into next

 Documentation/devicetree/bindings/thermal/exynos-thermal.txt |   1 +
 Documentation/devicetree/bindings/thermal/rcar-thermal.txt   |  18
+++++---
 Documentation/devicetree/bindings/thermal/st-thermal.txt     |  42
+++++++++++++++++++
 drivers/thermal/Kconfig                                      |   7 +++-
 drivers/thermal/Makefile                                     |   1 +
 drivers/thermal/cpu_cooling.c                                |   2 +-
 drivers/thermal/int3403_thermal.c                            |  67
+++++++++++++++++++++++++----
 drivers/thermal/samsung/exynos_tmu.c                         |  11
+++--
 drivers/thermal/samsung/exynos_tmu.h                         |   3 +-
 drivers/thermal/samsung/exynos_tmu_data.c                    |  89
+++++++++++++++++++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h                    |   7 ++++
 drivers/thermal/st/Kconfig                                   |  12
++++++
 drivers/thermal/st/Makefile                                  |   3 ++
 drivers/thermal/st/st_thermal.c                              | 313
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/st/st_thermal.h                              | 104
+++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/st/st_thermal_memmap.c                       | 209
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/st/st_thermal_syscfg.c                       | 179
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h                                      |  46
+++++++++++++++++++-
 18 files changed, 1093 insertions(+), 21 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/thermal/st-thermal.txt
 create mode 100644 drivers/thermal/st/Kconfig
 create mode 100644 drivers/thermal/st/Makefile
 create mode 100644 drivers/thermal/st/st_thermal.c
 create mode 100644 drivers/thermal/st/st_thermal.h
 create mode 100644 drivers/thermal/st/st_thermal_memmap.c
 create mode 100644 drivers/thermal/st/st_thermal_syscfg.c


