Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaF0Ovu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:51:50 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:35041 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaF0Ovt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:51:49 -0400
Date: Fri, 27 Jun 2014 15:51:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20140627145146.GB7539@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

Please pull the following EFI fixes. The fix from Catalin is the same as
the one I sent a week ago and Andrzej's patch fixes an efi-pstore issue
on 32-bit machines where efi-pstore variables don't appear in the
filesystem and so can never be deleted, potentially leading to
exhaustion of NVRAM space.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 783ee43118dc773bc8b0342c5b230e017d5a04d0:

  efi-pstore: Fix an overflow on 32-bit builds (2014-06-27 07:30:32 +0100)

----------------------------------------------------------------
 * Fix a few compiler warnings (one being a real bug) in the arm64 EFI
   code that lots of people are running into and reporting - Catalin Marinas

 * Use a cast to avoid a 32-bit overflow issue when generating pstore
   filenames - Andrzej Zaborowski

----------------------------------------------------------------
Andrzej Zaborowski (1):
      efi-pstore: Fix an overflow on 32-bit builds

Catalin Marinas (1):
      efi: Fix compiler warnings (unused, const, type)

 drivers/firmware/efi/efi-pstore.c | 2 +-
 drivers/firmware/efi/efi.c        | 6 +++---
 drivers/firmware/efi/fdt.c        | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
