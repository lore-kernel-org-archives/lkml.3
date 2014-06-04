Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaFDVko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:40:44 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60847 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaFDVkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:40:42 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jason Wessel <jason.wessel@windriver.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: debug: kdb: kdb_io.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:41:36 +0200
Message-Id: <1401918096-3516-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/debug/kdb/kdb_io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 14ff484..0cd0e28 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -441,8 +441,10 @@ poll_again:
 
 char *kdb_getstr(char *buffer, size_t bufsize, char *prompt)
 {
-	if (prompt && kdb_prompt_str != prompt)
-		strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
+	if (prompt && kdb_prompt_str != prompt) {
+		strncpy(kdb_prompt_str, prompt, sizeof(kdb_prompt_str));
+		kdb_prompt_str[sizeof(kdb_prompt_str) - 1] = '\0'
+	}
 	kdb_printf(kdb_prompt_str);
 	kdb_nextline = 1;	/* Prompt and input resets line number */
 	return kdb_read(buffer, bufsize);
-- 
1.7.10.4

