Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab3GRLuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:50:35 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33409 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3GRLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:50:31 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-02-51e7d684eb27
Subject: [PATCH -tip 1/3] [CLEANUP] kprobes/x86: Remove an incorrect comment
 about int3 in NMI/MCE
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Date: Thu, 18 Jul 2013 20:47:47 +0900
Message-ID: <20130718114747.26675.84110.stgit@mhiramat-M0-7522>
In-Reply-To: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a comment about an int3 issue in NMI/MCE, since
the commit 3f3c8b8c already fixed that. Keeping this
incorrect comment can mislead developers.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/kprobes/opt.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 76dc6f0..d7d8a8c 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -415,11 +415,6 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 			break;
 	}
 
-	/*
-	 * text_poke_smp doesn't support NMI/MCE code modifying.
-	 * However, since kprobes itself also doesn't support NMI/MCE
-	 * code probing, it's not a problem.
-	 */
 	text_poke_smp_batch(jump_poke_params, c);
 }
 
@@ -455,11 +450,6 @@ extern void arch_unoptimize_kprobes(struct list_head *oplist,
 			break;
 	}
 
-	/*
-	 * text_poke_smp doesn't support NMI/MCE code modifying.
-	 * However, since kprobes itself also doesn't support NMI/MCE
-	 * code probing, it's not a problem.
-	 */
 	text_poke_smp_batch(jump_poke_params, c);
 }
 

