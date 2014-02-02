Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaBBIzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:55:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBBIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:55:09 -0500
Date: Sun, 2 Feb 2014 00:54:58 -0800
From: tip-bot for Francesco Fusco <tipbot@zytor.com>
Message-ID: <tip-6a02652df511029127406cf8fa89cdf5e987f963@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, ffusco@redhat.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ffusco@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <2cf8143aad65a6aa6fe30325ef8a65847141afa2.1390829373.git.ffusco@redhat.com>
References: <2cf8143aad65a6aa6fe30325ef8a65847141afa2.1390829373.git.ffusco@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix include for non x86 architectures
Git-Commit-ID: 6a02652df511029127406cf8fa89cdf5e987f963
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:55:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a02652df511029127406cf8fa89cdf5e987f963
Gitweb:     http://git.kernel.org/tip/6a02652df511029127406cf8fa89cdf5e987f963
Author:     Francesco Fusco <ffusco@redhat.com>
AuthorDate: Mon, 27 Jan 2014 14:39:13 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:42 -0300

perf tools: Fix include for non x86 architectures

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
