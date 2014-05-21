Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEUFzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:55:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60531 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaEUFzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:55:13 -0400
Date: Tue, 20 May 2014 22:55:02 -0700
From: tip-bot for Masanari Iida <tipbot@zytor.com>
Message-ID: <tip-c5765ece8a050836c6255e1276fc8e0e867078da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, standby24x7@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, standby24x7@gmail.com
In-Reply-To: <1400087618-13628-1-git-send-email-standby24x7@gmail.com>
References: <1400087618-13628-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Fix possible null pointer dereference in session.c
Git-Commit-ID: c5765ece8a050836c6255e1276fc8e0e867078da
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

Commit-ID:  c5765ece8a050836c6255e1276fc8e0e867078da
Gitweb:     http://git.kernel.org/tip/c5765ece8a050836c6255e1276fc8e0e867078da
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Thu, 15 May 2014 02:13:38 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 16 May 2014 09:18:51 +0200

perf session: Fix possible null pointer dereference in session.c

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
