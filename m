Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaHNCWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:55 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52022 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaHNCWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:52 -0400
X-AuditID: 85900ec0-d1328b9000001514-bb-53ec1d7a8fa9
Subject: [PATCH 10/13] perf buildid-cache: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:49 +0000
Message-ID: <20140814022249.3545.53211.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error messages
for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-buildid-cache.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index ac5838e..7038575 100644
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

