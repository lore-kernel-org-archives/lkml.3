Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3GLIug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:50:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab3GLIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:50:32 -0400
Date: Fri, 12 Jul 2013 01:49:49 -0700
From: "tip-bot for Kirill A. Shutemov" <tipbot@zytor.com>
Message-ID: <tip-13966721a11f4a2ba8038191e48083b5f31822bb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, kirill.shutemov@linux.intel.com,
        h.mitake@gmail.com, mitake.hitoshi@lab.ntt.co.jp, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        kirill.shutemov@linux.intel.com, a.p.zijlstra@chello.nl,
        h.mitake@gmail.com, mitake.hitoshi@lab.ntt.co.jp, tglx@linutronix.de
In-Reply-To: <1370518503-4230-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1370518503-4230-1-git-send-email-kirill.shutemov@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench:
  Fix memory allocation fail check in mem{set,cpy} workloads
Git-Commit-ID: 13966721a11f4a2ba8038191e48083b5f31822bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:49:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13966721a11f4a2ba8038191e48083b5f31822bb
Gitweb:     http://git.kernel.org/tip/13966721a11f4a2ba8038191e48083b5f31822bb
Author:     Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
AuthorDate: Thu, 6 Jun 2013 14:35:03 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:35:40 -0300

perf bench: Fix memory allocation fail check in mem{set,cpy} workloads

Addresses of allocated memory areas saved to '*src' and '*dst', so we
need to check them for NULL, not 'src' and 'dst'.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370518503-4230-1-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c | 4 ++--
 tools/perf/bench/mem-memset.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 93c83e3..25fd3f1 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -111,11 +111,11 @@ static double timeval2double(struct timeval *ts)
 static void alloc_mem(void **dst, void **src, size_t length)
 {
 	*dst = zalloc(length);
-	if (!dst)
+	if (!*dst)
 		die("memory allocation failed - maybe length is too large?\n");
 
 	*src = zalloc(length);
-	if (!src)
+	if (!*src)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index c6e4bc5..4a2f120 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -111,7 +111,7 @@ static double timeval2double(struct timeval *ts)
 static void alloc_mem(void **dst, size_t length)
 {
 	*dst = zalloc(length);
-	if (!dst)
+	if (!*dst)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
