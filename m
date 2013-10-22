Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3JVO3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:29:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3JVO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/26] perf session: Add missing members to perf_event__attr_swap()
Date: Tue, 22 Oct 2013 11:28:20 -0300
Message-Id: <1382452114-1243-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The perf_event__attr_swap() method needs to swap all members of struct
perf_event_attr.  Add missing ones.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382099356-4918-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d51e62db96a7..d4559ca08ca6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -453,6 +453,9 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	attr->bp_type		= bswap_32(attr->bp_type);
 	attr->bp_addr		= bswap_64(attr->bp_addr);
 	attr->bp_len		= bswap_64(attr->bp_len);
+	attr->branch_sample_type = bswap_64(attr->branch_sample_type);
+	attr->sample_regs_user	 = bswap_64(attr->sample_regs_user);
+	attr->sample_stack_user  = bswap_32(attr->sample_stack_user);
 
 	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
-- 
1.8.1.4

