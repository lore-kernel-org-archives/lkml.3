Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaIHVzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:55:40 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59612 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaIHVzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:55:38 -0400
Date: Mon, 8 Sep 2014 22:55:35 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20140908215535.GD18582@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Please queue up the following fixes, mainly for regressions introduced
in the merge window or -rc2.

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 5d6012d8d72b4107bbc68d9e761aa5e2ddd73b05:

  efi/arm64: Fix fdt-related memory reservation (2014-09-08 20:52:48 +0100)

----------------------------------------------------------------
 * Fix early boot regression affecting x86 EFI boot stub when loading
   initrds above 4GB - Yinghai Lu

 * Relocate GOT entries in the x86 EFI boot stub now that we have
   symbols with global visibility - Matt Fleming

 * Fixes for compiler warnings caused by parameter and variable names
   shadowing types - Mark Rustad

 * General EFI cleanups and simplifications - Mathias Krause

 * fdt memory reservation fix for arm64 - Mark Salter

----------------------------------------------------------------
Mark Rustad (1):
      efi: Resolve some shadow warnings

Mark Salter (1):
      efi/arm64: Fix fdt-related memory reservation

Mathias Krause (4):
      x86/efi: Remove unused efi_call* macros
      x86/efi: Unexport add_efi_memmap variable
      x86/efi: Update comment regarding required phys mapped EFI services
      x86/efi: Mark initialization code as such

Matt Fleming (1):
      x86/efi: Fixup GOT in all boot code paths

Yinghai Lu (1):
      x86/efi: Only load initrd above 4g on second try

 arch/arm64/mm/init.c                |  3 +-
 arch/x86/boot/compressed/eboot.c    | 18 +++++++-----
 arch/x86/boot/compressed/head_32.S  | 54 +++++++++++++++++++++++++----------
 arch/x86/boot/compressed/head_64.S  | 56 +++++++++++++++++++++++++++----------
 arch/x86/include/asm/efi.h          | 31 +++++++-------------
 arch/x86/platform/efi/efi.c         | 20 ++++++-------
 arch/x86/platform/efi/efi_32.c      | 12 ++++----
 arch/x86/platform/efi/efi_64.c      |  6 ++--
 arch/x86/platform/efi/efi_stub_32.S |  4 +--
 drivers/firmware/efi/libstub/fdt.c  | 10 ++++++-
 drivers/firmware/efi/vars.c         | 14 +++++-----
 11 files changed, 140 insertions(+), 88 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
