Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbaGWUM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:12:26 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49437 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933025AbaGWULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:05 -0400
X-Sasl-enc: 6h0BvH8FUVq8CTIKlt20C9SBrKgLPFplM4TmqXsFc3GC 1406146264
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 4/8] x86, microcode, intel: fix missing declaration
Date: Wed, 23 Jul 2014 17:10:47 -0300
Message-Id: <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename apply_microcode() in microcode/intel.c to apply_microcode_intel(),
and declare it as extern in the asm/microcode_intel.h header.

This is a cosmetic fix to silence a warning issued by sparse.  It brings
the microcode/intel.c driver in line with what microcode/amd.c is doing.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/include/asm/microcode_intel.h |    1 +
 arch/x86/kernel/cpu/microcode/intel.c  |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 9067166..2bdbc6b 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -62,6 +62,7 @@ extern int microcode_sanity_check(void *mc, int print_err);
 extern int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev);
 extern int
 update_match_revision(struct microcode_header_intel *mc_header, int rev);
+extern int apply_microcode_intel(int cpu);
 
 #ifdef CONFIG_MICROCODE_INTEL_EARLY
 extern void __init load_ucode_intel_bsp(void);
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index a276fa7..a51cb19 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -127,7 +127,7 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	return get_matching_microcode(csig, cpf, mc_intel, crev);
 }
 
-int apply_microcode(int cpu)
+int apply_microcode_intel(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
@@ -314,7 +314,7 @@ static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
-	.apply_microcode                  = apply_microcode,
+	.apply_microcode                  = apply_microcode_intel,
 	.microcode_fini_cpu               = microcode_fini_cpu,
 };
 
-- 
1.7.10.4

