Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab3GSHyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:54:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239Ab3GSHyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:54:44 -0400
Date: Fri, 19 Jul 2013 00:54:22 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-75211dbfabf1de3a42703f4d3cd6f6e047289d40@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1374083403-14591-3-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Remove data_offset seek as it'
 s not needed
Git-Commit-ID: 75211dbfabf1de3a42703f4d3cd6f6e047289d40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:54:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75211dbfabf1de3a42703f4d3cd6f6e047289d40
Gitweb:     http://git.kernel.org/tip/75211dbfabf1de3a42703f4d3cd6f6e047289d40
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 17 Jul 2013 19:49:42 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 16:46:17 -0300

perf header: Remove data_offset seek as it's not needed

Removing data_offset seek as it's not needed, because data are not read
by syscall but mmaped instead.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
