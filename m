Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaHSOCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:02:13 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33395 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaHSOCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:02:11 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net,
        Daniel Thompson <daniel.thompson@liaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RESEND PATCH v5 3.17-rc1 1/8] kdb: Remove currently unused kdbtab_t->cmd_flags
Date: Tue, 19 Aug 2014 15:01:55 +0100
Message-Id: <1408456922-12221-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408456922-12221-1-git-send-email-daniel.thompson@linaro.org>
References: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
 <1408456922-12221-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

The struct member is never used in the code, so we can remove it.

We will introduce real flags soon by renaming cmd_repeat to cmd_flags.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Daniel Thompson <daniel.thompson@liaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: kgdb-bugreport@lists.sourceforge.net
---
 kernel/debug/kdb/kdb_main.c    | 1 -
 kernel/debug/kdb/kdb_private.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 379650b..cc02aa2 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2694,7 +2694,6 @@ int kdb_register_repeat(char *cmd,
 	kp->cmd_func   = func;
 	kp->cmd_usage  = usage;
 	kp->cmd_help   = help;
-	kp->cmd_flags  = 0;
 	kp->cmd_minlen = minlen;
 	kp->cmd_repeat = repeat;
 
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 7afd3c8..c4c46c7 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -172,7 +172,6 @@ typedef struct _kdbtab {
 	kdb_func_t cmd_func;		/* Function to execute command */
 	char    *cmd_usage;		/* Usage String for this command */
 	char    *cmd_help;		/* Help message for this command */
-	short    cmd_flags;		/* Parsing flags */
 	short    cmd_minlen;		/* Minimum legal # command
 					 * chars required */
 	kdb_repeat_t cmd_repeat;	/* Does command auto repeat on enter? */
-- 
1.9.3

