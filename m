Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaDBPo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:44:57 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38348 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaDBPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:44:30 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [RFC v2 09/10] kdb: Improve usability of help text when running in kiosk mode
Date: Wed,  2 Apr 2014 16:43:59 +0100
Message-Id: <1396453440-16445-10-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently 'help' in kiosk mode results in help text being issued for many
commands the user cannot actually run. Filter the help list when kiosk
mode is engaged to ensure help is fully relevant.

Filtering the list is also greatly simplifies scanning for commands that
may have been accidentally classified as safe.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 kernel/debug/kdb/kdb_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 808bf55..77b6e61 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2401,6 +2401,9 @@ static int kdb_help(int argc, const char **argv)
 			return 0;
 		if (!kt->cmd_name)
 			continue;
+		if (kdb_kiosk &&
+		    !(kt->cmd_flags & (KDB_SAFE | KDB_SAFE_NO_ARGS)))
+			continue;
 		if (strlen(kt->cmd_usage) > 20)
 			space = "\n                                    ";
 		kdb_printf("%-15.15s %-20s%s%s\n", kt->cmd_name,
-- 
1.9.0

