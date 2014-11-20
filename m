Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaKTHiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:38:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbaKTHix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:38:53 -0500
Date: Wed, 19 Nov 2014 23:38:43 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-2de217688e8f086bf6d920d530401b56fcbc6eff@git.kernel.org>
Cc: namhyung@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com, jolsa@redhat.com, mingo@kernel.org,
        acme@redhat.com
Reply-To: tglx@linutronix.de, ak@linux.intel.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com
In-Reply-To: <1415844328-4884-8-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-8-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Only print base source file for srcline
Git-Commit-ID: 2de217688e8f086bf6d920d530401b56fcbc6eff
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

Commit-ID:  2de217688e8f086bf6d920d530401b56fcbc6eff
Gitweb:     http://git.kernel.org/tip/2de217688e8f086bf6d920d530401b56fcbc6eff
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:25 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:47 -0300

perf tools: Only print base source file for srcline

For perf report with --sort srcline only print the base source file
name. This makes the results generally fit much better to the screen.
The path is usually not that useful anyways because it is often from
different systems.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-8-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index f3e4bc5..77c1806 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -274,7 +274,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
-	if (asprintf(&srcline, "%s:%u", file, line) < 0) {
+	if (asprintf(&srcline, "%s:%u", basename(file), line) < 0) {
 		free(file);
 		goto out;
 	}
