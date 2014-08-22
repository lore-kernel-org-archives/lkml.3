Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaHVN7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270AbaHVN7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:59:15 -0400
From: harald@redhat.com
To: linux-kernel@vger.kernel.org
Cc: Harald Hoyer <harald@redhat.com>
Subject: [PATCH] early microcode: extend the ramdisk address to 64bit
Date: Fri, 22 Aug 2014 15:59:12 +0200
Message-Id: <1408715952-19573-1-git-send-email-harald@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Hoyer <harald@redhat.com>

commit 4bf7111f50167133a71c23530ca852a41355e739 enabled loading of the
initramfs above 4G addresses. So I was wondering, if the early microcode
code might want to honor the upper 32bit of the 64bit address.

Signed-off-by: Harald Hoyer <harald@redhat.com>
---
 arch/x86/kernel/cpu/microcode/amd_early.c   | 1 +
 arch/x86/kernel/cpu/microcode/intel_early.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 617a9e2..5b71346 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -56,6 +56,7 @@ static struct cpio_data __init find_ucode_in_initrd(void)
 #else
 	path    = ucode_path;
 	start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
+	start   |= (void *)boot_params.ext_ramdisk_image << 32;
 	size    = boot_params.hdr.ramdisk_size;
 #endif
 
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 18f7391..d2a9e1e 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -744,6 +744,7 @@ load_ucode_intel_bsp(void)
 		initrd_start_early, initrd_end_early, &uci);
 #else
 	ramdisk_image = boot_params.hdr.ramdisk_image;
+	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
 	initrd_end_early = initrd_start_early + ramdisk_size;
-- 
2.1.0

