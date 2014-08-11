Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaHKXNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:13:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaHKXNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:13:09 -0400
Date: Mon, 11 Aug 2014 16:12:37 -0700
Message-Id: <201408112312.s7BNCb62025267@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/efi fixes for v3.17-rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: bonbons@linux-vserver.org, bp@suse.de, hpa@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two EFI-related Kconfig changes, which happen to touch immediately
adjacent lines in Kconfig and thus collapse to a single patch.

The following changes since commit 99a5603e2a1f146ac0c6414d8a3669aa749ccff8:

  efi/arm64: Handle missing virtual mapping for UEFI System Table (2014-07-18 21:24:04 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

for you to fetch changes up to 9e13bcf7e0981f1db0c8c8255ac17d5f898903e9:

  Merge tag 'efi-urgent' into x86/efi (2014-08-11 13:58:54 -0700)

----------------------------------------------------------------

H. Peter Anvin (1):
      Merge tag 'efi-urgent' into x86/efi

Matt Fleming (2):
      x86/efi: Fix 3DNow optimization build failure in EFI stub
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

 arch/x86/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3fc7d72..0e62af9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1536,7 +1536,8 @@ config EFI
 
 config EFI_STUB
        bool "EFI stub support"
-       depends on EFI
+       depends on EFI && !X86_USE_3DNOW
+       select RELOCATABLE
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
