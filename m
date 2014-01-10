Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbaAJWaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:30:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaAJW36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:29:58 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        patches@linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 0/6] arm64: Add EFI stub and runtime services support
Date: Fri, 10 Jan 2014 17:29:04 -0500
Message-Id: <1389392950-22457-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds EFI support to the arm64 kernel. This support has
two main parts: an EFI stub and runtime support. The EFI stub support
has the kernel masquerade as a PE/COFF application which can be directly
booted by EFI firmware (or by secondary loaders with EFI support). The
runtime services support provides access to various EFI firmware services
such as reboot, real-time clock, boot variables, and others.

Changes since v1:

  * Added Acks (well, one anyway)

  * The first 3 patches are new for v2 and provide more generic
    support for for following EFI patches.

  * Lots of changes based on feedback from Catalin mostly. I think
    I addressed all of his comments.

These patches have dependencies on other patches which are not yet in
the kernel but have been posted and are currently under review. In
particular:

  - Generic fixmap support being discussed here:
      http://lkml.org/lkml/2013/11/25/474
    This is now in the akpm tree

  - early_ioremap support being discussed here:
      https://lkml.org/lkml/2014/1/9/708

  - shared EFI update_fdt() function in this series:
      http://news.gmane.org/gmane.linux.kernel.efi

A repo with this patch series and the prerequisite patches is at:

  git://github.com/mosalter/linux.git (arm64-efi-patches-v2 branch)

Mark Salter (6):
  efi: create memory map iteration helper
  arm64: Add function to create identity mappings
  efi: add helper function to get UEFI params from FDT
  arm64: add EFI stub
  doc: arm64: add description of EFI stub support
  arm64: add EFI runtime services

 Documentation/arm64/booting.txt |   4 +
 Documentation/efi-stub.txt      |  12 +-
 arch/arm64/Kconfig              |  26 +++
 arch/arm64/include/asm/efi.h    |  12 ++
 arch/arm64/include/asm/mmu.h    |   1 +
 arch/arm64/kernel/Makefile      |   4 +
 arch/arm64/kernel/efi-entry.S   |  93 +++++++++++
 arch/arm64/kernel/efi-stub.c    | 181 ++++++++++++++++++++
 arch/arm64/kernel/efi.c         | 353 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S        | 112 +++++++++++++
 arch/arm64/kernel/setup.c       |   6 +
 arch/arm64/mm/mmu.c             |  34 ++--
 drivers/firmware/efi/Kconfig    |   7 +
 drivers/firmware/efi/efi.c      |  79 +++++++++
 include/linux/efi.h             |  17 +-
 15 files changed, 927 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c

-- 
1.8.3.1

