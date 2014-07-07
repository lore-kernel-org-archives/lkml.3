Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaGGGni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:43:38 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45396 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGGGng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:43:36 -0400
Date: Mon, 7 Jul 2014 07:43:34 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20140707064334.GA2914@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, please pull the following fix from Ard that stops the arm64 EFI
stub being rebuilt on every arm64 kernel build by removing the
dependency on the generated header files.

The following changes since commit 783ee43118dc773bc8b0342c5b230e017d5a04d0:

  efi-pstore: Fix an overflow on 32-bit builds (2014-06-27 07:30:32 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a55c072dfe520f8fa03cf11b07b9268a8a17820a:

  efi/arm64: efistub: remove local copy of linux_banner (2014-07-07 07:26:02 +0100)

----------------------------------------------------------------
 * Remove a duplicate copy of linux_banner from the arm64 EFI stub
   which, apart from reducing code duplication also stops the arm64 stub
   being rebuilt every time make is invoked - Ard Biesheuvel

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: efistub: remove local copy of linux_banner

 arch/arm64/kernel/efi-stub.c |  2 --
 drivers/firmware/efi/fdt.c   | 10 ----------
 2 files changed, 12 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
