Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaHOQwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:52:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:44838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaHOQvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:15 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/18] perf buildid-cache: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:50:00 -0300
Message-Id: <1408121403-11919-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use strerror_r instead of strerror in error messages for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022249.3545.53211.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index ac5838e0b1bd..70385756da63 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -291,6 +291,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		   *missing_filename = NULL,
 		   *update_name_list_str = NULL,
 		   *kcore_filename;
+	char sbuf[STRERR_BUFSIZE];
 
 	struct perf_data_file file = {
 		.mode  = PERF_DATA_MODE_READ,
@@ -347,7 +348,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 						continue;
 					}
 					pr_warning("Couldn't add %s: %s\n",
-						   pos->s, strerror(errno));
+						   pos->s, strerror_r(errno, sbuf, sizeof(sbuf)));
 				}
 
 			strlist__delete(list);
@@ -365,7 +366,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 						continue;
 					}
 					pr_warning("Couldn't remove %s: %s\n",
-						   pos->s, strerror(errno));
+						   pos->s, strerror_r(errno, sbuf, sizeof(sbuf)));
 				}
 
 			strlist__delete(list);
@@ -386,7 +387,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 						continue;
 					}
 					pr_warning("Couldn't update %s: %s\n",
-						   pos->s, strerror(errno));
+						   pos->s, strerror_r(errno, sbuf, sizeof(sbuf)));
 				}
 
 			strlist__delete(list);
-- 
1.9.3

