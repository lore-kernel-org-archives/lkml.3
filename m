Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaA0Njm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:39:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaA0Njl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:39:41 -0500
From: Francesco Fusco <ffusco@redhat.com>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: fix include for non x86 architectures
Date: Mon, 27 Jan 2014 14:39:13 +0100
Message-Id: <2cf8143aad65a6aa6fe30325ef8a65847141afa2.1390829373.git.ffusco@redhat.com>
In-Reply-To: <cover.1390829373.git.ffusco@redhat.com>
References: <cover.1390829373.git.ffusco@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 71ae8aac ("lib: introduce arch optimized hash library")
added an include to <linux/hash.h> for setting up an architecture
specific fast hash. Since perf includes directly the non-uapi
kernel header, it cannot find <asm/hash.h> on non-x86 and thus
prevents perf to be compiled on every architecture other than
x86. The problem is the inclusion of <asm/hash.h> in hash.h
that results in the following error originating from
util/evlist.c:

  fatal error: asm/hash.h: No such file or directory

This commit simply adds an empty <asm/hash.h> stub/file to fix
the compile issue on non-x86 architectures. As perf does not use
any of these new functions, it fixes the compilation and therefore
seems to be the most appropriate solution to go with.

Signed-off-by: Francesco Fusco <ffusco@redhat.com>
---
 tools/perf/util/include/asm/hash.h | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 tools/perf/util/include/asm/hash.h

diff --git a/tools/perf/util/include/asm/hash.h b/tools/perf/util/include/asm/hash.h
new file mode 100644
index 0000000..d82b170b
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
1.8.3.1

