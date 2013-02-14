Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991Ab3BNVoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:44:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57428 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3BNVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf tools: Limit unwind support to x86 archs
Date: Thu, 14 Feb 2013 18:44:21 -0300
Message-Id: <1360878263-12694-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

There's DWARF unwind support only for x86 archs, so limit the unwind.o
object to them only.

Without this building for other archs (e.g. cross compiling for ARM) is
broken.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Link: http://lkml.kernel.org/n/tip-viqtvd6hppqgt68zz4wlqm20@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1c8df6f..b90528d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -581,6 +581,11 @@ else
 endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
+# There's only x86 (both 32 and 64) support for CFI unwind so far
+ifneq ($(ARCH),x86)
+	NO_LIBUNWIND := 1
+endif
+
 ifndef NO_LIBUNWIND
 # for linking with debug library, run like:
 # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-- 
1.8.1.1.361.gec3ae6e

