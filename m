Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3JWHyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:54:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3JWHyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:01 -0400
Date: Wed, 23 Oct 2013 00:53:36 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-7db5952846dfa015d74e64b5e8656acac979490b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382099356-4918-7-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Add missing members to perf_event__attr_swap()
Git-Commit-ID: 7db5952846dfa015d74e64b5e8656acac979490b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:53:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7db5952846dfa015d74e64b5e8656acac979490b
Gitweb:     http://git.kernel.org/tip/7db5952846dfa015d74e64b5e8656acac979490b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 18 Oct 2013 15:29:03 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 11:19:24 -0300

perf session: Add missing members to perf_event__attr_swap()

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
