Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaLFPbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:31:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54216 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaLFPbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:31:51 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86, microcode, intel: Drop unused parameter
Date: Sat,  6 Dec 2014 16:31:46 +0100
Message-Id: <1417879908-4851-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1417879908-4851-1-git-send-email-bp@alien8.de>
References: <1417879908-4851-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

apply_microcode_early() doesn't use mc_saved_data, kill it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/intel_early.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index b88343f7a3b3..31e7576a123c 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -650,8 +650,7 @@ static inline void print_ucode(struct ucode_cpu_info *uci)
 }
 #endif
 
-static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
-				 struct ucode_cpu_info *uci)
+static int apply_microcode_early(struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
@@ -720,7 +719,7 @@ _load_ucode_intel_bsp(struct mc_saved_data *mc_saved_data,
 		       mc_saved_in_initrd, uci);
 	load_microcode(mc_saved_data, mc_saved_in_initrd,
 		       initrd_start_early, uci);
-	apply_microcode_early(mc_saved_data, uci);
+	apply_microcode_early(uci);
 }
 
 void __init
@@ -783,5 +782,5 @@ void load_ucode_intel_ap(void)
 	collect_cpu_info_early(&uci);
 	load_microcode(mc_saved_data_p, mc_saved_in_initrd_p,
 		       initrd_start_addr, &uci);
-	apply_microcode_early(mc_saved_data_p, &uci);
+	apply_microcode_early(&uci);
 }
-- 
2.0.0

