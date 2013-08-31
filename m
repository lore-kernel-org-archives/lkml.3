Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3HaIP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:15:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3HaIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:15:48 -0400
Date: Sat, 31 Aug 2013 01:15:36 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-nd0d7rbajgm8k6tah3xv34v1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Handle missing HUGEPAGE defines
Git-Commit-ID: f2935f3e585226b8203ec3861907e1cb16ad3d6a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:15:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2935f3e585226b8203ec3861907e1cb16ad3d6a
Gitweb:     http://git.kernel.org/tip/f2935f3e585226b8203ec3861907e1cb16ad3d6a
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 27 Aug 2013 10:50:40 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 30 Aug 2013 15:43:28 -0300

perf trace: Handle missing HUGEPAGE defines

Needed for compile on Fedora 12 which goes back to the 2.6.32 kernel.
Might be needed for RHEL6. I use F12 to compile static binaries for
Wind River Linux 4.3.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/n/tip-nd0d7rbajgm8k6tah3xv34v1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 845facc..69a065e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -71,7 +71,9 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size, unsigned
 	P_MMAP_FLAG(FILE);
 	P_MMAP_FLAG(FIXED);
 	P_MMAP_FLAG(GROWSDOWN);
+#ifdef MAP_HUGETLB
 	P_MMAP_FLAG(HUGETLB);
+#endif
 	P_MMAP_FLAG(LOCKED);
 	P_MMAP_FLAG(NONBLOCK);
 	P_MMAP_FLAG(NORESERVE);
@@ -110,8 +112,12 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size, uns
 #endif
 	P_MADV_BHV(MERGEABLE);
 	P_MADV_BHV(UNMERGEABLE);
+#ifdef MADV_HUGEPAGE
 	P_MADV_BHV(HUGEPAGE);
+#endif
+#ifdef MADV_NOHUGEPAGE
 	P_MADV_BHV(NOHUGEPAGE);
+#endif
 #ifdef MADV_DONTDUMP
 	P_MADV_BHV(DONTDUMP);
 #endif
