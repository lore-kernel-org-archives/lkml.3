Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaGZOpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:45:06 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51681 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:45:03 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Randy Dunlap <rdunlap@infradead.org>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Borislav Petkov <bp@suse.de>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: debug: kdb: kdb_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:46:29 +0200
Message-Id: <1406385989-3976-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/debug/kdb/kdb_main.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 2f7c760..b750c20 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1063,12 +1063,12 @@ static int handle_ctrl_cmd(char *cmd)
 	case CTRL_P:
 		if (cmdptr != cmd_tail)
 			cmdptr = (cmdptr-1) % KDB_CMD_HISTORY_COUNT;
-		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
+		strlcpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
 		return 1;
 	case CTRL_N:
 		if (cmdptr != cmd_head)
 			cmdptr = (cmdptr+1) % KDB_CMD_HISTORY_COUNT;
-		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
+		strlcpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
 		return 1;
 	}
 	return 0;
@@ -1263,17 +1263,15 @@ do_full_getstr:
 		if (*cmdbuf != '\n') {
 			if (*cmdbuf < 32) {
 				if (cmdptr == cmd_head) {
-					strncpy(cmd_hist[cmd_head], cmd_cur,
+					strlcpy(cmd_hist[cmd_head], cmd_cur,
 						CMD_BUFLEN);
-					*(cmd_hist[cmd_head] +
-					  strlen(cmd_hist[cmd_head])-1) = '\0';
 				}
 				if (!handle_ctrl_cmd(cmdbuf))
 					*(cmd_cur+strlen(cmd_cur)-1) = '\0';
 				cmdbuf = cmd_cur;
 				goto do_full_getstr;
 			} else {
-				strncpy(cmd_hist[cmd_head], cmd_cur,
+				strlcpy(cmd_hist[cmd_head], cmd_cur,
 					CMD_BUFLEN);
 			}
 
-- 
1.7.10.4

