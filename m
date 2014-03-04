Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbaCDNO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:14:29 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58287 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbaCDNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:28 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 00/13] EFI mixed mode
Date: Tue,  4 Mar 2014 13:14:08 +0000
Message-Id: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This patch series enables booting a 64-bit kernel on 32-bit EFI
firmware.

Note that no boot loader changes should be necessary to take advantage
of these patches, and if your bootloader of choice uses the EFI handover
protocol (Syslinux, efilinux, Grub) you should automatically be able to
boot a CONFIG_X86_64 kernel on 32-bit EFI by enabling CONFIG_EFI_MIXED.

This series does not implement mixed mode support for the EFI boot stub,
so it won't work with gummiboot or directly from the EFI shell.

The full series is available on the 'mixed-mode' branch here,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git


Changes since v1:

 - Simplify EFI_BOOT_SERVICES() as suggested by hpa

... and I remembered to actually post to LKML this time.

Matt Fleming (13):
  x86/boot: Cleanup header.S by removing some #ifdefs
  x86, tools: Consolidate #ifdef code
  x86/mm/pageattr: Always dump the right page table in an oops
  x86/efi: Delete dead code when checking for non-native
  efi: Add separate 32-bit/64-bit definitions
  x86/efi: Build our own EFI services pointer table
  x86/efi: Add early thunk code to go from 64-bit to 32-bit
  x86/efi: Split the boot stub into 32/64 code paths
  x86/efi: Firmware agnostic handover entry points
  x86/efi: Add mixed runtime services support
  x86/efi: Wire up CONFIG_EFI_MIXED
  x86/boot: Don't overwrite cr4 when enabling PAE
  x86/efi: Re-disable interrupts after calling firmware services

 arch/x86/Kconfig                       |   14 +
 arch/x86/boot/Makefile                 |    2 +-
 arch/x86/boot/compressed/eboot.c       | 1018 +++++++++++++++++++++++++-------
 arch/x86/boot/compressed/eboot.h       |   60 ++
 arch/x86/boot/compressed/efi_stub_64.S |   29 +
 arch/x86/boot/compressed/head_32.S     |   50 +-
 arch/x86/boot/compressed/head_64.S     |  108 +++-
 arch/x86/boot/header.S                 |   23 +-
 arch/x86/boot/tools/build.c            |   76 ++-
 arch/x86/include/asm/efi.h             |   38 +-
 arch/x86/include/asm/pgtable_types.h   |    2 +
 arch/x86/kernel/setup.c                |    2 +-
 arch/x86/mm/fault.c                    |    7 +-
 arch/x86/mm/pageattr.c                 |   12 +-
 arch/x86/platform/efi/Makefile         |    1 +
 arch/x86/platform/efi/efi.c            |  170 +++---
 arch/x86/platform/efi/efi_64.c         |  328 +++++++++-
 arch/x86/platform/efi/efi_stub_64.S    |  157 +++++
 arch/x86/platform/efi/efi_thunk_64.S   |   65 ++
 drivers/firmware/efi/efi-stub-helper.c |  148 ++---
 include/linux/efi.h                    |  252 ++++++++
 21 files changed, 2114 insertions(+), 448 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi_thunk_64.S

-- 
1.8.5.3

