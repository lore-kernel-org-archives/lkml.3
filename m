Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaHVHw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:52:26 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49200 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaHVHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:52:25 -0400
Date: Fri, 22 Aug 2014 08:52:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20140822075221.GK29733@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, please pull the following fixes, which trade the locking
WARN_ON()s in the efivars code for the more usual lockdep_*() functions
and an arm64 EFI change that allows the gamut of runtime services to be
invoked.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 6a7519e81321343165f89abb8b616df186d3e57a:

  efi/arm64: Store Runtime Services revision (2014-08-22 08:45:41 +0100)

----------------------------------------------------------------
 * WARN_ON(!spin_is_locked()) always triggers on non-SMP machines.
   Swap it for the more canonical lockdep_assert_held() which always
   does the right thing - Guenter Roeck

 * Assign the correct value to efi.runtime_version on arm64 so that all
   the runtime services can be invoked - Semen Protsenko

----------------------------------------------------------------
Guenter Roeck (1):
      firmware: Do not use WARN_ON(!spin_is_locked())

Semen Protsenko (1):
      efi/arm64: Store Runtime Services revision

 arch/arm64/kernel/efi.c     | 2 ++
 drivers/firmware/efi/vars.c | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
