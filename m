Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3HEWD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:60114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab3HEWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341522"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/16] x86, asmlinkage, power: Make various symbols used by the suspend asm code visible
Date: Mon,  5 Aug 2013 15:02:49 -0700
Message-Id: <1375740170-7446-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/power/cpu.c          |  8 ++++----
 arch/x86/power/hibernate_64.c | 12 ++++++------
 kernel/power/hibernate.c      |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 1cf5b30..424f4c9 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,10 +25,10 @@
 #include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
-unsigned long saved_context_ebx;
-unsigned long saved_context_esp, saved_context_ebp;
-unsigned long saved_context_esi, saved_context_edi;
-unsigned long saved_context_eflags;
+__visible unsigned long saved_context_ebx;
+__visible unsigned long saved_context_esp, saved_context_ebp;
+__visible unsigned long saved_context_esi, saved_context_edi;
+__visible unsigned long saved_context_eflags;
 #endif
 struct saved_context saved_context;
 
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index a0fde91..304fca2 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -20,26 +20,26 @@
 #include <asm/suspend.h>
 
 /* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
+extern __visible const void __nosave_begin, __nosave_end;
 
 /* Defined in hibernate_asm_64.S */
-extern int restore_image(void);
+extern asmlinkage int restore_image(void);
 
 /*
  * Address to jump to in the last phase of restore in order to get to the image
  * kernel's text (this value is passed in the image header).
  */
-unsigned long restore_jump_address;
+unsigned long restore_jump_address __visible;
 
 /*
  * Value of the cr3 register from before the hibernation (this value is passed
  * in the image header).
  */
-unsigned long restore_cr3;
+unsigned long restore_cr3 __visible;
 
-pgd_t *temp_level4_pgt;
+pgd_t *temp_level4_pgt __visible;
 
-void *relocated_restore_code;
+void *relocated_restore_code __visible;
 
 static void *alloc_pgt_page(void *context)
 {
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26f5f1..3085e62 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -39,7 +39,7 @@ static int resume_delay;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
-int in_suspend __nosavedata;
+__visible int in_suspend __nosavedata;
 
 enum {
 	HIBERNATION_INVALID,
-- 
1.8.3.1

