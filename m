Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3GUNo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 09:44:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3GUNo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 09:44:26 -0400
Date: Sun, 21 Jul 2013 06:43:31 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-c7e85c42be68fca743df58a306edd29aa295e155@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, jbaron@akamai.com, masami.hiramatsu.pt@hitachi.com,
        bpetkov@suse.de, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, jbaron@akamai.com, masami.hiramatsu.pt@hitachi.com,
        bpetkov@suse.de, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130718114747.26675.84110.stgit@mhiramat-M0-7522>
References: <20130718114747.26675.84110.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86:
  Remove an incorrect comment about int3 in NMI/MCE
Git-Commit-ID: c7e85c42be68fca743df58a306edd29aa295e155
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Jul 2013 06:43:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7e85c42be68fca743df58a306edd29aa295e155
Gitweb:     http://git.kernel.org/tip/c7e85c42be68fca743df58a306edd29aa295e155
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 18 Jul 2013 20:47:47 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Jul 2013 09:57:03 +0200

kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE

Remove a comment about an int3 issue in NMI/MCE, since
commit:

  3f3c8b8c4b2a ("x86: Add workaround to NMI iret woes")

already fixed that. Keeping this incorrect comment can mislead developers.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Borislav Petkov <bpetkov@suse.de>
Link: http://lkml.kernel.org/r/20130718114747.26675.84110.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/opt.c | 10 ----------
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
 
