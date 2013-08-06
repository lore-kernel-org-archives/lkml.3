Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3HFVpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:45:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3HFVpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:45:02 -0400
Date: Tue, 6 Aug 2013 14:44:51 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-d6efc2f7240b4e55590df69d74f33fdb72ce934a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-16-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-16-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, power:
  Make various symbols used by the suspend asm code visible
Git-Commit-ID: d6efc2f7240b4e55590df69d74f33fdb72ce934a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:44:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6efc2f7240b4e55590df69d74f33fdb72ce934a
Gitweb:     http://git.kernel.org/tip/d6efc2f7240b4e55590df69d74f33fdb72ce934a
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:21:03 -0700

x86, asmlinkage, power: Make various symbols used by the suspend asm code visible

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-16-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
