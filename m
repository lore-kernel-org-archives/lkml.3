Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab3HNKig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:38:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab3HNKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joshua Zhu <zhu.wen-jie@hp.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Vinson Lee <vlee@freedesktop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 50/75] perf tools: Add anonymous huge page recognition
Date: Wed, 14 Aug 2013 11:36:39 +0100
Message-Id: <1376476624-10011-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Zhu <zhu.wen-jie@hp.com>

commit d0528b5d71faf612014dd7672e44225c915344b2 upstream.

Judging anonymous memory's vm_area_struct, perf_mmap_event's filename
will be set to "//anon" indicating this vma belongs to anonymous
memory.

Once hugepage is used, vma's vm_file points to hugetlbfs. In this way,
this vma will not be regarded as anonymous memory by is_anon_memory() in
perf user space utility.

Signed-off-by: Joshua Zhu <zhu.wen-jie@hp.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joshua Zhu <zhu.wen-jie@hp.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1357363797-3550-1-git-send-email-zhu.wen-jie@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Vinson Lee <vlee@freedesktop.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a1f4e36..81072b6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -15,7 +15,8 @@ const char *map_type__name[MAP__NR_TYPES] = {
 
 static inline int is_anon_memory(const char *filename)
 {
-	return strcmp(filename, "//anon") == 0;
+	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
 static inline int is_no_dso_memory(const char *filename)
-- 
1.8.3.2

