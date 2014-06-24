Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaFXLZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:25:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36200 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaFXLZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:25:09 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86, CPU: Kill cpu_has_mp
Date: Tue, 24 Jun 2014 13:25:05 +0200
Message-Id: <1403609105-8332-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403609105-8332-1-git-send-email-bp@alien8.de>
References: <1403609105-8332-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It was used only for checking for some K7s which didn't have MP support,
see

http://www.hardwaresecrets.com/article/How-to-Transform-an-Athlon-XP-into-an-Athlon-MP/24

and it was unconditionally set on 64-bit for no reason. Kill it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 327a061f32df..bb9b258d60e7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -315,7 +315,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
 #define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
-#define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
 #define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
 #define cpu_has_cyrix_arr	boot_cpu_has(X86_FEATURE_CYRIX_ARR)
@@ -362,9 +361,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #undef  cpu_has_pae
 #define cpu_has_pae		___BUG___
 
-#undef  cpu_has_mp
-#define cpu_has_mp		1
-
 #undef  cpu_has_k6_mtrr
 #define cpu_has_k6_mtrr		0
 
-- 
2.0.0

