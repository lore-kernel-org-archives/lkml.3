Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaGNTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:25:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbaGNTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:25:07 -0400
Date: Mon, 14 Jul 2014 12:24:53 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-af0fa6f6b5851761e9fbf79eb14ba86e857b4e7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1403609105-8332-4-git-send-email-bp@alien8.de>
References: <1403609105-8332-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpu: Kill cpu_has_mp
Git-Commit-ID: af0fa6f6b5851761e9fbf79eb14ba86e857b4e7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af0fa6f6b5851761e9fbf79eb14ba86e857b4e7b
Gitweb:     http://git.kernel.org/tip/af0fa6f6b5851761e9fbf79eb14ba86e857b4e7b
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 24 Jun 2014 13:25:05 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 14 Jul 2014 12:21:40 -0700

x86, cpu: Kill cpu_has_mp

It was used only for checking for some K7s which didn't have MP support,
see

http://www.hardwaresecrets.com/article/How-to-Transform-an-Athlon-XP-into-an-Athlon-MP/24

and it was unconditionally set on 64-bit for no reason. Kill it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1403609105-8332-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 327a061..bb9b258 100644
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
 
