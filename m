Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3I3Kt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:49:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56017 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab3I3KtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:49:25 -0400
Date: Mon, 30 Sep 2013 11:49:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes
Message-ID: <20130930104918.GO21381@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These changes are targetted for the next merge window. Is it possible to
get them into linux-next for some vigorous testing? The pending ARM EFI
boot stub patches from Roy Franz depend on the x86 EFI boot stub
cleanups included in this pull request.

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 0ce6cda2c75d64175394341ef60e6e1d27dd9c10:

  x86 efi: bugfix interrupt disabling sequence (2013-09-30 10:23:11 +0100)

----------------------------------------------------------------
 * Delete redundant interrupt descriptor table code in the EFI boot stub
   and reposition the interrupt disable instruction to avoid a potential
   triple fault - Bart Kuivenhoven

 * Mark local function static to avoid sparse warnings - Bojan Prtvar

 * EFI boot stub support for memory maps with more than 128 entries -
   Linn Crosetto

 * Move generic EFI code into drivers/firmware/efi/ in preparation for
   the ARM EFI boot stub - Leif Lindholm

 * Cleanups and extraction of code from the x86 EFI boot stub to
   be shared with the ARM EFI boot stub - Roy Franz

----------------------------------------------------------------
Bart Kuivenhoven (1):
      x86 efi: bugfix interrupt disabling sequence

Bojan Prtvar (1):
      efivars: Mark local function as static

Leif Lindholm (3):
      ia64: add early_memremap() alias for early_ioremap()
      efi: x86: ia64: provide a generic efi_config_init()
      efi: x86: make efi_lookup_mapped_addr() a common function

Linn Crosetto (1):
      x86: EFI stub support for large memory maps

Matt Fleming (2):
      Merge branch 'arm/efi-stub' into next
      Merge branch 'arm/common' into next

Roy Franz (17):
      EFI stub documentation updates
      efi: Add proper definitions for some EFI function pointers.
      efi: Move common EFI stub code from x86 arch code to common location
      efi: Add system table pointer argument to shared functions.
      efi: Rename memory allocation/free functions
      efi: Enforce minimum alignment of 1 page on allocations.
      efi: Move relocate_kernel() to shared file.
      efi: Generalize relocate_kernel() for use by other architectures.
      efi: Move unicode to ASCII conversion to shared function.
      efi: Rename __get_map() to efi_get_memory_map()
      efi: generalize efi_get_memory_map()
      efi: use efi_get_memory_map() to get final map for x86
      efi: Allow efi_free() to be called with size of 0
      efi: Generalize handle_ramdisks() and rename to handle_cmdline_files().
      efi: Renames in handle_cmdline_files() to complete generalization.
      efi: Fix types in EFI calls to match EFI function definitions.
      efi: resolve warnings found on ARM compile

 Documentation/{x86 => }/efi-stub.txt   |   0
 arch/ia64/include/asm/io.h             |   1 +
 arch/ia64/kernel/efi.c                 |  54 +--
 arch/x86/Kconfig                       |   2 +-
 arch/x86/boot/compressed/eboot.c       | 789 ++++++++-------------------------
 arch/x86/boot/compressed/eboot.h       |   9 -
 arch/x86/platform/efi/efi.c            | 126 +-----
 drivers/firmware/efi/efi-stub-helper.c | 638 ++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c             | 140 ++++++
 drivers/firmware/efi/efivars.c         |   2 +-
 include/linux/efi.h                    |  58 ++-
 11 files changed, 1031 insertions(+), 788 deletions(-)
 rename Documentation/{x86 => }/efi-stub.txt (100%)
 create mode 100644 drivers/firmware/efi/efi-stub-helper.c
-- 
Matt Fleming, Intel Open Source Technology Center
