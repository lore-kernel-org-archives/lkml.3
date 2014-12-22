Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaLVUHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:07:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55979 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbaLVUHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:07:08 -0500
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, mce: Fix sparse errors
Date: Mon, 22 Dec 2014 21:07:04 +0100
Message-Id: <1419278824-32123-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Make stuff used in mce.c only, static.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 323e02c658af..4c5cd7575d31 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -115,7 +115,7 @@ static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
  */
-ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
+static ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
 
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
@@ -529,7 +529,7 @@ static void mce_schedule_work(void)
 		schedule_work(this_cpu_ptr(&mce_work));
 }
 
-DEFINE_PER_CPU(struct irq_work, mce_irq_work);
+static DEFINE_PER_CPU(struct irq_work, mce_irq_work);
 
 static void mce_irq_work_cb(struct irq_work *entry)
 {
@@ -1012,7 +1012,7 @@ static void mce_clear_state(unsigned long *toclear)
  */
 #define	MCE_INFO_MAX	16
 
-struct mce_info {
+static struct mce_info {
 	atomic_t		inuse;
 	struct task_struct	*t;
 	__u64			paddr;
-- 
2.2.0.33.gc18b867

