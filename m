Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaESMbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbaESMbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:31:11 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 4/8] perf session: Fix possible null pointer dereference in session.c
Date: Mon, 19 May 2014 14:30:52 +0200
Message-Id: <1400502656-20751-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
References: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

cppcheck detected following warning:
[tools/perf/util/session.c:1628] -> [tools/perf/util/session.c:1632]:
 (warning) Possible null pointer dereference: session - otherwise it
 is redundant to check it against null.

In order to avoide null pointer, check the pointer before use.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Link: http://lkml.kernel.org/r/1400087618-13628-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/session.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 55960f2..64a186e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1625,13 +1625,14 @@ out_delete_map:
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 				bool full)
 {
-	int fd = perf_data_file__fd(session->file);
 	struct stat st;
-	int ret;
+	int fd, ret;
 
 	if (session == NULL || fp == NULL)
 		return;
 
+	fd = perf_data_file__fd(session->file);
+
 	ret = fstat(fd, &st);
 	if (ret == -1)
 		return;
-- 
1.8.3.1

