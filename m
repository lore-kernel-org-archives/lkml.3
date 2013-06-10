Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3FJVgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:36:36 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60947 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab3FJVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:36:35 -0400
Date: Mon, 10 Jun 2013 22:36:32 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20130610213632.GF31198@console-pimps.org>
References: <20130607115046.GN30420@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607115046.GN30420@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
 
The following changes since commit eccaf52fee8305d5207ff110950a82c100e459bc:

  x86, efi: initial the local variable of DataSize to zero (2013-05-14 08:13:05 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to f8b8404337de4e2466e2e1139ea68b1f8295974f:

  Modify UEFI anti-bricking code (2013-06-10 21:59:37 +0100)

----------------------------------------------------------------
 * More tweaking to the EFI variable anti-bricking algorithm. Quite a
   few users were reporting boot regressions in v3.9. This has now been
   fixed with a more accurate "minimum storage requirement to avoid
   bricking" value from Samsung (5K instead of 50%) and code to trigger
   garbage collection when we near our limit - Matthew Garrett.

----------------------------------------------------------------
Matthew Garrett (1):
      Modify UEFI anti-bricking code

 arch/x86/boot/compressed/eboot.c      |  47 ---------
 arch/x86/include/asm/efi.h            |   7 --
 arch/x86/include/uapi/asm/bootparam.h |   1 -
 arch/x86/platform/efi/efi.c           | 188 ++++++++++++----------------------
 4 files changed, 65 insertions(+), 178 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
