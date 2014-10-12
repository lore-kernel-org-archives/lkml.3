Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaJLTJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:09:35 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44669 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaJLTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:09:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Kees Cook <keescook@chromium.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: debug: kdb: kdb_main.c:  Replacing strncat with strlcat to avoid overwrite size
Date: Sun, 12 Oct 2014 21:11:40 +0200
Message-Id: <1413141100-21315-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat with strlcat to avoid overwrite the max size

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 379650b..eb8b6c4 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1254,7 +1254,7 @@ do_full_getstr:
 		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"));
 #endif
 		if (defcmd_in_progress)
-			strncat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
+			strlcat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
 
 		/*
 		 * Fetch command from keyboard
-- 
1.7.10.4

