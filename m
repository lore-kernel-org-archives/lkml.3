Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaENRNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:13:54 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44917 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbaENRNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:13:47 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, jolsa@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] perf session: Fix possible null pointer dereference in session.c
Date: Thu, 15 May 2014 02:13:38 +0900
Message-Id: <1400087618-13628-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck detected following warning.
[tools/perf/util/session.c:1628] -> [tools/perf/util/session.c:1632]:
 (warning) Possible null pointer dereference: session - otherwise it
 is redundant to check it against null.

In order to avoide null pointer, check the pointer before use.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
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
2.0.0.rc3.2.g998f840

