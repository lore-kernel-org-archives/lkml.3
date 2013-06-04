Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3FDSyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:54:23 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:49992 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3FDSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:54:21 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: Mathias Krause <minipli@googlemail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86, mce: fix "braodcast" typo
Date: Tue,  4 Jun 2013 20:54:14 +0200
Message-Id: <1370372054-16635-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130604091203.GC23640@pd.tnic>
References: <20130604091203.GC23640@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the typo in MCJ_IRQ_BRAODCAST.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/include/asm/mce.h              |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index fa5f71e..6b52980 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -61,7 +61,7 @@
 #define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
 #define MCJ_EXCEPTION		0x8  /* raise as exception */
-#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
+#define MCJ_IRQ_BROADCAST	0x10 /* do IRQ broadcasting */
 
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index ddc72f8..5ac2d1f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -153,7 +153,7 @@ static void raise_mce(struct mce *m)
 		return;
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (m->inject_flags & (MCJ_IRQ_BRAODCAST | MCJ_NMI_BROADCAST)) {
+	if (m->inject_flags & (MCJ_IRQ_BROADCAST | MCJ_NMI_BROADCAST)) {
 		unsigned long start;
 		int cpu;
 
@@ -167,7 +167,7 @@ static void raise_mce(struct mce *m)
 				cpumask_clear_cpu(cpu, mce_inject_cpumask);
 		}
 		if (!cpumask_empty(mce_inject_cpumask)) {
-			if (m->inject_flags & MCJ_IRQ_BRAODCAST) {
+			if (m->inject_flags & MCJ_IRQ_BROADCAST) {
 				/*
 				 * don't wait because mce_irq_ipi is necessary
 				 * to be sync with following raise_local
-- 
1.7.10.4

