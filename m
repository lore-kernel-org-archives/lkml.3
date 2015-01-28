Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbbA1VYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:24:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934473AbbA1Ut5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:57 -0500
Date: Wed, 28 Jan 2015 07:06:33 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-5594b557aacaafbba7ad8e5ed29005df883bfe3a@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, hpa@zytor.com,
        acme@redhat.com, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        namhyung@kernel.org
Reply-To: namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        jolsa@redhat.com, acme@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, hpa@zytor.com, tglx@linutronix.de,
        dsahern@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow use of an exclusive option more than once
Git-Commit-ID: 5594b557aacaafbba7ad8e5ed29005df883bfe3a
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

Commit-ID:  5594b557aacaafbba7ad8e5ed29005df883bfe3a
Gitweb:     http://git.kernel.org/tip/5594b557aacaafbba7ad8e5ed29005df883bfe3a
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 10 Jan 2015 19:33:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:33 -0300

perf tools: Allow use of an exclusive option more than once

The exclusive options are to prohibit use of conflicting options at the
same time.  But it had a side effect that it also limits a such option
can be used at most once.  Currently the only user of the flag is perf
probe and it allows to use such options more than once, but when one
tries to use it, perf will fail like below:

  $ sudo perf probe -x /lib/libc-2.20.so --add malloc --add free
    Error: option `add' cannot be used with add
  ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420886028-15135-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index f62dee7..4a015f7 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -46,7 +46,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 		return opterror(opt, "is not usable", flags);
 
 	if (opt->flags & PARSE_OPT_EXCLUSIVE) {
-		if (p->excl_opt) {
+		if (p->excl_opt && p->excl_opt != opt) {
 			char msg[128];
 
 			if (((flags & OPT_SHORT) && p->excl_opt->short_name) ||
