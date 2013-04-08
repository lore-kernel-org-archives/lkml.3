Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994Ab3DHQal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:30:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934597Ab3DHQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:30:37 -0400
Date: Mon, 8 Apr 2013 09:29:44 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-042c16f14161fb569fd1a60b908c5196109052da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1365436666-9837-5-git-send-email-bp@alien8.de>
References: <1365436666-9837-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, CPU, AMD: Drop useless label
Git-Commit-ID: 042c16f14161fb569fd1a60b908c5196109052da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 09:29:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  042c16f14161fb569fd1a60b908c5196109052da
Gitweb:     http://git.kernel.org/tip/042c16f14161fb569fd1a60b908c5196109052da
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 8 Apr 2013 17:57:46 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 8 Apr 2013 09:07:18 -0700

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
