Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbaD3UDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:03:43 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42526 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbaD3UDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:03:42 -0400
Date: Wed, 30 Apr 2014 21:03:32 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [GIT PULL] EFI changes for arm64
Message-ID: <20140430200332.GO26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I pulled the arm64 EFI changes into the following topic branch. Catalin
was happy for this to go through tip, which definitely makes things
easier for the next merge window because of the dependency these patches
have on tip/x86/efi.

The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:

  efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git arm64-efi

for you to fetch changes up to 345c736edd07b657a8c48190baed2719b85d0938:

  efi/arm64: ignore dtb= when UEFI SecureBoot is enabled (2014-04-30 19:57:06 +0100)

----------------------------------------------------------------
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

 Documentation/arm/00-INDEX      |   2 +
 Documentation/arm/uefi.txt      |  64 ++++++
 Documentation/arm64/booting.txt |   4 +
 Documentation/efi-stub.txt      |  33 ++-
 arch/arm64/Kconfig              |  16 ++
 arch/arm64/include/asm/efi.h    |  14 ++
 arch/arm64/include/asm/mmu.h    |   2 +
 arch/arm64/kernel/Makefile      |   3 +
 arch/arm64/kernel/efi-entry.S   | 109 ++++++++++
 arch/arm64/kernel/efi-stub.c    |  81 +++++++
 arch/arm64/kernel/efi.c         | 466 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S        | 112 ++++++++++
 arch/arm64/kernel/setup.c       |   5 +
 arch/arm64/mm/mmu.c             |  65 ++++--
 drivers/firmware/efi/Kconfig    |   7 +
 drivers/firmware/efi/arm-stub.c | 278 ++++++++++++++++++++++++
 drivers/firmware/efi/efi.c      |  79 +++++++
 drivers/firmware/efi/fdt.c      | 285 ++++++++++++++++++++++++
 include/linux/efi.h             |  12 ++
 lib/Makefile                    |   3 +-
 lib/fdt_empty_tree.c            |   2 +
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
Matt Fleming, Intel Open Source Technology Center
