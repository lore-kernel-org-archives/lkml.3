Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3A2WOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:14:46 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26749 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab3A2WOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:14:44 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z37d5kzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
X-WSS-ID: 0MHER4B-02-DUY-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
CC: <Jacob.Shin@amd.com>, <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH v2 1/2] AMD,x86: Clean up init_amd()
Date: Tue, 29 Jan 2013 17:14:36 -0500
Message-ID: <1359497676-24722-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up multiple declarations of variable used for rd/wrmsr

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 15239ff..dd4a5b6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -518,10 +518,9 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
-
-#ifdef CONFIG_SMP
 	unsigned long long value;
 
+#ifdef CONFIG_SMP
 	/*
 	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
 	 * bit 6 of msr C001_0015
@@ -559,12 +558,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * (AMD Erratum #110, docId: 25759).
 		 */
 		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
-			u64 val;
-
 			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
-			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
-				val &= ~(1ULL << 32);
-				wrmsrl_amd_safe(0xc001100d, val);
+			if (!rdmsrl_amd_safe(0xc001100d, &value)) {
+				value &= ~(1ULL << 32);
+				wrmsrl_amd_safe(0xc001100d, value);
 			}
 		}
 
@@ -617,13 +614,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if ((c->x86 == 0x15) &&
 	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
-		u64 val;
 
-		if (!rdmsrl_safe(0xc0011005, &val)) {
-			val |= 1ULL << 54;
-			wrmsrl_safe(0xc0011005, val);
-			rdmsrl(0xc0011005, val);
-			if (val & (1ULL << 54)) {
+		if (!rdmsrl_safe(0xc0011005, &value)) {
+			value |= 1ULL << 54;
+			wrmsrl_safe(0xc0011005, value);
+			rdmsrl(0xc0011005, value);
+			if (value & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
 				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
 				  "disabled Topology Extensions Support\n");
@@ -637,11 +633,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 */
 	if ((c->x86 == 0x15) &&
 	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
-		u64 val;
 
-		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
-			val |= 0x1E;
-			wrmsrl_safe(0xc0011021, val);
+		if (!rdmsrl_safe(0xc0011021, &value) && !(value & 0x1E)) {
+			value |= 0x1E;
+			wrmsrl_safe(0xc0011021, value);
 		}
 	}
 
-- 
1.7.1


