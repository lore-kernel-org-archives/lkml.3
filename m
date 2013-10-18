Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3JRTjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:39:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58736 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753891Ab3JRTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:39:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.12-rc6
Date: Fri, 18 Oct 2013 21:51:13 +0200
Message-ID: <2799827.4Qn62kYzMV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.12-rc6

to receive ACPI and power management fixes for v3.12-rc6 with
top-most commit 981984cbd09e41c05b4ec6260e3f68591354cd54

  Merge branch Merge branch 'acpi-fixes'

on top of commit 35f9162d67c3e20a82b4bd6ec538f3e9c14fb055

  Merge tag 'pm+acpi-3.12-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm

These fix a bug related to system suspend/resume in intel_pstate and fix it
up after a recent change, make a forgotten structure field change in one of
cpufreq drivers, remove a leftover reference to /proc/acpi/event in Kconfig
help, add a missing mutex unlock to an error code path in ACPI power resources
code and drop a pile of unuseful code related to power resources that causes
problems to happen on real systems.

Specifics:

 - intel_pstate fix for misbehavior after system resume if sysfs
   attributes are set in a specific way before the corresponding
   suspend from Dirk Brandewie.

 - A recent intel_pstate fix has no effect if unsigned long is 32-bit,
   so fix it up to cover that case as well.

 - The s3c64xx cpufreq driver was not updated when the index field of
   struct cpufreq_frequency_table was replaced with driver_data, so
   update it now.  From Charles Keepax.

 - The Kconfig help text for ACPI_BUTTON still refers to /proc/acpi/event
   that has been dropped recently, so modify it to remove that reference.
   From Krzysztof Mazur.

 - A Lan Tianyu's change adds a missing mutex unlock to an error code
   path in acpi_resume_power_resources().

 - Some code related to ACPI power resources, whose very purpose is
   questionable to put it lightly, turns out to cause problems to
   happen during testing on real systems, so remove it completely
   (we may revisit that in the future if there's a compelling enough
   reason).  From yours truly and Aaron Lu.

Thanks!


---------------

Aaron Lu (1):
      ATA / ACPI: remove power dependent device handling

Charles Keepax (1):
      cpufreq: s3c64xx: Rename index to driver_data

Dirk Brandewie (1):
      cpufreq / intel_pstate: Fix max_perf_pct on resume

Krzysztof Mazur (1):
      ACPI: remove /proc/acpi/event from ACPI_BUTTON help

Lan Tianyu (1):
      ACPI / power: Release resource_lock after acpi_power_get_state() return error

Rafael J. Wysocki (3):
      intel_pstate: Fix type mismatch warning
      ACPI / power: Drop automaitc resume of power resource dependent devices
      ACPI / PM: Drop two functions that are not used any more

---------------

 drivers/acpi/Kconfig              |    6 +--
 drivers/acpi/device_pm.c          |   56 --------------------
 drivers/acpi/power.c              |  104 ++-----------------------------------
 drivers/acpi/scan.c               |    1 -
 drivers/ata/libata-acpi.c         |   14 -----
 drivers/ata/libata-scsi.c         |    3 --
 drivers/ata/libata.h              |    4 --
 drivers/cpufreq/intel_pstate.c    |   14 ++---
 drivers/cpufreq/s3c64xx-cpufreq.c |    2 +-
 include/acpi/acpi_bus.h           |    7 ---
 10 files changed, 15 insertions(+), 196 deletions(-)

