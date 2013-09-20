Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3ITS5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:57:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64654 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753518Ab3ITS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:57:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.12-rc2
Date: Fri, 20 Sep 2013 21:08:34 +0200
Message-ID: <3724780.tAvtize7I5@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.12-rc2

to receive ACPI and power management fixes for v3.12-rc2 with
top-most commit d831a00510b9d400bf62464d8b11b158941348e6

  Merge branch 'pm-cpufreq'

on top of commit 272b98c6455f00884f0350f775c5342358ebb73f

  Linux 3.12-rc1

These are fixes for cpufreq issues that have emerged after recent
changes and one fix for an older PCI/ACPI power management breakage.

Specifics:

 1) Four fixes for cpufreq regressions introduced by the changes that
    removed Device Tree parsing for CPU device nodes from cpufreq
    drivers from Sudeep KarkadaNagesha.

 2) Two fixes for recent cpufreq regressions introduced by changes
    related to the preservation of sysfs attributes over system
    suspend/resume cycles from Viresh Kumar.

 3) Fix for ACPI-based wakeup signaling in the PCI subsystem that
    fails to stop PME polling for devices put into the D3cold power
    state from yours truly.

 4) Fix for bad interactions between cpufreq and udev on systems
    supporting intel_pstate where acpi-cpufreq is available as well
    from Yinghai Lu.

Thanks!


---------------

Rafael J. Wysocki (1):
      PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup

Sudeep KarkadaNagesha (4):
      cpufreq: cpufreq-cpu0: assign cpu_dev correctly to cpu0 device
      cpufreq: imx6q-cpufreq: assign cpu_dev correctly to cpu0 device
      ARM: i.MX: change dev_id to cpu0 while registering cpu clock
      ARM: shmobile: change dev_id to cpu0 while registering cpu clock

Viresh Kumar (2):
      cpufreq: Clear policy->cpus bits in __cpufreq_remove_dev_finish()
      cpufreq: unlock correct rwsem while updating policy->cpu

Yinghai Lu (1):
      cpufreq: return EEXIST instead of EBUSY for second registering

---------------

 arch/arm/mach-imx/clk-imx27.c          |  2 +-
 arch/arm/mach-imx/clk-imx51-imx53.c    |  2 +-
 arch/arm/mach-imx/mach-imx6q.c         |  9 +++++++--
 arch/arm/mach-shmobile/clock-r8a73a4.c |  2 +-
 arch/arm/mach-shmobile/clock-sh73a0.c  |  2 +-
 drivers/cpufreq/cpufreq-cpu0.c         |  7 ++++++-
 drivers/cpufreq/cpufreq.c              | 31 ++++++++++++++++++++-----------
 drivers/cpufreq/imx6q-cpufreq.c        |  7 ++++++-
 drivers/pci/pci-acpi.c                 |  6 +++---
 9 files changed, 46 insertions(+), 22 deletions(-)

