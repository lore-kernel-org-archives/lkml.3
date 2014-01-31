Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbaAaU1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:27:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55338 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Francesco Fusco <ffusco@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/12] perf tools: Fix include for non x86 architectures
Date: Fri, 31 Jan 2014 17:27:26 -0300
Message-Id: <1391200055-18250-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francesco Fusco <ffusco@redhat.com>

Commit 71ae8aac ("lib: introduce arch optimized hash library") added an
include to <linux/hash.h> for setting up an architecture specific fast
hash.

Since perf includes directly the non-uapi kernel header, it cannot find
<asm/hash.h> on non-x86 and thus prevents perf to be compiled on every
architecture other than x86.

The problem is the inclusion of <asm/hash.h> in hash.h that results in
the following error originating from util/evlist.c:

  fatal error: asm/hash.h: No such file or directory

This commit simply adds an empty <asm/hash.h> stub/file to fix the
compile issue on non-x86 architectures.

As perf does not use any of these new functions, it fixes the
compilation and therefore seems to be the most appropriate solution to
go with.

Signed-off-by: Francesco Fusco <ffusco@redhat.com>
Link: http://lkml.kernel.org/r/2cf8143aad65a6aa6fe30325ef8a65847141afa2.1390829373.git.ffusco@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/asm/hash.h | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 tools/perf/util/include/asm/hash.h

diff --git a/tools/perf/util/include/asm/hash.h b/tools/perf/util/include/asm/hash.h
new file mode 100644
index 000000000000..d82b170bb216
--- /dev/null
+++ b/tools/perf/util/include/asm/hash.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_HASH_H
+#define __ASM_GENERIC_HASH_H
+
+/* Stub */
+
+#endif /* __ASM_GENERIC_HASH_H */
-- 
1.8.1.4

