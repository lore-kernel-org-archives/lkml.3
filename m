Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3FNVbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:31:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34372 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3FNVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:31:31 -0400
Date: Fri, 14 Jun 2013 14:31:06 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-a795ab2d9c2113c63d2c9a0677012db13e746121@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, fenghua.yu@intel.com, tangchen@cn.fujitsu.com,
        tj@kernel.org, tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, fenghua.yu@intel.com, tangchen@cn.fujitsu.com,
        tj@kernel.org, trenn@suse.de, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-3-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, microcode: Use common get_ramdisk_{image|size}(
 )
Git-Commit-ID: a795ab2d9c2113c63d2c9a0677012db13e746121
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:31:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a795ab2d9c2113c63d2c9a0677012db13e746121
Gitweb:     http://git.kernel.org/tip/a795ab2d9c2113c63d2c9a0677012db13e746121
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:49 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:03:30 -0700

x86, microcode: Use common get_ramdisk_{image|size}()

In patch1, we change get_ramdisk_image() and get_ramdisk_size()
to global, so we can use them instead of using global variable
boot_params.

We need this to get correct ramdisk adress for 64bits bzImage
that initrd can be loaded above 4G by kexec-tools.

-v2: fix one typo that is found by Tang Chen

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-3-git-send-email-tangchen@cn.fujitsu.com
Cc: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_intel_early.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 2e9e128..54575a9 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -743,8 +743,8 @@ load_ucode_intel_bsp(void)
 	struct boot_params *boot_params_p;
 
 	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
-	ramdisk_image = boot_params_p->hdr.ramdisk_image;
-	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(boot_params_p);
+	ramdisk_size  = get_ramdisk_size(boot_params_p);
 	initrd_start_early = ramdisk_image;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
@@ -753,8 +753,8 @@ load_ucode_intel_bsp(void)
 		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
 		initrd_start_early, initrd_end_early, &uci);
 #else
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
