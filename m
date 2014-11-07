Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaKGN2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:28:15 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61089 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaKGN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:28:12 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [RFC PATCH 0/4] MMCFG refactoring + PCI ACPI probing for ARM64
Date: Fri,  7 Nov 2014 14:27:52 +0100
Message-Id: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set can be break down into two logic parts:
1. patch 1,2 - MMCONFIG code refacoring. MMCFG ACPI table has no arch
dependencies so it can be used across other architectures.
2. patch 3,4 aim for PCI ACPI probing on ARM64

Patches tested on Cavium ThunderX simulator with the latest ACPI ARM64 core set:
http://www.serverphorums.com/read.php?12,997228

Tomasz Nowicki (4):
  x86, acpi, pci: Move arch-agnostic MMCFG code out of arch/x86/
    directory.
  x86, acpi, pci: Isolate new PCI mmconfig entry insertion.
  arm64, acpi, pci: Add arch specific functions for mmconfig driver.
  arm64, acpi, pci: Provide arch-specific calls for PCI host bridge
    dirver (PNP0A03).

 arch/arm64/Kconfig             |   3 +
 arch/arm64/include/asm/pci.h   |   8 +
 arch/arm64/kernel/Makefile     |   1 +
 arch/arm64/kernel/mmconfig.c   |  69 +++++++
 arch/arm64/kernel/pci.c        | 401 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/pci_x86.h |  29 ---
 arch/x86/pci/acpi.c            |   1 +
 arch/x86/pci/init.c            |   1 +
 arch/x86/pci/mmconfig-shared.c | 176 +-----------------
 arch/x86/pci/mmconfig_32.c     |   1 +
 arch/x86/pci/mmconfig_64.c     |   1 +
 drivers/acpi/Makefile          |   1 +
 drivers/acpi/bus.c             |   1 +
 drivers/acpi/mmconfig.c        | 204 +++++++++++++++++++++
 include/linux/mmconfig.h       |  57 ++++++
 include/linux/pci.h            |   8 -
 16 files changed, 738 insertions(+), 224 deletions(-)
 create mode 100644 arch/arm64/kernel/mmconfig.c
 create mode 100644 drivers/acpi/mmconfig.c
 create mode 100644 include/linux/mmconfig.h

-- 
1.9.1

