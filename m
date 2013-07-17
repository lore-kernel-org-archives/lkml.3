Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab3GQRwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964868Ab3GQRvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/23] perf tools: Remove data_offset seek as it's not needed
Date: Wed, 17 Jul 2013 19:49:42 +0200
Message-Id: <1374083403-14591-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing data_offset seek as it's not needed, because
data are not read by syscall but mmaped instead.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b3f253f..035efe7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2794,8 +2794,6 @@ int perf_session__read_header(struct perf_session *session)
 	perf_header__process_sections(header, fd, &session->pevent,
 				      perf_file_section__process);
 
-	lseek(fd, header->data_offset, SEEK_SET);
-
 	if (perf_evlist__prepare_tracepoint_events(session->evlist,
 						   session->pevent))
 		goto out_delete_evlist;
-- 
1.7.11.7

