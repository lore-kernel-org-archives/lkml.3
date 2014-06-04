Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaFDVmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:42:16 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:41392 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaFDVmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:42:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jason Wessel <jason.wessel@windriver.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
        Ingo Molnar <mingo@kernel.org>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: debug: kdb: kdb_main.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:43:09 +0200
Message-Id: <1401918189-3607-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/debug/kdb/kdb_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0b097c8..736b025 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1063,12 +1063,14 @@ static int handle_ctrl_cmd(char *cmd)
 	case CTRL_P:
 		if (cmdptr != cmd_tail)
 			cmdptr = (cmdptr-1) % KDB_CMD_HISTORY_COUNT;
-		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
+		strncpy(cmd_cur, cmd_hist[cmdptr], sizeof(cmd_cur));
+		cmd_cur[sizeof(cmd_cur) - 1] = '\0';
 		return 1;
 	case CTRL_N:
 		if (cmdptr != cmd_head)
 			cmdptr = (cmdptr+1) % KDB_CMD_HISTORY_COUNT;
-		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
+		strncpy(cmd_cur, cmd_hist[cmdptr], sizeof(cmd_cur));
+		cmd_cur[sizeof(cmd_cur) - 1] = '\0';
 		return 1;
 	}
 	return 0;
-- 
1.7.10.4

