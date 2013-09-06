Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3IFMOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:14:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3IFMOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:14:37 -0400
Date: Fri, 6 Sep 2013 05:14:24 -0700
From: tip-bot for Kyle McMartin <tipbot@zytor.com>
Message-ID: <tip-41817815666e4a6f302dad1fea47cbe64cc45e40@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        kyle@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, kyle@redhat.com, tglx@linutronix.de
In-Reply-To: <20130905142947.GA25882@merlin.infradead.org>
References: <20130905142947.GA25882@merlin.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Check if MAP_32BIT is defined
Git-Commit-ID: 41817815666e4a6f302dad1fea47cbe64cc45e40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 06 Sep 2013 05:14:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41817815666e4a6f302dad1fea47cbe64cc45e40
Gitweb:     http://git.kernel.org/tip/41817815666e4a6f302dad1fea47cbe64cc45e40
Author:     Kyle McMartin <kyle@redhat.com>
AuthorDate: Thu, 5 Sep 2013 10:29:47 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Sep 2013 16:18:46 -0300

perf trace: Check if MAP_32BIT is defined

MAP_32BIT is defined only on x86... this means perf fails to build on
all other platforms.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130905142947.GA25882@merlin.infradead.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6016112..f5aa637 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -100,7 +100,9 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
 
 	P_MMAP_FLAG(SHARED);
 	P_MMAP_FLAG(PRIVATE);
+#ifdef MAP_32BIT
 	P_MMAP_FLAG(32BIT);
+#endif
 	P_MMAP_FLAG(ANONYMOUS);
 	P_MMAP_FLAG(DENYWRITE);
 	P_MMAP_FLAG(EXECUTABLE);
