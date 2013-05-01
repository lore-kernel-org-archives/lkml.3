Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab3EAWqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:46:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab3EAWqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:46:43 -0400
Date: Wed, 1 May 2013 15:45:58 -0700
Message-Id: <201305012245.r41Mjw5b013046@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.10
Cc: Andy Whitcroft <apw@canonical.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>, Borislav Petkov <bp@suse.de>,
        Chun-Yi Lee <jlee@suse.com>, Colin Cross <ccross@android.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jeremy Kerr <jk@ozlabs.org>, Kay Sievers <kay@vrfy.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garret <mjg59@srcf.ucam.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Mike Waychison <mikew@google.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tobias Powalowski <tpowa@archlinux.org>, Tom Gundersen <teg@jklm.no>,
        Tony Luck <tony.luck@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tony Luck <tony.luck@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The bulk of these changes are cleaning up the efivars handling and
breaking it up into a tree of files.  There are a number of fixes as
well.

The entire changeset is pretty big, but most of it is code movement.

Several of these commits are quite new; the history got very messed up
due to a mismerge with the urgent changes for rc8 which completely
broke IA64, and so Ingo requested that we rebase it to straighten it
out.

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

for you to fetch changes up to 7b2dd6d2c4db3912771bfcfd7ac7264011a3c831:

  efi: remove "kfree(NULL)" (2013-04-30 16:03:18 +0100)

----------------------------------------------------------------
Borislav Petkov (1):
      x86, efi: Make efi_memblock_x86_reserve_range more readable

Dan Carpenter (2):
      efi: locking fix in efivar_entry_set_safe()
      efi: remove "kfree(NULL)"

H. Peter Anvin (1):
      Merge remote-tracking branch 'efi/chainsaw' into x86/efi

Matt Fleming (9):
      efi: move utf16 string functions to efi.h
      efivars: Keep a private global pointer to efivars
      efivars: efivar_entry API
      efivars: Move pstore code into the new EFI directory
      efivarfs: Move to fs/efivarfs
      Merge tag 'v3.9' into efi-for-tip2
      efi, pstore: Initialise 'entry' before iterating
      efi, pstore: Remove entry from list when erasing
      efi, pstore: Read data from variable store before memcpy()

Tom Gundersen (1):
      efi: split efisubsystem from efivars

Wei Yongjun (1):
      efivarfs: convert to use simple_open()

 MAINTAINERS                       |   13 +-
 arch/ia64/Kconfig                 |    1 +
 arch/x86/platform/efi/efi.c       |   19 +-
 drivers/firmware/Kconfig          |   37 +-
 drivers/firmware/Makefile         |    2 +-
 drivers/firmware/efi/Kconfig      |   39 +
 drivers/firmware/efi/Makefile     |    6 +
 drivers/firmware/efi/efi-pstore.c |  251 +++++
 drivers/firmware/efi/efi.c        |  134 +++
 drivers/firmware/efi/efivars.c    |  616 +++++++++++
 drivers/firmware/efi/vars.c       | 1041 ++++++++++++++++++
 drivers/firmware/efivars.c        | 2117 -------------------------------------
 drivers/firmware/google/gsmi.c    |   31 +-
 fs/Kconfig                        |    1 +
 fs/Makefile                       |    1 +
 fs/efivarfs/Kconfig               |   12 +
 fs/efivarfs/Makefile              |    7 +
 fs/efivarfs/file.c                |  105 ++
 fs/efivarfs/inode.c               |  173 +++
 fs/efivarfs/internal.h            |   22 +
 fs/efivarfs/super.c               |  268 +++++
 include/linux/efi.h               |   90 +-
 22 files changed, 2796 insertions(+), 2190 deletions(-)

 create mode 100644 drivers/firmware/efi/Kconfig
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/efi-pstore.c
 create mode 100644 drivers/firmware/efi/efi.c
 create mode 100644 drivers/firmware/efi/efivars.c
 create mode 100644 drivers/firmware/efi/vars.c
 delete mode 100644 drivers/firmware/efivars.c
 create mode 100644 fs/efivarfs/Kconfig
 create mode 100644 fs/efivarfs/Makefile
 create mode 100644 fs/efivarfs/file.c
 create mode 100644 fs/efivarfs/inode.c
 create mode 100644 fs/efivarfs/internal.h
 create mode 100644 fs/efivarfs/super.c

[Full diff omitted due to size]

