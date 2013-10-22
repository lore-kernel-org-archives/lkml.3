Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3JVR4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:56:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:53437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab3JVR4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:56:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="415303688"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT PULL] For x86/mce ... enhanced error logs
Date: Tue, 22 Oct 2013 10:56:36 -0700
Message-Id: <5266bc543597964da@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Ultimate plan is to use these enhanced error logs to feed a
perf/trace event ... but we are still discussing the exact
format of that, and also how it should interact/complement/replace
the existing EDAC trace event.  Meanwhile all this precursor work
has been reviewed and agreed on by Mauro, Boris & others ... so
it can be queued for the next merge window while we continue work
on the trace event.

-Tony

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-eMCA

for you to fetch changes up to 7dcb5248a2593539d40b1bcd8da0158e7c3967b5:

  EDAC, GHES: Update ghes error record info (2013-10-21 15:12:02 -0700)

----------------------------------------------------------------
There is a enhanced error logging mechanism for Xeon processors.
Full description is here:
http://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html
This patch series provides a module (and support code) to
check for an extended error log and print extra details about
the error on the console.

----------------------------------------------------------------
Chen, Gong (9):
      ACPI, APEI, CPER: Fix status check during error printing
      ACPI, CPER: Update cper info
      bitops: Introduce a more generic BITMASK macro
      ACPI, x86: Extended error log driver for x86 platform
      DMI: Parse memory device (type 17) in SMBIOS
      ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
      ACPI, APEI, CPER: Enhance memory reporting capability
      ACPI, APEI, CPER: Cleanup CPER memory error output format
      EDAC, GHES: Update ghes error record info

 arch/ia64/kernel/setup.c              |   1 +
 arch/x86/include/asm/mce.h            |   1 +
 arch/x86/kernel/cpu/mcheck/mce-apei.c |   3 +-
 arch/x86/kernel/setup.c               |   1 +
 drivers/acpi/Kconfig                  |  19 ++
 drivers/acpi/Makefile                 |   2 +
 drivers/acpi/acpi_extlog.c            | 326 ++++++++++++++++++++++++++++++++++
 drivers/acpi/apei/apei-internal.h     |  12 +-
 drivers/acpi/apei/cper.c              | 132 +++++++-------
 drivers/acpi/apei/ghes.c              |  58 +++---
 drivers/acpi/bus.c                    |   3 +-
 drivers/edac/amd64_edac.c             |  46 ++---
 drivers/edac/amd64_edac.h             |   8 -
 drivers/edac/ghes_edac.c              |  16 +-
 drivers/edac/sb_edac.c                |   2 +-
 drivers/firmware/dmi_scan.c           |  60 +++++++
 drivers/video/sis/init.c              |   5 +-
 include/acpi/actbl1.h                 |  14 +-
 include/acpi/ghes.h                   |   2 +-
 include/linux/acpi.h                  |   1 +
 include/linux/bitops.h                |   8 +
 include/linux/cper.h                  |  13 +-
 include/linux/dmi.h                   |   5 +
 include/linux/edac.h                  |   2 +-
 24 files changed, 591 insertions(+), 149 deletions(-)
 create mode 100644 drivers/acpi/acpi_extlog.c
