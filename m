Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaHNIsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:48:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaHNIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:48:19 -0400
Date: Thu, 14 Aug 2014 01:47:55 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-38520dc31206bae1dc811ddd59ccea3a6536784d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-11-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-11-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Move call to symbol__init()
  after creating session
Git-Commit-ID: 38520dc31206bae1dc811ddd59ccea3a6536784d
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

Commit-ID:  38520dc31206bae1dc811ddd59ccea3a6536784d
Gitweb:     http://git.kernel.org/tip/38520dc31206bae1dc811ddd59ccea3a6536784d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:35:00 -0300

perf script: Move call to symbol__init() after creating session

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-11-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c84d723..9ca7a2d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1719,8 +1719,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		exit(-1);
 	}
 
-	if (symbol__init() < 0)
-		return -1;
 	if (!script_name)
 		setup_pager();
 
@@ -1734,6 +1732,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			goto out_delete;
 	}
 
+	if (symbol__init() < 0)
+		goto out_delete;
+
 	script.session = session;
 
 	if (cpu_list) {
