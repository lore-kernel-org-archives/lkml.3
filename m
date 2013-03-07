Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3CGKog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:44:36 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18937 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3CGKof convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:44:35 -0500
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>,
        =?UTF-8?q?Bj=F6rn=20Davidsson?= <bjorn.davidsson@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH] Kprobes blacklist: Conditionally add x86-specific symbols
Date: Thu, 7 Mar 2013 11:44:30 +0100
Message-ID: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Björn Davidsson <bjorn.davidsson@sonymobile.com>

The kprobes blacklist contains x86-specific symbols.
Looking for these in kallsyms takes unnecessary time
during startup on non-X86 platform.
Added #ifdef CONFIG_X86 around them.

Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: BjÃ¶rn Davidsson <bjorn.davidsson@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 kernel/kprobes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e35be53..8c3796f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -95,9 +95,11 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
  */
 static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"preempt_schedule",},
+#ifdef CONFIG_X86
 	{"native_get_debugreg",},
 	{"irq_entries_start",},
 	{"common_interrupt",},
+#endif
 	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
-- 
1.7.8.6

