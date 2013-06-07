Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3FGLuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:50:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60172 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab3FGLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:50:53 -0400
Date: Fri, 7 Jun 2013 12:50:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20130607115046.GN30420@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

The following changes since commit eccaf52fee8305d5207ff110950a82c100e459bc:

  x86, efi: initial the local variable of DataSize to zero (2013-05-14 08:13:05 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to d70005bfc5f47f74fb5cb77a84983ed26bf65557:

  efi: Convert runtime services function ptrs (2013-06-06 11:07:07 +0100)

----------------------------------------------------------------
 * More tweaking to the EFI variable anti-bricking algorithm. Quite a
   few users were reporting boot regressions in v3.9. This has now been
   fixed with a more accurate "minimum storage requirement to avoid
   bricking" value from Samsung (5K instead of 50%) and code to trigger
   garbage collection when we near our limit - Matthew Garrett.

 * A small cleanup to get rid of all the void * casting that is
   prevalent in the EFI code - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (1):
      efi: Convert runtime services function ptrs

Matthew Garrett (1):
      Modify UEFI anti-bricking code

 arch/x86/boot/compressed/eboot.c      |  47 ---------
 arch/x86/include/asm/efi.h            |  35 +++----
 arch/x86/include/uapi/asm/bootparam.h |   1 -
 arch/x86/platform/efi/efi.c           | 188 ++++++++++++----------------------
 include/linux/efi.h                   |  28 ++---
 5 files changed, 93 insertions(+), 206 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
