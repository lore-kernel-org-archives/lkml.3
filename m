Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaBNNI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:08:58 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:36932 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbaBNNI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:08:56 -0500
Date: Fri, 14 Feb 2014 13:08:53 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20140214130853.GI20717@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been reports of EFI crashes since -rc1. The following two
commits fix known issues.

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 09503379dc99535b1bbfa51aa1aeef340f5d82ec:

  x86/efi: Check status field to validate BGRT header (2014-02-14 10:07:15 +0000)

----------------------------------------------------------------
 * Fix boot failure on 32-bit EFI due to the recent EFI memmap changes
   merged during the merge window - Borislav Petkov

 * Avoid a crash during efi_bgrt_init() by detecting invalid BGRT
   headers based on the 'status' field.

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Fix 32-bit fallout

Matt Fleming (1):
      x86/efi: Check status field to validate BGRT header

 arch/x86/include/asm/efi.h       | 2 ++
 arch/x86/platform/efi/efi-bgrt.c | 2 +-
 arch/x86/platform/efi/efi.c      | 5 ++---
 arch/x86/platform/efi/efi_32.c   | 6 ++++++
 arch/x86/platform/efi/efi_64.c   | 9 +++++++++
 5 files changed, 20 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
