Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3JRMeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:34:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:52864 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3JRMag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936416"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/19] perf session: Add missing members to perf_event__attr_swap()
Date: Fri, 18 Oct 2013 15:29:03 +0300
Message-Id: <1382099356-4918-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event__attr_swap() needs to swap all members of
struct perf_event_attr.  Add mssing ones.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d51e62d..d4559ca 100644
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
1.7.11.7

