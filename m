Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3LCQhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:37:24 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34715 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3LCQhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:37:20 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [RFC part1 PATCH 0/7] Make ACPI core running on ARM64
Date: Wed,  4 Dec 2013 00:36:44 +0800
Message-Id: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first part of making ACPI core running on ARM.

PCI is optional on ARM64 but ACPI is dependent on PCI now, so
in the first patch we try to make ACPI can be running without
PCI.

_PDC is requred for ACPI processor_core.c, but its related code
is a little bit x86/ia64 dependent, so I rework _PDC related staff
to make it more arch independent, and then introduce the skeleton
of _PDC related for ARM64, it should be fully implemented after
ACPI spec is ready for processor idle control.

After that, arm-core.c is introduced so we can get ACPI table from
UEFI, then we can parsed for SMP initialisation, GIC initialisation
and for ACPI drivers.

This patch set is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git

origin/linux-next branch and plus Al Stone's v2 reduced hardware profile
patch.

Hanjun Guo (7):
  ACPI: Make ACPI core running without PCI on ARM64
  ARM64 : Add dummy asm/cpu.h
  ACPI / processor_core: Rework _PDC related stuff to make it more
    arch-independent
  ARM64 / ACPI: Introduce the skeleton of _PDC related for ARM64
  ARM64 / ACPI: Introduce arm_core.c and its related head file
  ARM64 / ACPI: Introduce lowlevel suspend function
  ARM64 / ACPI: Enable ARM64 in Kconfig

 arch/arm64/Kconfig                 |    2 +
 arch/arm64/include/asm/acpi.h      |   93 +++++++++++++++
 arch/arm64/include/asm/cpu.h       |   25 ++++
 arch/arm64/include/asm/processor.h |   11 ++
 arch/arm64/kernel/process.c        |    5 +
 arch/arm64/kernel/setup.c          |    8 ++
 drivers/acpi/Kconfig               |   12 +-
 drivers/acpi/Makefile              |    4 +-
 drivers/acpi/internal.h            |    5 +
 drivers/acpi/osl.c                 |   16 +++
 drivers/acpi/plat/Makefile         |    1 +
 drivers/acpi/plat/arm-core.c       |  226 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c      |   27 ++---
 drivers/acpi/reboot.c              |   47 +++++---
 drivers/pnp/pnpacpi/rsparser.c     |    2 +
 15 files changed, 452 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/include/asm/acpi.h
 create mode 100644 arch/arm64/include/asm/cpu.h
 create mode 100644 drivers/acpi/plat/Makefile
 create mode 100644 drivers/acpi/plat/arm-core.c

-- 
1.7.9.5

