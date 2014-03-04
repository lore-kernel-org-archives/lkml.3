Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbaCDVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:16:27 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58686 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933204AbaCDVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:15:32 -0500
Date: Tue, 4 Mar 2014 21:15:26 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.15
Message-ID: <20140304211526.GA17362@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Could you please queue up the following for the v3.15 merge window?

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 69e608411473ac56358ef35277563982d0565381:

  efi: Use NULL instead of 0 for pointer (2014-03-04 16:17:20 +0000)

----------------------------------------------------------------
 * Refactor efivarfs_file_write() and use memdup_user - Geyslan G. Bem

 * Delete stale comments in efi_query_variable_store() - Madper Xie

 * EFI code style improvements - Joe Perches

 * Remove some sparse warnings in efivars - Daeseok Youn

 * Add debug code to the dump EFI pagetable - Borislav Petkov

 * Make 1:1 runtime mapping robust when booting on machines with lots of
   memory - Borislav Petkov

 * Move the EFI facilities bits out of 'x86_efi_facility' and into
   efi.flags which is the standard architecture independent place to
   keep EFI state.

----------------------------------------------------------------
Borislav Petkov (5):
      x86, ptdump: Add the functionality to dump an arbitrary pagetable
      x86/efi: Dump the EFI page table
      x86, pageattr: Export page unmapping interface
      x86/efi: Make efi virtual runtime map passing more robust
      x86/efi: Split efi_enter_virtual_mode

Daeseok Youn (1):
      efi: Use NULL instead of 0 for pointer

Geyslan G. Bem (1):
      efivarfs: 'efivarfs_file_write' function reorganization

Joe Perches (1):
      x86/efi: Style neatening

Madper Xie (1):
      x86/efi: Delete out-of-date comments of efi_query_variable_store

Matt Fleming (3):
      efi: Move facility flags to struct efi
      efi: Set feature flags inside feature init functions
      ia64/efi: Implement efi_enabled()

 arch/ia64/kernel/efi.c               |   7 +
 arch/x86/Kconfig.debug               |   9 ++
 arch/x86/include/asm/efi.h           |   5 +-
 arch/x86/include/asm/pgtable.h       |   3 +-
 arch/x86/include/asm/pgtable_types.h |   2 +
 arch/x86/kernel/setup.c              |   6 +-
 arch/x86/mm/dump_pagetables.c        |  84 +++++++----
 arch/x86/mm/pageattr.c               |  44 ++++--
 arch/x86/platform/efi/efi.c          | 276 +++++++++++++++++++++++------------
 arch/x86/platform/efi/efi_32.c       |   7 +-
 arch/x86/platform/efi/efi_64.c       |  41 +++++-
 drivers/firmware/efi/efi.c           |   5 +-
 drivers/firmware/efi/efivars.c       |   2 +-
 fs/efivarfs/file.c                   |  13 +-
 include/linux/efi.h                  |  16 +-
 15 files changed, 356 insertions(+), 164 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
