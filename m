Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3KOHZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:25:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3KOHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:25:03 -0500
Date: Thu, 14 Nov 2013 23:24:50 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-ea432a8bb940e6bea2aaeca3c0ff3d931ad81f2e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <20131112232609.GA31474@gmail.com>
References: <20131112232609.GA31474@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Add missing newline if the 'uid'
  is invalid
Git-Commit-ID: ea432a8bb940e6bea2aaeca3c0ff3d931ad81f2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:24:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea432a8bb940e6bea2aaeca3c0ff3d931ad81f2e
Gitweb:     http://git.kernel.org/tip/ea432a8bb940e6bea2aaeca3c0ff3d931ad81f2e
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 13 Nov 2013 00:26:09 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 15:59:50 -0300

perf top: Add missing newline if the 'uid' is invalid

Add missing newline if the 'uid' is invalid:

  hubble:~> perf top --stdio -u help
  Error:
  Invalid User: helphubble:~>

Fixed by this patch:

  comet:~/tip/tools/perf> perf top --stdio -u help
  Error:
  Invalid User: help
  comet:~/tip/tools/perf>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131112232609.GA31474@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b8f8e29..71e6402 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1172,7 +1172,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	status = target__validate(target);
 	if (status) {
 		target__strerror(target, status, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__warning("%s\n", errbuf);
 	}
 
 	status = target__parse_uid(target);
@@ -1180,7 +1180,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		int saved_errno = errno;
 
 		target__strerror(target, status, errbuf, BUFSIZ);
-		ui__error("%s", errbuf);
+		ui__error("%s\n", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
