Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbbAUODJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:03:09 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45906 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbAUOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:02:54 -0500
Date: Wed, 21 Jan 2015 14:02:50 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [GIT PULL] EFI changes for v3.20
Message-ID: <20150121140250.GE12079@codeblueprint.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, please consider pulling the following changes for v3.20. There's
nothing super scary, mainly cleanups, and a merge from Ricardo who
kindly picked up some patches from the linux-efi mailing list while I
was out on annual leave in December.

Perhaps the biggest risk is the get_memory_map() change from Ard, which
changes the way that both the arm64 and x86 EFI boot stub build the
early memory map. It would be good to have it bake in linux-next for a
while.

One other thing to note is that I've picked up an rtc-efi patch from Ard
because the rtc maintainer hasn't been responsive for a while now.

The following changes since commit 8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e:

  x86, ptdump: Add section for EFI runtime services (2014-11-11 22:28:57 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 11629305043c513454c4ccb4fc384a1bfe610647:

  efi: Don't look for chosen@0 node on DT platforms (2015-01-20 22:41:56 +0000)

----------------------------------------------------------------
 * Move efivarfs from the misc filesystem section to pseudo filesystem,
   since that's a more logical and accurate place - Leif Lindholm

 * Update efibootmgr URL in Kconfig help - Peter Jones

 * Improve accuracy of EFI guid function names - Borislav Petkov

 * Expose firmware platform size in sysfs for the benefit of EFI boot
   loader installers and other utilities - Steve McIntyre

 * Cleanup __init annotations for arm64/efi code - Ard Biesheuvel

 * Mark the UIE as unsupported for rtc-efi - Ard Biesheuvel

 * Fix memory leak in error code path of runtime map code - Dan Carpenter

 * Improve robustness of get_memory_map() by removing assumptions on the
   size of efi_memory_desc_t (which could change in future spec
   versions) and querying the firmware instead of guessing about the
   memmap size - Ard Biesheuvel

 * Remove superfluous guid unparse calls - Ivan Khoronzhuk

 * Delete unnecessary chosen@0 DT node FDT code since was duplicated
   from code in drivers/of and is entirely unnecessary - Leif Lindholm

----------------------------------------------------------------
Ard Biesheuvel (3):
      arm64/efi: efistub: Apply __init annotation
      efi: rtc-efi: Mark UIE as unsupported
      efi/libstub: Call get_memory_map() to obtain map and desc sizes

Borislav Petkov (1):
      efi: Rename efi_guid_unparse to efi_guid_to_str

Dan Carpenter (1):
      efi: Small leak on error in runtime map code

Ivan Khoronzhuk (1):
      firmware: efi: Remove unneeded guid unparse

Leif Lindholm (2):
      fs: Make efivarfs a pseudo filesystem, built by default with EFI
      efi: Don't look for chosen@0 node on DT platforms

Matt Fleming (1):
      Merge tag 'rneri-efi-next' of https://github.com/ricardon/efi into next

Peter Jones (1):
      efi: Update the URLs for efibootmgr

Steve McIntyre (1):
      efi: Expose underlying UEFI firmware platform size to userland

 arch/arm64/kernel/efi-stub.c                   | 14 +++++++-------
 block/partitions/efi.c                         |  2 +-
 drivers/firmware/efi/Kconfig                   |  4 ++--
 drivers/firmware/efi/efi.c                     | 17 ++++++++++-------
 drivers/firmware/efi/efivars.c                 |  6 +++---
 drivers/firmware/efi/libstub/Makefile          | 14 ++++++++++++++
 drivers/firmware/efi/libstub/arm-stub.c        |  8 ++++----
 drivers/firmware/efi/libstub/efi-stub-helper.c | 18 +++++++++++-------
 drivers/firmware/efi/runtime-map.c             |  2 +-
 drivers/rtc/rtc-efi.c                          |  1 +
 fs/Kconfig                                     |  2 +-
 fs/efivarfs/Kconfig                            |  1 +
 fs/efivarfs/super.c                            |  2 +-
 include/linux/efi.h                            |  2 +-
 14 files changed, 58 insertions(+), 35 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
