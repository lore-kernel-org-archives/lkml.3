Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342AbaGRUse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:48:34 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52679 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084AbaGRUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:48:33 -0400
Date: Fri, 18 Jul 2014 21:48:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.17
Message-ID: <20140718204830.GB27099@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, please queue up the following changes for v3.17.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 99a5603e2a1f146ac0c6414d8a3669aa749ccff8:

  efi/arm64: Handle missing virtual mapping for UEFI System Table (2014-07-18 21:24:04 +0100)

----------------------------------------------------------------
 * arm64 efi stub fixes, preservation of FP/SIMD registers across
   firmware calls, and conversion of the EFI stub code into a static
   library - Ard Biesheuvel

 * Xen EFI support - Daniel Kiper

 * Support for autoloading the efivars driver - Lee, Chun-Yi

 * Use the PE/COFF headers in the x86 EFI boot stub to request that the
   stub be loaded with CONFIG_PHYSICAL_ALIGN alignment - Michael Brown

 * Consolidate all the x86 EFI quirks into one file - Saurabh Tangri

 * Additional error logging in x86 EFI boot stub - Ulf Winkelvos

 * Support loading initrd above 4G in EFI boot stub - Yinghai Lu

 * EFI reboot patches for ACPI hardware reduced platforms

----------------------------------------------------------------
Ard Biesheuvel (9):
      efi/arm64: efistub: remove local copy of linux_banner
      efi/x86: Move UEFI Runtime Services wrappers to generic code
      efi/arm64: Preserve FP/SIMD registers on UEFI runtime services calls
      efi/arm64: Avoid EFI_ERROR as a generic return code
      efi/x86: efistub: Move shared dependencies to <asm/efi.h>
      efi/arm64: efistub: Move shared dependencies to <asm/efi.h>
      efi: efistub: Refactor stub components
      efi: efistub: Convert into static library
      efi/arm64: Handle missing virtual mapping for UEFI System Table

Daniel Kiper (12):
      arch/ia64: Define early_memunmap()
      efi: Use early_mem*() instead of early_io*()
      arch/x86: Do not access EFI memory map if it is not available
      efi: Introduce EFI_PARAVIRT flag
      arch/x86: Remove redundant set_bit(EFI_SYSTEM_TABLES) call
      arch/x86: Remove redundant set_bit(EFI_MEMMAP) call
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove efi_set_rtc_mmss()
      xen: Silence compiler warnings
      arch/x86/xen: Silence compiler warnings

Lee, Chun-Yi (1):
      efi: Autoload efivars

Matt Fleming (5):
      x86/efi: Use early_memunmap() to squelch sparse errors
      efi/reboot: Add generic wrapper around EfiResetSystem()
      efi/reboot: Allow powering off machines using EFI
      x86/reboot: Add EFI reboot quirk for ACPI Hardware Reduced flag
      efi: Update stale locking comment for struct efivars

Michael Brown (1):
      x86/efi: Request desired alignment via the PE/COFF headers

Saurabh Tangri (1):
      x86/efi: Move all workarounds to a separate file quirks.c

Ulf Winkelvos (1):
      x86/efi: Add better error logging to EFI boot stub

Yinghai Lu (1):
      x86/efi: Support initrd loaded above 4G

 arch/arm64/Kconfig                                 |   6 +
 arch/arm64/Makefile                                |   1 +
 arch/arm64/include/asm/efi.h                       |  33 ++
 arch/arm64/kernel/Makefile                         |   3 +-
 arch/arm64/kernel/efi-stub.c                       |  50 +--
 arch/arm64/kernel/efi.c                            |  42 +-
 arch/ia64/include/asm/io.h                         |   1 +
 arch/ia64/kernel/process.c                         |   2 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/boot/compressed/Makefile                  |   3 +-
 arch/x86/boot/compressed/eboot.c                   |  48 +-
 arch/x86/boot/compressed/eboot.h                   |  16 -
 arch/x86/boot/header.S                             |   2 +-
 arch/x86/include/asm/efi.h                         |  33 ++
 arch/x86/kernel/reboot.c                           |  24 +-
 arch/x86/kernel/setup.c                            |   4 +-
 arch/x86/platform/efi/Makefile                     |   2 +-
 arch/x86/platform/efi/efi.c                        | 483 ++-------------------
 arch/x86/platform/efi/quirks.c                     | 290 +++++++++++++
 arch/x86/xen/Makefile                              |   1 +
 arch/x86/xen/efi.c                                 |  43 ++
 arch/x86/xen/enlighten.c                           |   2 +
 arch/x86/xen/xen-ops.h                             |   8 +
 drivers/firmware/efi/Kconfig                       |   6 +
 drivers/firmware/efi/Makefile                      |   4 +-
 drivers/firmware/efi/efi.c                         |  40 +-
 drivers/firmware/efi/efivars.c                     |   1 +
 drivers/firmware/efi/libstub/Makefile              |  26 ++
 drivers/firmware/efi/{ => libstub}/arm-stub.c      |  32 +-
 .../firmware/efi/{ => libstub}/efi-stub-helper.c   |  74 ++--
 drivers/firmware/efi/libstub/efistub.h             |  42 ++
 drivers/firmware/efi/{ => libstub}/fdt.c           |  30 +-
 drivers/firmware/efi/reboot.c                      |  56 +++
 drivers/firmware/efi/runtime-wrappers.c            | 161 +++++++
 drivers/xen/Kconfig                                |   4 +
 drivers/xen/Makefile                               |   3 +
 drivers/xen/efi.c                                  | 368 ++++++++++++++++
 include/linux/efi.h                                |  63 ++-
 include/xen/interface/platform.h                   | 123 ++++++
 include/xen/xen-ops.h                              |  11 +
 40 files changed, 1508 insertions(+), 634 deletions(-)
 create mode 100644 arch/x86/platform/efi/quirks.c
 create mode 100644 arch/x86/xen/efi.c
 create mode 100644 drivers/firmware/efi/libstub/Makefile
 rename drivers/firmware/efi/{ => libstub}/arm-stub.c (93%)
 rename drivers/firmware/efi/{ => libstub}/efi-stub-helper.c (88%)
 create mode 100644 drivers/firmware/efi/libstub/efistub.h
 rename drivers/firmware/efi/{ => libstub}/fdt.c (90%)
 create mode 100644 drivers/firmware/efi/reboot.c
 create mode 100644 drivers/firmware/efi/runtime-wrappers.c
 create mode 100644 drivers/xen/efi.c

-- 
Matt Fleming, Intel Open Source Technology Center
