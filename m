Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbaBURQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:16:16 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47578 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaBURQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:16:13 -0500
MIME-Version: 1.0
Date: Fri, 21 Feb 2014 18:16:10 +0100
Message-ID: <CAJZ5v0jZrD+jML2hT7v=gYog1TuXK-VK2DjoPthNbMpoPxnbmg@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.14-rc4
From: Rafael Wysocki <rjwysocki@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.14-rc4

to receive ACPI and power management fixes for v3.14-rc4
with top-most commit fee5ae96e0bc48b13f97512aef91d5aea60240a5

  Merge branch 'pm-cpufreq'

on top of commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2

  Linux 3.14-rc3

These include two fixes for recent regressions related to ACPI, a
cpufreq fix for breakage overlooked by a previous fix commit, two
intel_pstate fixes for stuff added during the 3.13 cycle that need
to go into -stable, three fixes for older bugs that also are -stable
candidates, ACPI video blacklist changes related to BIOSes that
behave in a special way on Windows 8, several build fixes for
CONFIG_PM_SLEEP unset in ACPI drivers and an ACPI driver
cleanup.

Specifics:

 - Fix for a recent probing regression in the nouveau driver introduced
   by an ACPI change related to the handling of _DSM from Jiang Liu.

 - Fix for a dock station sysfs attribute that stopped working correctly
   after recent changes in the ACPI core.

 - cpufreq fix taking care of broken code related to CPU removal and
   overlooked by a previous recent fix in that area.  From Viresh Kumar.

 - Two intel_pstate fixes related to Baytrail support added during
   the 3.13 cycle (candidates for -stable) from Dirk Brandewie.

 - ACPI video fix removing duplicate brightness values from the _BCL
   table which makes its user space interface behave sanely.  From
   Hans de Goede.

 - Fix for the powernow-k8 cpufreq driver making it initialize its
   per-CPU data structures correctly from Srivatsa S. Bhat.

 - Fix for an obscure memory leak in the ACPI PCI interrupt allocation
   code (related to ISA) from Tomasz Nowicki.

 - ACPI video blacklist changes moving several systems that should
   use the native backlight interface instead of the ACPI one from
   the general ACPI _OSI blacklist the the ACPI video driver's
   blacklist where they belong.  This consists of an ACPI video
   driver update from Aaron Lu and a revert of a previous commit
   adding systems to the ACPI _OSI blacklist requested by
   Takashi Iwai.  All of that has been tested by the involved
   reporters and should not cause any fallout to happen.

 - Several fixes for build issues in ACPI drivers occuring when
   CONFIG_PM_SLEEP is unset from Shuah Khan.

 - Fix for an sscanf() format string in the ACPI Smart Battery
   Subsystem (SBS) driver from Luis G.F.

Thanks!


---------------

Aaron Lu (1):
      ACPI / video: Add systems that should favour native backlight interface

Dirk Brandewie (2):
      intel_pstate: Use LFM bus ratio as min ratio/P state
      intel_pstate: Add support for Baytrail turbo P states

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Jiang Liu (1):
      ACPI / nouveau: fix probing regression related to _DSM

Luis G.F (1):
      ACPI / SBS: Fix incorrect sscanf() string

Rafael J. Wysocki (2):
      ACPI / dock: Make 'docked' sysfs attribute work as documented
      Revert "ACPI: Blacklist Win8 OSI for some HP laptop 2013 models"

Shuah Khan (6):
      ACPI / AC: fix AC driver compile error when CONFIG_PM_SLEEP is undefined
      ACPI / battery: fix battery driver compile error when
CONFIG_PM_SLEEP is undefined
      ACPI / button: fix button driver compile error when
CONFIG_PM_SLEEP is undefined
      ACPI / fan: fix fan driver compile error when CONFIG_PM_SLEEP is undefined
      ACPI / SBS: fix SBS driver compile error when CONFIG_PM_SLEEP is undefined
      ACPI / thermal: fix thermal driver compile error when
CONFIG_PM_SLEEP is undefined

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Tomasz Nowicki (1):
      ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Viresh Kumar (1):
      cpufreq: remove sysfs link when a cpu != policy->cpu, is removed

---------------

 drivers/acpi/ac.c                      |   2 +
 drivers/acpi/battery.c                 |   2 +
 drivers/acpi/blacklist.c               |  58 -------------
 drivers/acpi/button.c                  |   2 +
 drivers/acpi/dock.c                    |   8 +-
 drivers/acpi/fan.c                     |   3 +
 drivers/acpi/pci_irq.c                 |   1 +
 drivers/acpi/sbs.c                     |   4 +-
 drivers/acpi/thermal.c                 |   2 +
 drivers/acpi/video.c                   | 147 +++++++++++++++++++++++++++++++--
 drivers/acpi/video_detect.c            |  16 ----
 drivers/cpufreq/cpufreq.c              |   3 +-
 drivers/cpufreq/intel_pstate.c         |  17 +++-
 drivers/cpufreq/powernow-k8.c          |  10 ++-
 drivers/gpu/drm/nouveau/nouveau_acpi.c |  26 +++++-
 15 files changed, 204 insertions(+), 97 deletions(-)
