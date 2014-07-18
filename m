Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbaGRLlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:41:21 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37544 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965231AbaGRLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:41:17 -0400
MIME-Version: 1.0
Date: Fri, 18 Jul 2014 13:41:16 +0200
X-Google-Sender-Auth: SqXwOCNHTq2kZG3fDEbzUhxFKkI
Message-ID: <CAJZ5v0i00u1AQgXzGFpkEK7EL0_bY5+TqFRBRmuivMByPAZvsg@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.16-rc6
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
 pm+acpi-3.16-rc6

to receive ACPI and power management fixes for v3.16-rc6
with top-most commit 3962808023d54f0e1adbde403eb8e572984ccb2a

 Merge branches 'pm-sleep' and 'pm-cpufreq'

on top of commit 1795cd9b3a91d4b5473c97f491d63892442212ab

 Linux 3.16-rc5

These are a few recent regression fixes, a revert of the ACPI video
commit I promised, a system resume fix related to request_firmware(),
an ACPI video quirk for one more Win8-oriented BIOS, an ACPI device
enumeration documentation update and a few fixes for ARM cpufreq
drivers.

Specifics:

 - Fix for a recently introduced NULL pointer dereference in the core
   system suspend code occuring when platforms without ACPI attempt to
   use the "freeze" sleep state from Zhang Rui.

 - Fix for a recently introduced build warning in cpufreq headers from
   Brian W Hart.

 - Fix for a 3.13 cpufreq regression related to sysem resume that
   triggers on some systems with multiple CPU clusters from Viresh Kumar.

 - Fix for a 3.4 regression in request_firmware() resulting in
   WARN_ON()s on some systems during system resume from Takashi Iwai.

 - Revert of the ACPI video commit that changed the default value of
   the video.brightness_switch_enabled command line argument to 0 as
   it has been reported to break existing setups.

 - ACPI device enumeration documentation update to take recent code
   changes into account and make the documentation match the code again
   from Darren Hart.

 - Fixes for the sa1110, imx6q, kirkwood, and cpu0 cpufreq drivers
   from Linus Walleij, Nicolas Del Piano, Quentin Armitage, Viresh Kumar.

 - New ACPI video blacklist entry for HP ProBook 4540s from Hans de Goede.

Thanks!


---------------

Brian W Hart (1):
      cpufreq: make table sentinel macros unsigned to match use

Darren Hart (1):
      ACPI / documentation: Remove reference to
acpi_platform_device_ids from enumeration.txt

Hans de Goede (1):
      ACPI / video: Add use_native_backlight quirk for HP ProBook 4540s

Linus Walleij (1):
      cpufreq: sa1110: set memory type for h3600

Nicolas Del Piano (1):
      cpufreq: imx6q: Select PM_OPP

Quentin Armitage (1):
      cpufreq: kirkwood: Reinstate cpufreq driver for ARCH_KIRKWOOD

Rafael J. Wysocki (1):
      Revert "ACPI / video: change acpi-video
brightness_switch_enabled default to 0"

Takashi Iwai (1):
      PM / sleep: Fix request_firmware() error at resume

Viresh Kumar (2):
      cpufreq: cpu0: OPPs can be populated at runtime
      cpufreq: move policy kobj to policy->cpu at resume

Zhang Rui (1):
      PM / sleep: fix freeze_ops NULL pointer dereferences

---------------

 Documentation/acpi/enumeration.txt                         |  6 ------
 Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt |  6 ++++--
 Documentation/kernel-parameters.txt                        |  2 +-
 drivers/acpi/video.c                                       | 10 +++++++++-
 drivers/cpufreq/Kconfig.arm                                |  3 ++-
 drivers/cpufreq/cpufreq-cpu0.c                             |  7 ++-----
 drivers/cpufreq/cpufreq.c                                  |  6 ++++--
 drivers/cpufreq/sa1110-cpufreq.c                           |  2 +-
 include/linux/cpufreq.h                                    |  4 ++--
 kernel/power/process.c                                     |  1 +
 kernel/power/suspend.c                                     |  4 ++--
 11 files changed, 28 insertions(+), 23 deletions(-)
