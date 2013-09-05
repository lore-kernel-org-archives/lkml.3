Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3IEO3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:29:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3IEO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:29:50 -0400
Date: Thu, 5 Sep 2013 10:29:47 -0400
From: Kyle McMartin <kyle@infradead.org>
To: torvalds@linux-foundation.org
Cc: mingo@redhat.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: builtin-trace.c: check if MAP_32BIT is defined
Message-ID: <20130905142947.GA25882@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

MAP_32BIT is defined only on x86... this means perf fails to build on
all other platforms.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

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
