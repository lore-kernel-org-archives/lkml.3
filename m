Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaAKUtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:49:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56792 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAKUtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:49:40 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/4] EFI memmap fix v2
Date: Sat, 11 Jan 2014 21:49:26 +0100
Message-Id: <1389473370-1940-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Ok, here's v2 rebased and rediffed against tip (which has the relevant
efi branches).

Toshi, I'm pushing it to:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi-fixes

so that you can give it another run and so that the build robot can poke
at it.

Thanks.

Changelog:

* v1:

this is the result of Toshi and me debugging a #GP on one of his big HP
boxes sporting UEFI. Each commit message should be self-explanatory so
please look there.

This has more or less an RFC nature thus I'm sending it now to collect
feedback. It is going to wait in the EFI queue anyway after the kexec
stuff gets sorted out first.

Comments and suggestions as always are very much appreciated.

Borislav Petkov (4):
  x86, ptdump: Add the functionality to dump an arbitrary pagetable
  efi: Dump the EFI page table
  x86, pageattr: Export page unmapping interface
  efi: Make efi virtual runtime map passing more robust

 arch/x86/include/asm/efi.h           |  3 +-
 arch/x86/include/asm/pgtable.h       |  3 +-
 arch/x86/include/asm/pgtable_types.h |  2 +
 arch/x86/mm/dump_pagetables.c        | 77 ++++++++++++++++++++++++------------
 arch/x86/mm/pageattr.c               | 44 +++++++++++++++------
 arch/x86/platform/efi/efi.c          | 73 ++++++++++++++++++++++++++--------
 arch/x86/platform/efi/efi_32.c       |  6 ++-
 arch/x86/platform/efi/efi_64.c       | 31 +++++++++++++--
 8 files changed, 177 insertions(+), 62 deletions(-)

-- 
1.8.5.2.192.g7794a68

