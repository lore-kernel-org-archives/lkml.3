Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaJXMiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:38:20 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49333 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbaJXMiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:38:18 -0400
MIME-Version: 1.0
Date: Fri, 24 Oct 2014 14:38:17 +0200
X-Google-Sender-Auth: 2TAGjggWshGK9ffM0WGixfoQ3xE
Message-ID: <CAJZ5v0jo9hABMsOC0JUi=A+Sxj9g_JP3fMX5_Gj+pEkeAeQ3yQ@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management updates for 3.18-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.18-rc2

to receive ACPI and power management updates for v3.18-rc2 with
top-most commit a91e99e27a683608d221fb18b70d7de9d801de4a

 Merge branches 'pm-cpuidle' and 'pm-cpufreq'

on top of commit f114040e3ea6e07372334ade75d1ee0775c355e1

 Linux 3.18-rc1

This is material that didn't make it to my 3.18-rc1 pull request
for various reasons, mostly related to timing and travel
(LinuxCon EU / LPC) plus a couple of fixes for recent bugs.
The only really new thing here is the PM QoS class for memory
bandwidth, but it is simple enough and users of it will be added
in the next cycle.  One major change in behavior is that platform
devices enumerated by ACPI will use 32-bit DMA mask by default.
Also included is an ACPICA update to a new upstream release,
but that's mostly cleanups, changes in tools and similar.  The
rest is fixes and cleanups mostly.

Specifics:

 - Fix for a recent PCI power management change that overlooked
   the fact that some IRQ chips might not be able to configure
   PCIe PME for system wakeup from Lucas Stach.

 - Fix for a bug introduced in 3.17 where acpi_device_wakeup()
   is called with a wrong ordering of arguments from Zhang Rui.

 - A bunch of intel_pstate driver fixes (all -stable candidates)
   from Dirk Brandewie, Gabriele Mazzotta and Pali Rohár.

 - Fixes for a rather long-standing problem with the OOM killer
   and the freezer that frozen processes killed by the OOM do
   not actually release any memory until they are thawed, so
   OOM-killing them is rather pointless, with a couple of
   cleanups on top (Michal Hocko, Cong Wang, Rafael J Wysocki).

 - ACPICA update to upstream release 20140926, inlcuding mostly
   cleanups reducing differences between the upstream ACPICA and
   the kernel code, tools changes (acpidump, acpiexec) and
   support for the _DDN object (Bob Moore, Lv Zheng).

 - New PM QoS class for memory bandwidth from Tomeu Vizoso.

 - Default 32-bit DMA mask for platform devices enumerated by ACPI
   (this change is mostly needed for some drivers development in
   progress targeted at 3.19) from Heikki Krogerus.

 - ACPI EC driver cleanups, mostly related to debugging, from
   Lv Zheng.

 - cpufreq-dt driver updates from Thomas Petazzoni.

 - powernv cpuidle driver update from Preeti U Murthy.

Thanks!


---------------

Bob Moore (4):
      ACPICA: Add string for _DDN method name.
      ACPICA: iASL/Disassembler: Add support for hardware summary mapfiles.
      ACPICA: acpiexec: Do not put STDIN into raw mode unless it is a terminal.
      ACPICA: Update version to 20140926.

Cong Wang (2):
      freezer: Do not freeze tasks killed by OOM killer
      freezer: remove obsolete comments in __thaw_task()

Dirk Brandewie (4):
      cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
      intel_pstate: Don't lose sysfs settings during cpu offline
      intel_pstate: Fix BYT frequency reporting
      intel_pstate: Correct BYT VID values.

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Reflect current no_turbo state correctly

Heikki Krogerus (1):
      ACPI / platform: provide default DMA mask

Lucas Stach (1):
      PCI / PM: handle failure to enable wakeup on PCIe PME

Lv Zheng (11):
      ACPICA: acpidump: Add ACPI 1.0 RSDP support.
      ACPICA: Events: Reduce indent divergences of events files.
      ACPICA: Events: Reduce source code difference in
acpi_install_gpe_handler().
      ACPICA: Events: Update GPE handler removal, match behavior of
handler install.
      ACPICA: Events: Reduce source code difference for the
ACPI_EVENT_FLAG_HANDLE support.
      ACPICA: Events: Reduce source code difference for the
ACPI_EVENT_FLAG_HANDLE renaming.
      ACPI / EC: Add CPU ID to debugging messages.
      ACPI / EC: Enhance the logs to apply to QR_EC transactions.
      ACPI / EC: Add detailed command/query debugging information.
      ACPI / EC: Refine event/query debugging messages.
      ACPI / EC: Cleanup coding style.

Michal Hocko (2):
      OOM, PM: OOM killed task shouldn't escape PM suspend
      PM: convert do_each_thread to for_each_process_thread

Pali Rohár (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Preeti U. Murthy (1):
      cpuidle: powernv: Populate cpuidle state details by querying the
device-tree

Rafael J. Wysocki (1):
      PM / freezer: Clean up code after recent fixes

Thomas Petazzoni (3):
      cpufreq: allow driver-specific data
      cpufreq: cpufreq-dt: extend with platform_data
      cpufreq: cpufreq-dt: adjust message related to regulators

Tomeu Vizoso (1):
      PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class

Zhang Rui (1):
      ACPI: invoke acpi_device_wakeup() with correct parameters

---------------

 Documentation/power/pm_qos_interface.txt           |   4 +-
 drivers/acpi/acpi_platform.c                       |   2 +
 drivers/acpi/acpica/achware.h                      |   2 +-
 drivers/acpi/acpica/aclocal.h                      |   4 +-
 drivers/acpi/acpica/actables.h                     |   2 +
 drivers/acpi/acpica/amlresrc.h                     |  34 +++++++
 drivers/acpi/acpica/evgpe.c                        |  23 ++---
 drivers/acpi/acpica/evgpeinit.c                    |   1 +
 drivers/acpi/acpica/evxface.c                      |  27 +++--
 drivers/acpi/acpica/evxfevnt.c                     |  40 +++++---
 drivers/acpi/acpica/evxfgpe.c                      |  12 +--
 drivers/acpi/acpica/hwgpe.c                        |   9 +-
 drivers/acpi/acpica/tbxfroot.c                     |  33 ++++++-
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/acpi/ec.c                                  | 107 +++++++++++++-------
 drivers/acpi/scan.c                                |   2 +-
 drivers/acpi/sysfs.c                               |   4 +-
 drivers/cpufreq/cpufreq-dt.c                       |  21 +++-
 drivers/cpufreq/cpufreq.c                          |  38 +++++--
 drivers/cpufreq/intel_pstate.c                     | 110 ++++++++++++++++-----
 drivers/cpuidle/cpuidle-powernv.c                  |  27 ++++-
 drivers/pci/pcie/pme.c                             |   6 +-
 include/acpi/acnames.h                             |   1 +
 include/acpi/acpixf.h                              |   2 +-
 include/acpi/actypes.h                             |   4 +-
 include/linux/cpufreq-dt.h                         |  22 +++++
 include/linux/cpufreq.h                            |   2 +
 include/linux/oom.h                                |   3 +
 include/linux/pm_qos.h                             |   5 +-
 kernel/freezer.c                                   |   9 +-
 kernel/power/process.c                             |  57 +++++++++--
 kernel/power/qos.c                                 |  27 ++++-
 mm/oom_kill.c                                      |  17 ++++
 mm/page_alloc.c                                    |   8 ++
 .../acpi/os_specific/service_layers/osunixxf.c     |   8 ++
 tools/power/acpi/tools/acpidump/apdump.c           |   2 +-
 36 files changed, 527 insertions(+), 150 deletions(-)
