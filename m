Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaI1U1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:27:09 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49857 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaI1U1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:27:07 -0400
Date: Sun, 28 Sep 2014 21:27:02 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.18
Message-ID: <20140928202702.GB18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This pull request is coming later than I had intended, sorry about that.
It unfortunately got pushed out by a number of things, chasing bugs,
releases for other projects, etc.

Merging this tag into Linus' tree causes some conflicts, which I've
fixed up and pushed out as the efi-next-merge branch, in case you or
Linus want to take a look at it. The conflicts are fairly straight
forward to resolve.

The following changes since commit 99a5603e2a1f146ac0c6414d8a3669aa749ccff8:

  efi/arm64: Handle missing virtual mapping for UEFI System Table (2014-07-18 21:24:04 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 1eb56e1adab89d36f071db4277a3c4610970215f:

  x86/efi: Adding efi_printks on memory allocationa and pci.reads (2014-09-28 17:43:21 +0100)

----------------------------------------------------------------
 * Implement new EFI runtime lock which is required by the UEFI
   specification - Ard Biesheuvel

 * Add new efi= x86 EFI boot stub parameter which mimics the way that
   the regular kernel parameter works - Matt Fleming

 * Improve error handling in efi-bgrt driver - Josh Triplett

 * Extend the "noefi" kernel parameter to arm64, add an efi=noruntime
   synonym - Dave Young

 * Beautify the EFI memory map logs - Laszlo Ersek

 * Fix compiler shadow warnings and improve variable names - Mark Rustad

 * Remove unused efi_call() macros, update comments, tag initialization
   functions with __init - Mathias Krause

 * Add more informative efi_printk()s to the x86 EFI boot stub at the
   firmware call-sites - Andre Müller

----------------------------------------------------------------
Andre Müller (1):
      x86/efi: Adding efi_printks on memory allocationa and pci.reads

Ard Biesheuvel (1):
      efi: Implement mandatory locking for UEFI Runtime Services

Dave Young (6):
      efi: Move noefi early param code out of x86 arch code
      lib: Add a generic cmdline parse function parse_option_str
      efi: Add kernel param efi=noruntime
      arm64/efi: uefi_init error handling fix
      arm64/efi: Do not enter virtual mode if booting with efi=noruntime or noefi
      x86/efi: Clear EFI_RUNTIME_SERVICES if failing to enter virtual mode

Josh Triplett (1):
      efi-bgrt: Add error handling; inform the user when ignoring the BGRT

Laszlo Ersek (5):
      efi: Add macro for EFI_MEMORY_UCE memory attribute
      efi: Introduce efi_md_typeattr_format()
      x86: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      ia64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      arm64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()

Mark Rustad (1):
      efi: Resolve some shadow warnings

Mathias Krause (4):
      x86/efi: Remove unused efi_call* macros
      x86/efi: Unexport add_efi_memmap variable
      x86/efi: Update comment regarding required phys mapped EFI services
      x86/efi: Mark initialization code as such

Matt Fleming (1):
      efi: Add efi= parameter parsing to the EFI boot stub

 Documentation/kernel-parameters.txt            |   8 +-
 arch/arm64/kernel/efi.c                        |  44 +++----
 arch/ia64/kernel/efi.c                         |   6 +-
 arch/x86/boot/compressed/eboot.c               |  32 +++--
 arch/x86/include/asm/efi.h                     |  33 ++----
 arch/x86/platform/efi/efi-bgrt.c               |  36 +++++-
 arch/x86/platform/efi/efi.c                    |  52 ++++-----
 arch/x86/platform/efi/efi_32.c                 |  12 +-
 arch/x86/platform/efi/efi_64.c                 |   6 +-
 arch/x86/platform/efi/efi_stub_32.S            |   4 +-
 drivers/firmware/efi/efi.c                     |  79 +++++++++++++
 drivers/firmware/efi/libstub/arm-stub.c        |   4 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  62 +++++++++-
 drivers/firmware/efi/runtime-wrappers.c        | 154 +++++++++++++++++++++++--
 drivers/firmware/efi/vars.c                    |  14 +--
 include/linux/efi.h                            |  11 ++
 include/linux/kernel.h                         |   1 +
 lib/cmdline.c                                  |  29 +++++
 18 files changed, 465 insertions(+), 122 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
