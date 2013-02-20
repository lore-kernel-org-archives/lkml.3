Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935785Ab3BTPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:32:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51002 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935363Ab3BTPci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:38 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 6/7] perf: Do not allow empty debugfs-dir option
Date: Wed, 20 Feb 2013 16:32:32 +0100
Message-Id: <1361374353-30385-7-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1361374353-30385-1-git-send-email-bp@alien8.de>
References: <1361374353-30385-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Catch empty --debugfs-dir= option and exit early.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/perf/perf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index f6ba7b73f40e..25f108480ac6 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -199,6 +199,10 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 			(*argv)++;
 			(*argc)--;
 		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
+			if (strlen(cmd) == strlen(CMD_DEBUGFS_DIR)) {
+				fprintf(stderr, "No directory given for --debugfs-dir.\n");
+				usage(perf_usage_string);
+			}
 			perf_debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
 			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
 			if (envchanged)
-- 
1.8.1.3.535.ga923c31

