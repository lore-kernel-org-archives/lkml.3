Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3DGLVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:21:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47384 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab3DGLVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:21:19 -0400
X-Spam-Score: -100.7
Message-ID: <51615692.2010906@asianux.com>
Date: Sun, 07 Apr 2013 19:20:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: debug: kdb: strncpy issue, using strlcpy instead
 of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  kdb_prompt_str is NUL terminated string, need always set '\0' at the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/debug/kdb/kdb_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 14ff484..932b436 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
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
1.7.7.6
