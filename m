Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217Ab3E3QEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:04:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383Ab3E3QCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 52/66] perf tools: Remove frozen from perf_header struct
Date: Thu, 30 May 2013 19:01:25 +0300
Message-Id: <1369929699-8724-53-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing frozen from perf_header struct as it's no longer used.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369394201-20044-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 2 --
 tools/perf/util/header.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a..738d3b8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2391,7 +2391,6 @@ out_err_write:
 	}
 	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
 
-	header->frozen = 1;
 	return 0;
 }
 
@@ -2871,7 +2870,6 @@ int perf_session__read_header(struct perf_session *session, int fd)
 						   session->pevent))
 		goto out_delete_evlist;
 
-	header->frozen = 1;
 	return 0;
 out_errno:
 	return -errno;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index c9fc55c..16a3e83 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -84,7 +84,6 @@ struct perf_session_env {
 };
 
 struct perf_header {
-	int			frozen;
 	bool			needs_swap;
 	s64			attr_offset;
 	u64			data_offset;
-- 
1.8.1.4

