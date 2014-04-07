Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaDGLqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:46:34 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:52123 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaDGLqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:46:25 -0400
MIME-Version: 1.0
Date: Mon, 7 Apr 2014 13:46:23 +0200
X-Google-Sender-Auth: _PS4trCM-w-yT59hYT1Q_vuVFBg
Message-ID: <CAJZ5v0iyqzOhYw5+CyOtJMWSDsRaY2+fgh21B71RTdnKd0JKVg@mail.gmail.com>
Subject: [GIT PULL] CPU hotplug notifiers installation fixes for v3.15-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 cpu-hotplug-3.15-rc1

to receive CPU hotplug notifiers registration fixes for v3.15-rc1 with
top-most commit a0e247a8059223593f9c5c3d5c1fd50eedf415c0

 net/iucv/iucv.c: Fix CPU hotplug callback registration

on top of commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15

 Linux 3.14-rc7

The purpose of this single series of commits from Srivatsa S Bhat (with
a small piece from Gautham R Shenoy) touching multiple subsystems that use
CPU hotplug notifiers is to provide a way to register them that will not
lead to deadlocks with CPU online/offline operations as described in the
changelog of commit 93ae4f978ca7f (CPU hotplug: Provide lockless versions
of callback registration functions).

The first three commits in the series introduce the API and document it
and the rest simply goes through the users of CPU hotplug notifiers and
converts them to using the new method.

This work has been ACKed by several maintainers, no objections have been
raised against it, no one has proposed any viable alternative to it and
the problem addressed by it is real, so in my opinion there are no reasons
why it should not be merged.  It also has spent several days in linux-next
without causing any trouble known to me.

Thanks!


---------------

Gautham R. Shenoy (1):
      CPU hotplug: Add lockdep annotations to get/put_online_cpus()

Srivatsa S. Bhat (51):
      CPU hotplug: Provide lockless versions of callback registration functions
      Doc/cpu-hotplug: Specify race-free way to register CPU hotplug callbacks
      CPU hotplug, perf: Fix CPU hotplug callback registration
      ia64, salinfo: Fix hotplug callback registration
      ia64, palinfo: Fix CPU hotplug callback registration
      ia64, topology: Fix CPU hotplug callback registration
      ia64, err-inject: Fix CPU hotplug callback registration
      arm, hw-breakpoint: Fix CPU hotplug callback registration
      arm, kvm: Fix CPU hotplug callback registration
      s390, cacheinfo: Fix CPU hotplug callback registration
      s390, smp: Fix CPU hotplug callback registration
      sparc, sysfs: Fix CPU hotplug callback registration
      powerpc, sysfs: Fix CPU hotplug callback registration
      x86, msr: Fix CPU hotplug callback registration
      x86, cpuid: Fix CPU hotplug callback registration
      x86, vsyscall: Fix CPU hotplug callback registration
      x86, intel, uncore: Fix CPU hotplug callback registration
      x86, mce: Fix CPU hotplug callback registration
      x86, therm_throt.c: Fix CPU hotplug callback registration
      x86, therm_throt.c: Remove unused therm_cpu_lock
      x86, amd, ibs: Fix CPU hotplug callback registration
      x86, intel, cacheinfo: Fix CPU hotplug callback registration
      x86, intel, rapl: Fix CPU hotplug callback registration
      x86, amd, uncore: Fix CPU hotplug callback registration
      x86, hpet: Fix CPU hotplug callback registration
      x86, pci, amd-bus: Fix CPU hotplug callback registration
      x86, oprofile, nmi: Fix CPU hotplug callback registration
      x86, kvm: Fix CPU hotplug callback registration
      arm64, hw_breakpoint.c: Fix CPU hotplug callback registration
      arm64, debug-monitors: Fix CPU hotplug callback registration
      powercap, intel-rapl: Fix CPU hotplug callback registration
      scsi, bnx2i: Fix CPU hotplug callback registration
      scsi, bnx2fc: Fix CPU hotplug callback registration
      scsi, fcoe: Fix CPU hotplug callback registration
      zsmalloc: Fix CPU hotplug callback registration
      acpi-cpufreq: Fix CPU hotplug callback registration
      drivers/base/topology.c: Fix CPU hotplug callback registration
      clocksource, dummy-timer: Fix CPU hotplug callback registration
      intel-idle: Fix CPU hotplug callback registration
      oprofile, nmi-timer: Fix CPU hotplug callback registration
      octeon, watchdog: Fix CPU hotplug callback registration
      thermal, x86-pkg-temp: Fix CPU hotplug callback registration
      hwmon, coretemp: Fix CPU hotplug callback registration
      hwmon, via-cputemp: Fix CPU hotplug callback registration
      xen, balloon: Fix CPU hotplug callback registration
      trace, ring-buffer: Fix CPU hotplug callback registration
      profile: Fix CPU hotplug callback registration
      mm, vmstat: Fix CPU hotplug callback registration
      mm, zswap: Fix CPU hotplug callback registration
      net/core/flow.c: Fix CPU hotplug callback registration
      net/iucv/iucv.c: Fix CPU hotplug callback registration

---------------

 Documentation/cpu-hotplug.txt                 |  45 ++++++++++
 arch/arm/kernel/hw_breakpoint.c               |   8 +-
 arch/arm/kvm/arm.c                            |   7 +-
 arch/arm64/kernel/debug-monitors.c            |   6 +-
 arch/arm64/kernel/hw_breakpoint.c             |   7 +-
 arch/ia64/kernel/err_inject.c                 |  15 +++-
 arch/ia64/kernel/palinfo.c                    |   6 +-
 arch/ia64/kernel/salinfo.c                    |   6 +-
 arch/ia64/kernel/topology.c                   |   6 +-
 arch/powerpc/kernel/sysfs.c                   |   8 +-
 arch/s390/kernel/cache.c                      |   5 +-
 arch/s390/kernel/smp.c                        |  13 ++-
 arch/sparc/kernel/sysfs.c                     |   6 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c         |  13 +--
 arch/x86/kernel/cpu/mcheck/mce.c              |   8 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c      |  18 +---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c      |   6 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   |   7 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c   |   9 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   6 +-
 arch/x86/kernel/cpuid.c                       |  15 ++--
 arch/x86/kernel/hpet.c                        |   4 +-
 arch/x86/kernel/msr.c                         |  16 ++--
 arch/x86/kernel/vsyscall_64.c                 |   6 +-
 arch/x86/kvm/x86.c                            |   7 +-
 arch/x86/oprofile/nmi_int.c                   |  15 +++-
 arch/x86/pci/amd_bus.c                        |   5 +-
 drivers/base/topology.c                       |  12 ++-
 drivers/clocksource/dummy_timer.c             |  11 ++-
 drivers/cpufreq/acpi-cpufreq.c                |   7 +-
 drivers/hwmon/coretemp.c                      |  14 +--
 drivers/hwmon/via-cputemp.c                   |  14 +--
 drivers/idle/intel_idle.c                     |  12 ++-
 drivers/oprofile/nmi_timer_int.c              |  23 ++---
 drivers/powercap/intel_rapl.c                 |  10 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |  12 ++-
 drivers/scsi/bnx2i/bnx2i_init.c               |  12 ++-
 drivers/scsi/fcoe/fcoe.c                      |  15 +++-
 drivers/thermal/x86_pkg_temp_thermal.c        |  14 +--
 drivers/watchdog/octeon-wdt-main.c            |  11 ++-
 drivers/xen/balloon.c                         |  36 +++++---
 include/linux/cpu.h                           |  47 ++++++++++
 include/linux/perf_event.h                    |  16 +++-
 kernel/cpu.c                                  |  38 +++++++-
 kernel/profile.c                              |  20 +++--
 kernel/trace/ring_buffer.c                    |  19 ++--
 mm/vmstat.c                                   |   6 +-
 mm/zsmalloc.c                                 |  17 +++-
 mm/zswap.c                                    |   8 +-
 net/core/flow.c                               |   8 +-
 net/iucv/iucv.c                               | 121 ++++++++++++--------------
 51 files changed, 550 insertions(+), 226 deletions(-)
