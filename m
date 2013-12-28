Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3L1AlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 19:41:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63633 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751659Ab3L1AlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 19:41:12 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes and new device IDs for v3.13-rc6
Date: Sat, 28 Dec 2013 01:54:44 +0100
Message-ID: <6028840.QzJRjqMWxJ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.13-rc6

to receive fixes and some new device IDs for ACPI and power management
with top-most commit bfde19c4c2467cbcb5c11ec0fdaa771b8c16cbce

  Merge branches 'powercap' and 'acpi-lpss' with new device IDs

on top of commit 413541dd66d51f791a0b169d9b9014e4f56be13c

  Linux 3.13-rc5

These include a fix for a cpufreq regression related to system suspend
(more fixes in this area are in the works), a fix for an older cpufreq
bug, a fix for a memory leak in the system suspend console handling
code and new device IDs for two drviers.

Specifics:

- Fix for a cpufreq regression causing stale sysfs files to be left
  behind during system resume if cpufreq_add_dev() fails for one or
  more CPUs from Viresh Kumar.

- Fix for a bug in cpufreq causing CONFIG_CPU_FREQ_DEFAULT_* to be
  ignored when the intel_pstate driver is used from Jason Baron.

- System suspend fix for a memory leak in pm_vt_switch_unregister()
  that forgot to release objects after removing them from
  pm_vt_switch_list.  From Masami Ichikawa.

- Intel Valley View device ID and energy unit encoding update for the
  (recently added) Intel RAPL (Running Average Power Limit) driver
  from Jacob Pan.

- Intel Bay Trail SoC GPIO and ACPI device IDs for the Low Power
  Subsystem (LPSS) ACPI driver from Paul Drews.

Thanks!


---------------

Jacob Pan (1):
      powercap / RAPL: add support for ValleyView Soc

Jason Baron (1):
      cpufreq: Use CONFIG_CPU_FREQ_DEFAULT_* to set initial policy for setpolicy drivers

Masami Ichikawa (1):
      PM / sleep: Fix memory leak in pm_vt_switch_unregister().

Paul Drews (1):
      ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs

Viresh Kumar (1):
      cpufreq: remove sysfs files for CPUs which failed to come back after resume

---------------

 drivers/acpi/acpi_lpss.c           |  1 +
 drivers/cpufreq/cpufreq.c          | 69 ++++++++++++++++++++------------------
 drivers/pinctrl/pinctrl-baytrail.c |  1 +
 drivers/powercap/intel_rapl.c      | 13 +++++--
 kernel/power/console.c             |  1 +
 5 files changed, 51 insertions(+), 34 deletions(-)

