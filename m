Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3EYTzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:55:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51108 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757763Ab3EYTzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:55:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] Power management and ACPI fixes for v3.10-rc3
Date: Sat, 25 May 2013 22:04:06 +0200
Message-ID: <7077400.RbAansdZvT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.10-rc3

to receive power management and ACPI fixes for v3.10-rc3 with top-most
commit 5a2bff8d7c7f63e2e8d467f66f6492fbb4d9509c

  Merge branch 'pm-cpufreq'

on top of commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75

  Linux 3.10-rc2

Included are:

- Additional CPU ID for the intel_pstate driver from Dirk Brandewie.

- More cpufreq fixes related to ARM big.LITTLE support and locking from
  Viresh Kumar.

- VIA C7 cpufreq build fix from Rafał Bilski.

- ACPI power management fix making it possible to use device power
  states regardless of the CONFIG_PM setting (which was possible
  before 3.9) from yours truly.

- New ACPI video blacklist item from Bastian Triller.

Thanks!


---------------

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Dirk Brandewie (1):
      cpufreq / intel_pstate: Add additional supported CPU ID

Rafael J. Wysocki (1):
      ACPI / PM: Allow device power states to be used for CONFIG_PM unset

Rafał Bilski (1):
      cpufreq / e_powersaver: Fix linker error when ACPI processor is a module

Viresh Kumar (3):
      cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT
      cpufreq: arm_big_little_dt: Register driver only if DT has valid data
      cpufreq: arm_big_little_dt: Instantiate as platform_driver

---------------

 drivers/acpi/Makefile               |    2 +-
 drivers/acpi/device_pm.c            |  126 ++++++++++++++++++++++---------------------
 drivers/acpi/video_detect.c         |    8 +++
 drivers/cpufreq/Kconfig.x86         |    2 +-
 drivers/cpufreq/arm_big_little_dt.c |   93 +++++++++++++++++++-------------
 drivers/cpufreq/cpufreq.c           |    9 +++-
 drivers/cpufreq/intel_pstate.c      |    1 +
 include/acpi/acpi_bus.h             |   40 ++------------
 8 files changed, 144 insertions(+), 137 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
