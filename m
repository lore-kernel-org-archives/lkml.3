Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3AYMJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:09:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3AYMJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:09:50 -0500
Date: Fri, 25 Jan 2013 04:09:25 -0800
From: tip-bot for Tom Zanussi <tom.zanussi@linux.intel.com>
Message-ID: <tip-bdb71db29d50b61f45459b8facfb876768e8cacc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, tom.zanussi@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, tom.zanussi@linux.intel.com
In-Reply-To: <12ec084ef2870178915c907d16cd1dfa19fbb39e.1358527965.git.tom.zanussi@linux.intel.com>
References: <12ec084ef2870178915c907d16cd1dfa19fbb39e.1358527965.git.tom.zanussi@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Don'
 t display trace info when invoking scripts
Git-Commit-ID: bdb71db29d50b61f45459b8facfb876768e8cacc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:09:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdb71db29d50b61f45459b8facfb876768e8cacc
Gitweb:     http://git.kernel.org/tip/bdb71db29d50b61f45459b8facfb876768e8cacc
Author:     Tom Zanussi <tom.zanussi@linux.intel.com>
AuthorDate: Fri, 18 Jan 2013 13:51:26 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:52 -0300

perf script: Don't display trace info when invoking scripts

Only display the trace info if using the default event display.  When
invoking scripts we assume they have complete control of what's
displayed so we shouldn't unconditionally display the trace info, and
when generating scripts we don't expect to see trace info obscuring the
output message.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lkml.kernel.org/r/12ec084ef2870178915c907d16cd1dfa19fbb39e.1358527965.git.tom.zanussi@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fee4c9a..92d4658 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1475,7 +1475,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 	}
 
-	perf_session__fprintf_info(session, stdout, show_full_info);
+	if (!script_name && !generate_script_lang)
+		perf_session__fprintf_info(session, stdout, show_full_info);
 
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
