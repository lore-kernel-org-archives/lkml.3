Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161984AbaKNVm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:42:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61413 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaKNVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:42:26 -0500
Date: Fri, 14 Nov 2014 21:42:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.19
Message-ID: <20141114214223.GA6810@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Please queue up the following changes for v3.19. 

Inclued are two straight forward changes from Mathias, and another
attempt from Ard at moving the x86 EFI boot stub to the libstub library.

It would be great to get these baking in linux-next for a bit.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e:

  x86, ptdump: Add section for EFI runtime services (2014-11-11 22:28:57 +0000)

----------------------------------------------------------------
 * Support module unload for efivarfs - Mathias Krause

 * Another attempt at moving x86 to libstub taking advantage of the
   __pure attribute - Ard Biesheuvel

 * Add EFI runtime services section to ptdump - Mathias Krause

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/x86: Move x86 back to libstub

Mathias Krause (2):
      efivarfs: Allow unloading when build as module
      x86, ptdump: Add section for EFI runtime services

 arch/x86/boot/compressed/Makefile       |  3 ++-
 arch/x86/boot/compressed/eboot.c        |  8 ++++----
 arch/x86/boot/compressed/eboot.h        | 16 ----------------
 arch/x86/include/asm/efi.h              | 24 ++++++++++++++++++++++++
 arch/x86/include/asm/pgtable_64_types.h |  2 ++
 arch/x86/mm/dump_pagetables.c           |  3 +++
 arch/x86/platform/efi/efi_64.c          |  3 +--
 drivers/firmware/efi/Makefile           |  2 +-
 fs/efivarfs/super.c                     | 11 +++++++++--
 9 files changed, 46 insertions(+), 26 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
