Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab3IHDVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56213 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756623Ab3IHDS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Ahern" <dsahern@gmail.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@redhat.com>,
        "Paul Mackerras" <paulus@samba.org>,
        "Akihiro Nagai" <akihiro.nagai.hw@hitachi.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Jiri Olsa" <jolsa@redhat.com>, "Joshua Zhu" <zhu.wen-jie@hp.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.790344183@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [007/121] perf tools: Add anonymous huge page recognition
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -15,7 +15,8 @@ const char *map_type__name[MAP__NR_TYPES
 
 static inline int is_anon_memory(const char *filename)
 {
-	return strcmp(filename, "//anon") == 0;
+	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
 static inline int is_no_dso_memory(const char *filename)

