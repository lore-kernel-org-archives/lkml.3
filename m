Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3A3Or2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:47:28 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54445
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476Ab3A3OrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <ellerman@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/21] perf tools, powerpc: Fix compile warnings in tests/attr.c
Date: Wed, 30 Jan 2013 11:46:57 -0300
Message-Id: <1359557222-17547-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

We print several '__u64' quantities using '%llu'. On powerpc, we by
default include '<asm-generic/int-l64.h> which results in __u64 being an
unsigned long. This causes compile warnings which are treated as errors
due to '-Werror'.

By defining __SANE_USERSPACE_TYPES__ we include <asm-generic/int-ll64.h>
and define __u64 as unsigned long long.

Changelog[v2]:
	[Michael Ellerman] Use __SANE_USERSPACE_TYPES__ and avoid PRIu64
	format specifier - which as Jiri Olsa pointed out, breaks on x86-64.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <ellerman@au1.ibm.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130124054439.GA31588@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index f61dd3f..bdcceb8 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -19,6 +19,11 @@
  * permissions. All the event text files are stored there.
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
 #include <stdlib.h>
 #include <stdio.h>
 #include <inttypes.h>
-- 
1.8.1.1.361.gec3ae6e

