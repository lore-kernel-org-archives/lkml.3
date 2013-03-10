Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3CJGqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:46:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18962 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3CJGqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:46:05 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v2 02/20] x86, microcode: Use common get_ramdisk_image()
Date: Sat,  9 Mar 2013 22:44:29 -0800
Message-Id: <1362897887-30808-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common get_ramdisk_image() to get ramdisk start phys address.

We need this to get correct ramdisk adress for 64bit bzImage that
initrd can be loaded above 4G by kexec-tools.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/microcode_intel_early.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 7890bc8..a8df75f 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -742,8 +742,8 @@ load_ucode_intel_bsp(void)
 	struct boot_params *boot_params_p;
 
 	boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
-	ramdisk_image = boot_params_p->hdr.ramdisk_image;
-	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(boot_params_p);
+	ramdisk_size  = get_ramdisk_image(boot_params_p);
 	initrd_start_early = ramdisk_image;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
@@ -752,8 +752,8 @@ load_ucode_intel_bsp(void)
 		(unsigned long *)__pa_symbol(&mc_saved_in_initrd),
 		initrd_start_early, initrd_end_early, &uci);
 #else
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
-- 
1.7.10.4

