Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaLRVJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:09:11 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45229 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLRVJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:09:08 -0500
MIME-Version: 1.0
Date: Thu, 18 Dec 2014 22:09:07 +0100
X-Google-Sender-Auth: ORb-oTf84So65OKGajihzEiQMUg
Message-ID: <CAJZ5v0hKnKSD2zX2kBZ6waA5b+WrXjmJ0w4HyrKw4GYwgTtSEg@mail.gmail.com>
Subject: [GIT PULL] More ACPI and power management updates for 3.19-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.19-rc1-2

to receive more ACPI and power management updates for v3.19-rc1 with
top-most commit 2ec1c17cadd0b994732f292d4bc49fc3a05d85a4

 Merge branches 'pm-opp', 'pm-cpufreq' and 'pm-tools'

on top of commit 92a578b064d0227a3a7fbbdb9e29dbab7f8d400e

 Merge tag 'pm+acpi-3.19-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm

These are regrssion fixes (leds-gpio, ACPI backlight driver, operating
performance points library, ACPI device enumeration messages, cpupower
tool), other bug fixes (ACPI EC driver, ACPI device PM), some cleanups
in the operating performance points (OPP) framework, continuation of
CONFIG_PM_RUNTIME elimination, a couple of minor intel_pstate driver
changes, a new MAINTAINERS entry for it and an ACPI fan driver change
needed for better support of thermal management in user space.

Specifics:

 - Fix a regression in leds-gpio introduced by a recent commit that
   inadvertently changed the name of one of the properties used by
   the driver (Fabio Estevam).

 - Fix a regression in the ACPI backlight driver introduced by a
   recent fix that missed one special case that had to be taken
   into account (Aaron Lu).

 - Drop the level of some new kernel messages from the ACPI core
   introduced by a recent commit to KERN_DEBUG which they should
   have used from the start and drop some other unuseful KERN_ERR
   messages printed by ACPI (Rafael J Wysocki).

 - Revert an incorrect commit modifying the cpupower tool
   (Prarit Bhargava).

 - Fix two regressions introduced by recent commits in the OPP
   library and clean up some existing minor issues in that code
   (Viresh Kumar).

 - Continue to replace CONFIG_PM_RUNTIME with CONFIG_PM throughout
   the tree (or drop it where that can be done) in order to make
   it possible to eliminate CONFIG_PM_RUNTIME (Rafael J Wysocki,
   Ulf Hansson, Ludovic Desroches).  There will be one more
   "CONFIG_PM_RUNTIME removal" batch after this one, because some
   new uses of it have been introduced during the current merge
   window, but that should be sufficient to finally get rid of it.

 - Make the ACPI EC driver more robust against race conditions
   related to GPE handler installation failures (Lv Zheng).

 - Prevent the ACPI device PM core code from attempting to
   disable GPEs that it has not enabled which confuses ACPICA
   and makes it report errors unnecessarily (Rafael J Wysocki).

 - Add a "force" command line switch to the intel_pstate driver
   to make it possible to override the blacklisting of some
   systems in that driver if needed (Ethan Zhao).

 - Improve intel_pstate code documentation and add a MAINTAINERS
   entry for it (Kristen Carlson Accardi).

 - Make the ACPI fan driver create cooling device interfaces
   witn names that reflect the IDs of the ACPI device objects
   they are associated with, except for "generic" ACPI fans
   (PNP ID "PNP0C0B").  That's necessary for user space thermal
   management tools to be able to connect the fans with the
   parts of the system they are supposed to be cooling properly.
   From Srinivas Pandruvada.

Thanks!


---------------

Aaron Lu (1):
      ACPI / video: update the skip case for acpi_video_device_in_dod()

Ethan Zhao (1):
      intel_pstate: add kernel parameter to force loading

Fabio Estevam (1):
      leds: leds-gpio: Fix the "default-state" property check

Kristen Carlson Accardi (2):
      intel_pstate: Add a few comments
      MAINTAINERS: add entry for intel_pstate

Ludovic Desroches (1):
      mmc: atmel-mci: use SET_RUNTIME_PM_OPS() macro

Lv Zheng (1):
      ACPI / EC: Fix unexpected ec_remove_handlers() invocations

Prarit Bhargava (1):
      Revert "tools: cpupower: fix return checks for
sysfs_get_idlestate_count()"

Rafael J. Wysocki (15):
      ACPI / scan: Change the level of _DEP-related messages to KERN_DEBUG
      ACPI / utils: Drop error messages from acpi_evaluate_reference()
      ACPI / PM: Do not disable wakeup GPEs that have not been enabled
      spi: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      tty / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      video / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      phy / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      sound / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      ARM / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      PM / Kconfig: Replace PM_RUNTIME with PM in dependencies
      x86 / PM: Replace CONFIG_PM_RUNTIME in io_apic.c
      tracing / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      SCSI / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      NFC / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
      power / PM: Eliminate CONFIG_PM_RUNTIME

Srinivas Pandruvada (1):
      ACPI / Fan: Use bus id as the name for non PNP0C0B (Fan) devices

Ulf Hansson (1):
      PM: Remove the SET_PM_RUNTIME_PM_OPS() macro

Viresh Kumar (7):
      PM / OPP: set new_opp->dev_opp to a valid dev_opp
      PM / OPP: remove double calls to find_device_opp()
      PM / OPP: replace kfree with kfree_rcu while freeing 'struct device_opp'
      PM / OPP: Staticize __dev_pm_opp_remove()
      PM / OPP: reuse find_device_opp() instead of duplicating code
      PM / OPP: handle allocation of device_opp in a separate routine
      PM / OPP: do error handling at the bottom of dev_pm_opp_add_dynamic()

---------------

 Documentation/kernel-parameters.txt       |  9 ++++
 MAINTAINERS                               |  6 +++
 arch/arm/kernel/perf_event.c              |  2 +-
 arch/arm/mach-davinci/pm_domain.c         |  2 +-
 arch/arm/mach-exynos/Kconfig              |  2 +-
 arch/arm/mach-keystone/pm_domain.c        |  2 +-
 arch/arm/mach-omap1/pm_bus.c              |  4 +-
 arch/arm/mach-omap2/io.c                  |  2 +-
 arch/arm/mach-omap2/omap_device.c         |  2 +-
 arch/ia64/Kconfig                         |  2 +-
 arch/x86/kernel/apic/io_apic.c            |  2 +-
 drivers/acpi/device_pm.c                  | 12 ++++-
 drivers/acpi/ec.c                         |  2 +
 drivers/acpi/fan.c                        |  8 +++-
 drivers/acpi/scan.c                       |  4 +-
 drivers/acpi/utils.c                      | 12 +----
 drivers/acpi/video.c                      | 10 +++-
 drivers/ata/Kconfig                       |  2 +-
 drivers/base/power/opp.c                  | 78 +++++++++++++++++--------------
 drivers/cpufreq/intel_pstate.c            | 38 ++++++++++++++-
 drivers/leds/leds-gpio.c                  |  2 +-
 drivers/media/platform/Kconfig            |  2 +-
 drivers/media/platform/s5p-tv/Kconfig     |  2 +-
 drivers/mmc/host/atmel-mci.c              |  2 +-
 drivers/nfc/trf7970a.c                    |  2 +-
 drivers/phy/phy-omap-usb2.c               |  2 +-
 drivers/phy/phy-ti-pipe3.c                |  2 +-
 drivers/power/pm2301_charger.c            |  4 --
 drivers/scsi/scsi_pm.c                    | 10 ----
 drivers/scsi/scsi_priv.h                  |  5 +-
 drivers/scsi/ufs/ufshcd-pci.c             | 11 ++---
 drivers/scsi/ufs/ufshcd-pltfrm.c          | 11 ++---
 drivers/spi/spi-coldfire-qspi.c           |  2 +-
 drivers/spi/spi-orion.c                   |  2 +-
 drivers/spi/spi-pxa2xx.c                  |  2 +-
 drivers/spi/spi-qup.c                     |  4 +-
 drivers/spi/spi-rockchip.c                |  4 +-
 drivers/spi/spi-s3c64xx.c                 |  4 +-
 drivers/staging/gdm72xx/Kconfig           |  2 +-
 drivers/tty/serial/8250/8250_dw.c         |  2 +-
 drivers/tty/serial/8250/8250_mtk.c        |  2 +-
 drivers/tty/serial/mfd.c                  |  7 +--
 drivers/tty/serial/msm_serial_hs.c        |  2 +-
 drivers/tty/serial/omap-serial.c          |  2 +-
 drivers/usb/core/Kconfig                  |  2 +-
 drivers/usb/phy/Kconfig                   |  4 +-
 drivers/usb/storage/Kconfig               |  2 +-
 drivers/video/fbdev/s3c-fb.c              |  2 +-
 drivers/video/fbdev/sh_mobile_meram.c     |  4 +-
 include/acpi/acpi_bus.h                   |  1 +
 include/linux/pm.h                        |  2 -
 include/scsi/scsi_device.h                |  4 +-
 kernel/trace/Makefile                     |  2 +-
 sound/pci/hda/hda_controller.c            |  2 +-
 sound/pci/hda/hda_intel.c                 |  5 +-
 sound/soc/codecs/cs35l32.c                |  2 +-
 sound/soc/codecs/cs42xx8.c                |  2 +-
 sound/soc/codecs/max98090.c               |  2 +-
 sound/soc/codecs/pcm512x.c                |  2 +-
 sound/soc/codecs/tas2552.c                |  4 +-
 sound/soc/codecs/wm2200.c                 |  2 +-
 sound/soc/codecs/wm5100.c                 |  2 +-
 sound/soc/codecs/wm8962.c                 |  2 +-
 sound/soc/fsl/fsl_asrc.c                  |  4 +-
 sound/soc/samsung/i2s.c                   |  4 +-
 tools/power/cpupower/utils/cpuidle-info.c |  8 ++--
 66 files changed, 199 insertions(+), 156 deletions(-)
