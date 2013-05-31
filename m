Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3EaMTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:19:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3EaMT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:19:27 -0400
Date: Fri, 31 May 2013 05:19:04 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-78e3a1f1ab932b52333ba14497d663d3ad758d16@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1369394201-20044-4-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove frozen from perf_header struct
Git-Commit-ID: 78e3a1f1ab932b52333ba14497d663d3ad758d16
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

Commit-ID:  78e3a1f1ab932b52333ba14497d663d3ad758d16
Gitweb:     http://git.kernel.org/tip/78e3a1f1ab932b52333ba14497d663d3ad758d16
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 May 2013 13:16:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 15:17:35 +0300

perf tools: Remove frozen from perf_header struct

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
