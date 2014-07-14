Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaGNMyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:54:45 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:41750 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaGNMyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:54:36 -0400
Date: Mon, 14 Jul 2014 13:54:32 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20140714125432.GI5952@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, please pull the following urgent fixes. Of particular importance
is the patch from Michael that fixes a memory corruption bug in the x86
EFI boot stub.

The following changes since commit 783ee43118dc773bc8b0342c5b230e017d5a04d0:

  efi-pstore: Fix an overflow on 32-bit builds (2014-06-27 07:30:32 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to c7fb93ec51d462ec3540a729ba446663c26a0505:

  x86/efi: Include a .bss section within the PE/COFF headers (2014-07-10 14:21:39 +0100)

----------------------------------------------------------------
 * Remove a duplicate copy of linux_banner from the arm64 EFI stub
   which, apart from reducing code duplication also stops the arm64 stub
   being rebuilt every time make is invoked - Ard Biesheuvel

 * Fix the EFI fdt code to not report a boot error if UEFI is
   unavailable since booting without UEFI parameters is a valid use case
   for non-UEFI platforms - Catalin Marinas

 * Include a .bss section in the EFI boot stub PE/COFF headers to fix a
   memory corruption bug - Michael Brown

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: efistub: remove local copy of linux_banner

Catalin Marinas (1):
      efi: fdt: Do not report an error during boot if UEFI is not available

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

 arch/arm64/kernel/efi-stub.c |  2 --
 arch/x86/boot/header.S       | 26 ++++++++++++++++++++++----
 arch/x86/boot/tools/build.c  | 38 ++++++++++++++++++++++++++++++--------
 drivers/firmware/efi/efi.c   | 22 +++++++++++++++-------
 drivers/firmware/efi/fdt.c   | 10 ----------
 5 files changed, 67 insertions(+), 31 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
