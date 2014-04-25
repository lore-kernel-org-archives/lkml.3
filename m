Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaDYQKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:10:00 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34020 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaDYQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:09:53 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 00/10] arm64: UEFI support
Date: Fri, 25 Apr 2014 17:09:04 +0100
Message-Id: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set adds support for UEFI to the arm64 port - a stub loader, as
well as runtime services support for efivars.

It depends on some core EFI patches currently in linux-next.

This includes bits shared between arm and arm64 support.
Remaining bits required for arm support will be submitted separately.

Changes from previous version:
- Reordered runtime and stub packages to avoid bisect breakage.
- Added more comments to efi-entry.S.
- Use actual instruction to generate "MZ" signature in head.S.
- Redundant cache/tlb maintenance removed.
- Properly use %pa instead of %llx in mm error messages..
- Stub deletes DT nodes of type "memory" instead of nodes called
  "memory".

Changes from earlier versions:
- Enter_virtual_mode() is now an early initcall.
- UEFI Reserved regions now preserved.
- Bugfix for dtb= support with SecureBoot.
- Stub now flushes instruction cache by address for kernel image area.
- CONFIG_EFI_STUB merged into CONFIG_EFI since they are interdependent.
- EFI_DEVICE_TREE_GUID renamed DEVICE_TREE_GUID.
- Minor cleanups.

Ard Biesheuvel (1):
  efi/arm64: ignore dtb= when UEFI SecureBoot is enabled

Leif Lindholm (1):
  doc: arm: add UEFI support documentation

Mark Salter (6):
  lib: add fdt_empty_tree.c
  efi: add helper function to get UEFI params from FDT
  arm64: Add function to create identity mappings
  arm64: add EFI runtime services
  arm64: efi: add EFI stub
  doc: arm64: add description of EFI stub support

Roy Franz (2):
  doc: efi-stub.txt updates for ARM
  efi: Add shared FDT related functions for ARM/ARM64

 Documentation/arm/00-INDEX      |    2 +
 Documentation/arm/uefi.txt      |   64 ++++++
 Documentation/arm64/booting.txt |    4 +
 Documentation/efi-stub.txt      |   33 ++-
 arch/arm64/Kconfig              |   16 ++
 arch/arm64/include/asm/efi.h    |   14 ++
 arch/arm64/include/asm/mmu.h    |    2 +
 arch/arm64/kernel/Makefile      |    3 +
 arch/arm64/kernel/efi-entry.S   |  109 +++++++++
 arch/arm64/kernel/efi-stub.c    |   81 +++++++
 arch/arm64/kernel/efi.c         |  466 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S        |  112 ++++++++++
 arch/arm64/kernel/setup.c       |    5 +
 arch/arm64/mm/mmu.c             |   65 ++++--
 drivers/firmware/efi/Kconfig    |    7 +
 drivers/firmware/efi/arm-stub.c |  278 +++++++++++++++++++++++
 drivers/firmware/efi/efi.c      |   79 +++++++
 drivers/firmware/efi/fdt.c      |  285 ++++++++++++++++++++++++
 include/linux/efi.h             |   12 +
 lib/Makefile                    |    3 +-
 lib/fdt_empty_tree.c            |    2 +
 21 files changed, 1616 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-stub.c
 create mode 100644 drivers/firmware/efi/fdt.c
 create mode 100644 lib/fdt_empty_tree.c

-- 
1.7.10.4

