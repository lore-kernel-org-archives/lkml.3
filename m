Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaDKRjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:39:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaDKRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:39:48 -0400
Date: Fri, 11 Apr 2014 10:39:27 -0700
Message-Id: <201404111739.s3BHdRiW025864@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/hyperv fix for v3.15-rc1
Cc: <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A single fix for HyperV -- we never NEED the legacy PIC on HyperV, and
in kexec/kdump scenarios we don't always know that we originally
booted EFI.  The right answer is probably to augment the legacy PIC
initialization code to detect a not-present PIC, but that is way too
high risk for right now.

The following changes since commit ca3ba2a2f4a49a308e7d78c784d51b2332064f15:

  x86, hyperv: Bypass the timer_irq_works() check (2014-03-27 11:02:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-hyperv-for-linus

for you to fetch changes up to 8df28b82ff0649dd293f0469b97792cfb9ed10ab:

  x86, hyperv: When on Hyper-v use NULL legacy PIC (2014-04-03 22:00:13 -0700)

----------------------------------------------------------------
K. Y. Srinivasan (1):
      x86, hyperv: When on Hyper-v use NULL legacy PIC

 arch/x86/kernel/cpu/mshyperv.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 832d05a914ba..b7d82c7e1257 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -93,14 +93,8 @@ static void __init ms_hyperv_init_platform(void)
 		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
 				lapic_timer_frequency);
 
-		/*
-		 * On Hyper-V, when we are booting off an EFI firmware stack,
-		 * we do not have many legacy devices including PIC, PIT etc.
-		 */
-		if (efi_enabled(EFI_BOOT)) {
-			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
-			legacy_pic = &null_legacy_pic;
-		}
+		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
+		legacy_pic = &null_legacy_pic;
 	}
 #endif
 
