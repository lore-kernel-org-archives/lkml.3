Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570Ab3E3QCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:02:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab3E3QCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/66] perf tools: Handle JITed code in shared memory
Date: Thu, 30 May 2013 19:00:49 +0300
Message-Id: <1369929699-8724-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Need to check for /dev/zero.

Most likely more strings are missing too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1366848182-30449-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6fcb9de..8bcdf9e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -21,6 +21,7 @@ const char *map_type__name[MAP__NR_TYPES] = {
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
-- 
1.8.1.4

