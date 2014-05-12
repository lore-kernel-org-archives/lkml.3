Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaELGbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:31:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57587 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaELG3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:29:06 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 15/20] perf diff: Add missing setup_output_field()
Date: Mon, 12 May 2014 15:28:48 +0900
Message-Id: <1399876133-17963-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
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
index f3b10dcf6838..670d191bec31 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1155,6 +1155,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (setup_sorting() < 0)
 		usage_with_options(diff_usage, options);
 
+	if (setup_output_field() < 0)
+		usage_with_options(diff_usage, options);
+
 	setup_pager();
 
 	sort__setup_elide(NULL);
-- 
1.9.2

