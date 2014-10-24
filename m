Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaJXHaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:30:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:24524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaJXHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:30:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="405255944"
Message-ID: <1414135811.16559.4.camel@rzhang1-toshiba>
Subject: [GIT PULL] Thermal management updates for 3.18-rc2
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 24 Oct 2014 15:30:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Sorry that I missed the merge window as there is a bug found in the last
minute, and I have to fix it and wait for the code to be tested in
linux-next tree for a few days. Now the buggy patch has been dropped
entirely from my next branch. Thus I hope those changes can still be
merged in 3.18-rc2 as most of them are platform thermal driver changes.

Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next
to receive Thermal Management updates for 3.18-rc2 with top-most commit

6ceaf58abe25e86292152005c51169796bad3407:

  Merge branch 'int340x-thermal' of .git into next (2014-10-17 14:30:58
+0800)

on top of commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)


Specifics:

- introduce ACPI INT340X thermal drivers. Newer laptops and tablets may
have thermal sensors and other devices with thermal control capabilities
that are exposed for the OS to use via the ACPI INT340x device objects.
Several drivers are introduced to expose the temperature information and
cooling ability from these objects to user-space via the normal thermal
framework. From: Lu Aaron, Lan Tianyu, Jacob Pan and Zhang Rui.

- introduce a new thermal governor, which just uses a hysteresis to
switch abruptly on/off a cooling device. This governor can be used to
control certain fan devices that can not be throttled but just switched on or
off. From: Peter Feuerer.

- introduce support for some new thermal interrupt functions on i.MX6SX,
in IMX thermal driver. From: Anson, Huang.

- introduce tracing support on thermal framework. From: Punit Agrawal.

- small fixes in OF thermal and thermal step_wise governor.

thanks,
rui

----------------------------------------------------------------

Aaron Lu (8):
      ACPI / fan: remove unused macro
      ACPI / fan: remove no need check for device pointer
      ACPI / fan: use acpi_device_xxx_power instead of acpi_bus
equivelant
      ACPI / fan: convert to platform driver
      ACPI / Fan: add ACPI 4.0 style fan support
      ACPI / Fan: support INT3404 thermal device
      Thermal: move the KELVIN_TO_MILLICELSIUS macro to thermal.h
      Thermal: introduce INT3402 thermal driver

Anson Huang (1):
      Thermal: imx: add i.mx6sx thermal support

Jacob Pan (2):
      Thermal: int340x_thermal: expose acpi thermal relationship tables
      Thermal: int3400_thermal: use acpi_thermal_rel parsing APIs

Lan Tianyu (1):
      Thermal: introduce int3403 thermal driver

Laxman Dewangan (1):
      thermal: add support to disable thermal zone from DTS

Lukasz Majewski (1):
      thermal: step_wise: fix: Prevent from binary overflow when trend
is dropping

Peter Feuerer (1):
      thermal: Added Bang-bang thermal governor

Punit Agrawal (3):
      thermal: trace: Trace temperature changes
      thermal: trace: Trace when a cooling device's state is updated
      thermal: trace: Trace when temperature is above a trip point

Zhang Rui (11):
      Merge branch 'next' of
git://git.kernel.org/.../evalenti/linux-soc-thermal into eduardo-soc
      ACPI: introduce ACPI int340x thermal scan handler
      Merge branches 'eduardo-soc' and 'bang-bang-governor' of .git into
next
      ACPI: make acpi_create_platform_device() an external API
      ACPI: add ACPI_TYPE_LOCAL_REFERENCE support to
acpi_extract_package()
      Thermal: introduce int3400 thermal driver
      Thermal: int3400 thermal: add capability to detect supporting
UUIDs
      Thermal: int3400 thermal: register to thermal framework
      Merge branch 'thermal-core-fix' of .git into next
      Thermal: int340x thermal: select ACPI fan driver
      Merge branch 'int340x-thermal' of .git into next

 Documentation/devicetree/bindings/thermal/imx-thermal.txt |   5 +-
 drivers/acpi/Kconfig                                      |   2 +-
 drivers/acpi/Makefile                                     |   1 +
 drivers/acpi/acpi_platform.c                              |   1 +
 drivers/acpi/device_pm.c                                  |   1 +
 drivers/acpi/fan.c                                        | 341
++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/acpi/int340x_thermal.c                            |  51
+++++++++
 drivers/acpi/internal.h                                   |  10 +-
 drivers/acpi/scan.c                                       |   1 +
 drivers/acpi/thermal.c                                    |  18 +--
 drivers/acpi/utils.c                                      |  28 ++++-
 drivers/thermal/Kconfig                                   |  49
+++++---
 drivers/thermal/Makefile                                  |   3 +-
 drivers/thermal/fair_share.c                              |  12 ++
 drivers/thermal/gov_bang_bang.c                           | 131
+++++++++++++++++++++
 drivers/thermal/imx_thermal.c                             |  91
++++++++++++---
 drivers/thermal/int3403_thermal.c                         | 296
------------------------------------------------
 drivers/thermal/int340x_thermal/Makefile                  |   4 +
 drivers/thermal/int340x_thermal/acpi_thermal_rel.c        | 400
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/int340x_thermal/acpi_thermal_rel.h        |  84
++++++++++++++
 drivers/thermal/int340x_thermal/int3400_thermal.c         | 271
++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/int340x_thermal/int3402_thermal.c         | 242
+++++++++++++++++++++++++++++++++++++++
 drivers/thermal/int340x_thermal/int3403_thermal.c         | 477
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/of-thermal.c                              |  12 ++
 drivers/thermal/step_wise.c                               |   7 +-
 drivers/thermal/thermal_core.c                            |  12 ++
 drivers/thermal/thermal_core.h                            |   8 ++
 include/acpi/acpi_bus.h                                   |   1 +
 include/linux/acpi.h                                      |   1 +
 include/linux/thermal.h                                   |   4 +
 include/trace/events/thermal.h                            |  83
++++++++++++++
 31 files changed, 2223 insertions(+), 424 deletions(-)
 create mode 100644 drivers/acpi/int340x_thermal.c
 create mode 100644 drivers/thermal/gov_bang_bang.c
 delete mode 100644 drivers/thermal/int3403_thermal.c
 create mode 100644 drivers/thermal/int340x_thermal/Makefile
 create mode 100644 drivers/thermal/int340x_thermal/acpi_thermal_rel.c
 create mode 100644 drivers/thermal/int340x_thermal/acpi_thermal_rel.h
 create mode 100644 drivers/thermal/int340x_thermal/int3400_thermal.c
 create mode 100644 drivers/thermal/int340x_thermal/int3402_thermal.c
 create mode 100644 drivers/thermal/int340x_thermal/int3403_thermal.c
 create mode 100644 include/trace/events/thermal.h



