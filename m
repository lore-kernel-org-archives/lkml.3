Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaFCSdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:33:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaFCSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:33:08 -0400
Date: Tue, 3 Jun 2014 11:32:51 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-be1f13e30862ab6b0fffaecd556856a965cefa0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-9-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Add callchain_cursor_snapshot()
Git-Commit-ID: be1f13e30862ab6b0fffaecd556856a965cefa0c
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

Commit-ID:  be1f13e30862ab6b0fffaecd556856a965cefa0c
Gitweb:     http://git.kernel.org/tip/be1f13e30862ab6b0fffaecd556856a965cefa0c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 10 Sep 2012 13:38:00 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:34:59 +0200

perf callchain: Add callchain_cursor_snapshot()

The callchain_cursor_snapshot() is for saving current status of the
callchain.  It'll be used to accumulate callchain information for each node.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-9-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/callchain.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 24a53d5..8f84423 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -167,4 +167,13 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 
 extern const char record_callchain_help[];
 int parse_callchain_report_opt(const char *arg);
+
+static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
+					     struct callchain_cursor *src)
+{
+	*dest = *src;
+
+	dest->first = src->curr;
+	dest->nr -= src->pos;
+}
 #endif	/* __PERF_CALLCHAIN_H */
