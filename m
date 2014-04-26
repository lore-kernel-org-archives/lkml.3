Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaDZALz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:11:55 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64077 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaDZALx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:11:53 -0400
MIME-Version: 1.0
Date: Sat, 26 Apr 2014 02:11:51 +0200
X-Google-Sender-Auth: GWI4VWh5eYVyXO22H1KWlOdazkY
Message-ID: <CAJZ5v0gkQH0=hGTpA0fF=tpAW_t3eCvLkZPQ-=ROPmzzDYssLg@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.15-rc3
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc3

to receive ACPI, power management and PNP fixes for v3.15-rc3
with top-most commit d4c9c8a09cff85f69b2c224ca7dbeb42431da2b3

  Merge branches 'pnp' and 'acpi-hotplug'

on top of commit a798c10faf62a505d24e5f6213fbaf904a39623f

  Linux 3.15-rc2

These include a fix for a recent ACPI regression related to
device notifications, intel_idle fix related to IvyTown support,
fix for a buffer size issue in ACPICA, PM core fix related to the
"freeze" sleep state, four fixes for various types of breakage in
cpufreq drivers, a PNP workaround for a wrong memory region size
in ACPI tables, and a fix and cleanup for the ACPI tools Makefile.

Specifics:

 - Fix for broken ACPI notifications on some systems caused by
   a recent ACPI hotplug commit that blocked the propagation of
   unknown type notifications to device drivers inadvertently.

 - intel_idle fix to make the IvyTown C-states handling (added
   recently) work as intended which now is broken due to missing
   braces.  From Christoph Jaeger.

 - ACPICA fix to make it allocate buffers of the right sizes for
   the Generic Serial Bus operation region access.  From Lv Zheng.

 - PM core fix unblocking cpuidle before entering the "freeze"
   sleep state which causes that state to be able to actually save
   more energy than runtime idle.

 - Configuration and build fixes for the highbank and powernv
   cpufreq drivers from Kefeng Wang and Srivatsa S Bhat.

 - Coccinelle warning fix related to error pointers for the
   unicore32 cpufreq driver from Duan Jiong.

 - Integer overflow fix for the ppc-corenet cpufreq driver from
   Geert Uytterhoeven.

 - Workaround for BIOSes that don't report the entire Intel MCH
   area in their ACPI tables from Bjorn Helgaas.

 - ACPI tools Makefile fix and cleanup from Thomas Renninger.

Thanks!


---------------

Bjorn Helgaas (1):
      PNP: Work around BIOS defects in Intel MCH area reporting

Christoph Jaeger (1):
      intel_idle: fix IVT idle state table setting

Duan Jiong (1):
      cpufreq: unicore32: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Geert Uytterhoeven (1):
      cpufreq: ppc: Fix integer overflow in expression

Kefeng Wang (1):
      cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency warning

Lv Zheng (1):
      ACPICA: Fix buffer allocation issue for generic_serial_bus
region accesses.

Rafael J. Wysocki (2):
      PM / suspend: Make cpuidle work in the "freeze" state
      ACPI / notify: Do not block unknown type notifications in root handler

Srivatsa S. Bhat (1):
      cpufreq, powernv: Fix build failure on UP

Thomas Renninger (1):
      tools/power/acpi: Minor bugfixes

---------------

 drivers/acpi/acpica/exfield.c         | 104 +++++++++++++++++++++++++++++++---
 drivers/acpi/bus.c                    |   5 +-
 drivers/cpufreq/Kconfig.arm           |   6 +-
 drivers/cpufreq/powernv-cpufreq.c     |   1 +
 drivers/cpufreq/ppc-corenet-cpufreq.c |   2 +-
 drivers/cpufreq/unicore2-cpufreq.c    |   4 +-
 drivers/idle/intel_idle.c             |   3 +-
 drivers/pnp/quirks.c                  |  79 ++++++++++++++++++++++++++
 kernel/power/suspend.c                |   3 +
 tools/power/acpi/Makefile             |  11 +---
 10 files changed, 188 insertions(+), 30 deletions(-)
