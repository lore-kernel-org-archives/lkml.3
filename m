Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3EXLRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:17:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3EXLRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:17:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/5] perf tools: Remove frozen from perf_header struct
Date: Fri, 24 May 2013 13:16:39 +0200
Message-Id: <1369394201-20044-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing frozen from perf_header struct as it's
no longer used.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

