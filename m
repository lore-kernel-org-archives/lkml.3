Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab3DPNzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:55:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41942 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803Ab3DPNzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:55:14 -0400
Date: Tue, 16 Apr 2013 06:54:21 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-1077c932db63ecc571c31df1c24d4a44e30928e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1365436666-9837-5-git-send-email-bp@alien8.de>
References: <1365436666-9837-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, CPU, AMD: Drop useless label
Git-Commit-ID: 1077c932db63ecc571c31df1c24d4a44e30928e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Apr 2013 06:54:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1077c932db63ecc571c31df1c24d4a44e30928e5
Gitweb:     http://git.kernel.org/tip/1077c932db63ecc571c31df1c24d4a44e30928e5
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 8 Apr 2013 17:57:46 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Tue, 16 Apr 2013 11:50:51 +0200

x86, CPU, AMD: Drop useless label

All we want to do is return from this function so stop jumping around
like a flea for no good reason.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1365436666-9837-5-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index cea02d7..5013a48 100644
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
