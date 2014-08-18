Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaHRIZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:25:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaHRIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:25:37 -0400
Date: Mon, 18 Aug 2014 01:25:01 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-340481ada1af9322d99e9c1ba874391f53ff4fce@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022249.3545.53211.stgit@kbuild-fedora.novalocal>
References: <20140814022249.3545.53211.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-cache:
  Use strerror_r instead of strerror
Git-Commit-ID: 340481ada1af9322d99e9c1ba874391f53ff4fce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  340481ada1af9322d99e9c1ba874391f53ff4fce
Gitweb:     http://git.kernel.org/tip/340481ada1af9322d99e9c1ba874391f53ff4fce
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:49 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 13:07:59 -0300

perf buildid-cache: Use strerror_r instead of strerror

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
