Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936840Ab3DHP6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:58:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936790Ab3DHP6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:58:15 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4/4] x86, CPU, AMD: Drop useless label
Date: Mon,  8 Apr 2013 17:57:46 +0200
Message-Id: <1365436666-9837-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
In-Reply-To: <1365436666-9837-1-git-send-email-bp@alien8.de>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

All we want to do is return from this function so stop jumping around
like a flea for no good reason.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/amd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index cea02d703bca..5013a48d1aff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -192,11 +192,11 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	/* Athlon 660/661 is valid. */
 	if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
 	    (c->x86_mask == 1)))
-		goto valid_k7;
+		return;
 
 	/* Duron 670 is valid */
 	if ((c->x86_model == 7) && (c->x86_mask == 0))
-		goto valid_k7;
+		return;
 
 	/*
 	 * Athlon 662, Duron 671, and Athlon >model 7 have capability
@@ -209,7 +209,7 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
 	     (c->x86_model > 7))
 		if (cpu_has_mp)
-			goto valid_k7;
+			return;
 
 	/* If we get here, not a certified SMP capable AMD system. */
 
@@ -220,9 +220,6 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
 	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
-
-valid_k7:
-	;
 }
 
 static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
-- 
1.8.2.135.g7b592fa

