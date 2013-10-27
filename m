Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3J0VsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:48:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60008 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807Ab3J0VsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:48:21 -0400
Date: Sun, 27 Oct 2013 21:48:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes
Message-ID: <20131027214815.GH1982@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, do you think we could get the EFI earlyprintk support into the
'x86/efi' branch for the upcoming merge window? I know it's quite late
in the game but since it's a new feature it shouldn't introduce any kind
of regression and is a much needed feature.

The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:

  boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 32c9e70fc3912c3b9c7d53ce016960ce99ff93d4:

  x86/efi: Add EFI framebuffer earlyprintk support (2013-10-27 21:18:48 +0000)

----------------------------------------------------------------
 * Add support for earlyprintk=efi which uses the EFI framebuffer. Very
   useful for debugging boot issues.

----------------------------------------------------------------
Matt Fleming (2):
      efi: Add asm-generic/efi.h for non-x86
      x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/ia64/include/asm/efi.h          |   6 ++
 arch/x86/Kconfig.debug               |   9 ++
 arch/x86/boot/compressed/eboot.c     |   1 -
 arch/x86/include/asm/efi.h           |  12 +++
 arch/x86/kernel/early_printk.c       |   6 ++
 arch/x86/kernel/setup.c              |   1 -
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |   1 -
 arch/x86/platform/efi/efi_32.c       |   1 -
 arch/x86/platform/efi/efi_64.c       |   1 -
 arch/x86/platform/uv/bios_uv.c       |   1 -
 include/asm-generic/efi.h            |  17 ++++
 include/linux/efi.h                  |  31 +-----
 15 files changed, 249 insertions(+), 38 deletions(-)
 create mode 100644 arch/ia64/include/asm/efi.h
 create mode 100644 arch/x86/platform/efi/early_printk.c
 create mode 100644 include/asm-generic/efi.h

-- 
Matt Fleming, Intel Open Source Technology Center
