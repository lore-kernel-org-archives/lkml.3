Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaDPDGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:18 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60131 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaDPDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 15/17] perf diff: Add missing setup_output_field()
Date: Wed, 16 Apr 2014 12:05:52 +0900
Message-Id: <1397617554-26319-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf diff command itself doesn't make use of the --fields option,
it still needs to call the function since the output only work with
that way.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6ef80f22c1e2..7f8352f10ff3 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1150,6 +1150,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (setup_sorting() < 0)
 		usage_with_options(diff_usage, options);
 
+	if (setup_output_field() < 0)
+		usage_with_options(diff_usage, options);
+
 	setup_pager();
 
 	sort__setup_elide(NULL);
-- 
1.9.2

