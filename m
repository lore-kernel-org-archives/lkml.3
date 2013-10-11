Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3JKKmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab3JKKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Vinson Lee <vlee@freedesktop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 019/100] perf tools: Handle JITed code in shared memory
Date: Fri, 11 Oct 2013 11:40:49 +0100
Message-Id: <1381488130-30235-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 89365e6c9ad4c0e090e4c6a4b67a3ce319381d89 upstream.

Need to check for /dev/zero.

Most likely more strings are missing too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1366848182-30449-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Vinson Lee <vlee@freedesktop.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 81072b6..34d8298 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -16,6 +16,7 @@ const char *map_type__name[MAP__NR_TYPES] = {
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
-- 
1.8.3.2

