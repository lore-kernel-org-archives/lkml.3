Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaDDAW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 20:22:27 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:52442
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbaDDAWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 20:22:23 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, hpa@zytor.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        "[3.13+]"@linuxonhyperv.com
Subject: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL legacy PIC
Date: Thu,  3 Apr 2014 18:16:33 -0700
Message-Id: <1396574193-12043-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the NULL legacy PIC when on Hyper-V. With this change we can support kexec
even when booting on EFI firmware. This patch has been tested on both EFI as
well as non-EFI firmware stacks on Hyper-V.

This patch is required to support kexec on EFI firmware on Hyper-V. Please
apply.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>        [3.13+]
---
 arch/x86/kernel/cpu/mshyperv.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 76f98fe..47359f7 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -133,14 +133,8 @@ static void __init ms_hyperv_init_platform(void)
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
 
-- 
1.7.4.1

