Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaCDXn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:43:26 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:35855 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbaCDXnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:43:25 -0500
Date: Tue, 4 Mar 2014 23:43:19 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI mixed mode support
Message-ID: <20140304234319.GC17362@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, I've got the mixed mode support in two branches.

'mixed-mode' is a clean topic branch against -rc3, which will generate
conflicts when you merge it with the EFI 'next' branch.

I performed the merge myself in 'mixed-mode-merged' so you can take a
look there to see how I resolved the conflicts.

If you want another option, just let me know.

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git mixed-mode

for you to fetch changes up to 18c46461d9e42d398536055f31f58cdcd2c6347e:

  x86/efi: Re-disable interrupts after calling firmware services (2014-03-04 21:44:00 +0000)

----------------------------------------------------------------
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
 arch/x86/platform/efi/efi.c            |  141 +++--
 arch/x86/platform/efi/efi_64.c         |  335 ++++++++++-
 arch/x86/platform/efi/efi_stub_64.S    |  157 +++++
 arch/x86/platform/efi/efi_thunk_64.S   |   65 ++
 drivers/firmware/efi/efi-stub-helper.c |  148 ++---
 include/linux/efi.h                    |  252 ++++++++
 21 files changed, 2116 insertions(+), 424 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi_thunk_64.S

-- 
Matt Fleming, Intel Open Source Technology Center
