Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026Ab3DDVFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:05:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51453 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761144Ab3DDVFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:05:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.9-rc6
Date: Thu, 04 Apr 2013 23:13:17 +0200
Message-ID: <1903330.VdMMbXjxYW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.9-rc6

to receive ACPI and power management fixes for v3.9-rc6 with top-most commit
6cb437acd93a01fdbd6bac9c78ac8159c644e576

  Merge branch 'acpi-fixes' into fixes

on top of commit 07961ac7c0ee8b546658717034fe692fd12eefa9

  Linux 3.9-rc5

Included are:

- Revert of a recent cpuidle change that caused Nehalem machines
  to hang on boot from Alex Shi.

- USB power management fix addressing a crash in the port device
  object's release routine.

- Device PM QoS fix for a potential deadlock related to sysfs
  interface.

- Fix for a cpufreq crash when the /cpus Device Tree node is missing.
  From Paolo Pisati.

- Fix for a build issue on ia64 related to the fact that the
  Boot Graphics Resource Table (BGRT) is only useful on x86 with
  EFI.  From Tony Luck.

- Two fixes for ACPI handles being set incorrectly for device
  objects that don't correspond to any ACPI namespace nodes in
  the I2C and SPI subsystems.

- Fix for compiler warnings related to CONFIG_PM_DEVFREQ being
  unset from Rajagopal Venkat.

- Fix for a symbol definition typo in cpufreq_governor.h from
  Borislav Petkov.

Thanks!

---------------

Alex Shi (1):
      cpuidle / ACPI: recover percpu ACPI processor cstate

Borislav Petkov (1):
      cpufreq: Correct header guards typo

Paolo Pisati (1):
      cpufreq: check OF node /cpus presence before dereferencing it

Rafael J. Wysocki (4):
      USB / PM: Don't try to hide PM QoS flags from usb_port_device_release()
      PM / QoS: Avoid possible deadlock related to sysfs access
      ACPI / SPI: Use parent's ACPI_HANDLE() in acpi_register_spi_devices()
      ACPI / I2C: Use parent's ACPI_HANDLE() in acpi_i2c_register_devices()

Rajagopal Venkat (1):
      PM / devfreq: Fix compiler warnings for CONFIG_PM_DEVFREQ unset

Tony Luck (1):
      ACPI / BGRT: Don't let users configure BGRT on non X86 systems

---------------

 drivers/acpi/Kconfig                        |    2 +-
 drivers/acpi/acpi_i2c.c                     |    2 +-
 drivers/acpi/processor_idle.c               |   13 ++++----
 drivers/base/power/qos.c                    |   60 +++++++++++++++++++++++++++--------
 drivers/cpufreq/cpufreq-cpu0.c              |   10 ++++--
 drivers/cpufreq/cpufreq_governor.h          |    6 ++--
 drivers/i2c/busses/i2c-designware-platdrv.c |    1 -
 drivers/spi/spi-pxa2xx.c                    |    1 -
 drivers/spi/spi.c                           |    2 +-
 drivers/usb/core/port.c                     |    1 -
 include/linux/devfreq.h                     |   16 +++++-----
 11 files changed, 76 insertions(+), 38 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
