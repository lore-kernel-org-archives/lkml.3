Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaDDFQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDDFQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:16:02 -0400
Date: Thu, 3 Apr 2014 22:15:38 -0700
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-8df28b82ff0649dd293f0469b97792cfb9ed10ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1396574193-12043-1-git-send-email-kys@microsoft.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv: When on Hyper-v use NULL legacy PIC
Git-Commit-ID: 8df28b82ff0649dd293f0469b97792cfb9ed10ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8df28b82ff0649dd293f0469b97792cfb9ed10ab
Gitweb:     http://git.kernel.org/tip/8df28b82ff0649dd293f0469b97792cfb9ed10ab
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Thu, 3 Apr 2014 18:16:33 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 3 Apr 2014 22:00:13 -0700

x86, hyperv: When on Hyper-v use NULL legacy PIC

Use the NULL legacy PIC when on Hyper-V. With this change we can support kexec
even when booting on EFI firmware. This patch has been tested on both EFI as
well as non-EFI firmware stacks on Hyper-V.

This patch is required to support kexec on EFI firmware on Hyper-V. Please
apply.

[ hpa: HyperV in EFI mode doesn't include a legacy PIC, and apparently
doesn't stub it out in a meaningful way.  This becomes an issue
after kexec if the second kernel doesn't know it is EFI-booted.
Since HyperV presumably never actually *needs* the legacy PIC, we
can just disable it. ]

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1396574193-12043-1-git-send-email-kys@microsoft.com
Cc: <stable@vger.kernel.org>        [3.13+]
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 832d05a..b7d82c7 100644
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
 
