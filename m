Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaGZOna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:43:30 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41800 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGZOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:43:29 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jason Wessel <jason.wessel@windriver.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: debug: kdb: kdb_io.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:44:55 +0200
Message-Id: <1406385895-3886-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/debug/kdb/kdb_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 7c70812..27977c0 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -361,9 +361,9 @@ poll_again:
 			kdb_printf("%s", buffer);
 		} else if (tab != 2 && count > 0) {
 			len_tmp = strlen(p_tmp);
-			strncpy(p_tmp+len_tmp, cp, lastchar-cp+1);
+			strlcpy(p_tmp+len_tmp, cp, lastchar-cp+1);
 			len_tmp = strlen(p_tmp);
-			strncpy(cp, p_tmp+len, len_tmp-len + 1);
+			strlcpy(cp, p_tmp+len, len_tmp-len + 1);
 			len = len_tmp - len;
 			kdb_printf("%s", cp);
 			cp += len;
@@ -442,7 +442,7 @@ poll_again:
 char *kdb_getstr(char *buffer, size_t bufsize, char *prompt)
 {
 	if (prompt && kdb_prompt_str != prompt)
-		strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
+		strlcpy(kdb_prompt_str, prompt, CMD_BUFLEN);
 	kdb_printf(kdb_prompt_str);
 	kdb_nextline = 1;	/* Prompt and input resets line number */
 	return kdb_read(buffer, bufsize);
-- 
1.7.10.4

