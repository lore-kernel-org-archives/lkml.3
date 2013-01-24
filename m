Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3AXSgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:36:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3AXSgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:36:10 -0500
Date: Thu, 24 Jan 2013 10:35:19 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-919d590f13c94c5465db723178e4b72200fd5f90@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20121120095101.GA5939@quad>
References: <20121120095101.GA5939@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix dso__fprintf() print statement
Git-Commit-ID: 919d590f13c94c5465db723178e4b72200fd5f90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:35:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  919d590f13c94c5465db723178e4b72200fd5f90
Gitweb:     http://git.kernel.org/tip/919d590f13c94c5465db723178e4b72200fd5f90
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 20 Nov 2012 10:51:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:04 -0300

perf symbols: Fix dso__fprintf() print statement

Was ignoring the dso type (function vs. variable) and was therefore
printing bogus information.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20121120095101.GA5939@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index d6d9a46..be43785 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -583,7 +583,7 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 	if (dso->short_name != dso->long_name)
 		ret += fprintf(fp, "%s, ", dso->long_name);
 	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
-		       dso->loaded ? "" : "NOT ");
+		       dso__loaded(dso, type) ? "" : "NOT ");
 	ret += dso__fprintf_buildid(dso, fp);
 	ret += fprintf(fp, ")\n");
 	for (nd = rb_first(&dso->symbols[type]); nd; nd = rb_next(nd)) {
