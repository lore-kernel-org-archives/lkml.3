Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaKFQDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:03:15 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36854 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:02:54 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RESEND PATCH 3.18-rc3 3/3] kdb: Const qualifier for kdb_getstr's prompt argument
Date: Thu,  6 Nov 2014 16:02:26 +0000
Message-Id: <1415289746-30917-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
References: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
 <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All current callers of kdb_getstr() can pass constant pointers via the
prompt argument. This patch adds a const qualification to make explicit
the fact that this is safe.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 kernel/debug/kdb/kdb_io.c      | 2 +-
 kernel/debug/kdb/kdb_private.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 70e0f49..59a6071 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -439,7 +439,7 @@ poll_again:
  *	substituted for %d, %x or %o in the prompt.
  */
 
-char *kdb_getstr(char *buffer, size_t bufsize, char *prompt)
+char *kdb_getstr(char *buffer, size_t bufsize, const char *prompt)
 {
 	if (prompt && kdb_prompt_str != prompt)
 		strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 30ed4f3..aa90a6a 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -212,7 +212,7 @@ extern void kdb_ps1(const struct task_struct *p);
 extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
 extern void kdb_meminfo_proc_show(void);
-extern char *kdb_getstr(char *, size_t, char *);
+extern char *kdb_getstr(char *, size_t, const char *);
 extern void kdb_gdb_state_pass(char *buf);
 
 /* Defines for kdb_symbol_print */
-- 
1.9.3

