Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3LCQjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:39:35 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59422 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3LCQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:39:31 -0500
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
Subject: [RFC part2 PATCH 0/9] Using ACPI MADT table to initialise SMP and GIC
Date: Wed,  4 Dec 2013 00:39:04 +0800
Message-Id: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is based on part1 "Make ACPI core running on ARM64" patch
set.

After we can get the ACPI tables from UEFI, we can use these tables
to initialise the system now.

GIC (means GIC cpu interface) structure and GIC distributor structure in
MADT table contains the information of GIC cpu interface base address
and GIC distributor base address, which can be used to initialise GIC.

Further more, parked address in GIC structure can be used as cpu release
address for spin table SMP initialisation.

This patch set use these information to init SMP and GIC.

Please refer to chapter 5.2.12.14/15 of ACPI 5.0 spec for GIC and GIC
distributor structure information.

Amit Daniel Kachhap (1):
  irqdomain: Add a new API irq_create_acpi_mapping()

Hanjun Guo (8):
  ARM64 / ACPI: Implement core functions for parsing MADT table
  ARM64 / ACPI: Prefill cpu possible/present maps and map logical cpu
    id to APIC id
  ARM64 / ACPI: Introduce map_gic_id() to get apic id from MADT or _MAT
    method
  ARM64 / ACPI: Use Parked Address in GIC structure for spin table SMP
    initialisation
  ACPI: Define ACPI_IRQ_MODEL_GIC needed for arm
  Irqchip / gic: Set as default domain so we can access from ACPI
  ACPI / ARM64: Update acpi_register_gsi to register with the core IRQ
    subsystem
  ACPI / GIC: Initialize GIC using the information in MADT

 arch/arm64/include/asm/acpi.h      |   16 +-
 arch/arm64/kernel/irq.c            |    5 +
 arch/arm64/kernel/setup.c          |    2 +
 arch/arm64/kernel/smp.c            |    2 +
 arch/arm64/kernel/smp_spin_table.c |   16 +-
 drivers/acpi/bus.c                 |    3 +
 drivers/acpi/plat/arm-core.c       |  397 +++++++++++++++++++++++++++++++++++-
 drivers/acpi/processor_core.c      |   26 +++
 drivers/acpi/tables.c              |   21 ++
 drivers/irqchip/irq-gic.c          |    7 +
 include/linux/acpi.h               |    9 +
 kernel/irq/irqdomain.c             |   27 +++
 12 files changed, 521 insertions(+), 10 deletions(-)

-- 
1.7.9.5

