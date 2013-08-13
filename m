Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3HMGiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:38:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab3HMGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joshua Zhu <zhu.wen-jie@hp.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vinson Lee <vlee@freedesktop.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 17/17] perf tools: Add anonymous huge page recognition
Date: Mon, 12 Aug 2013 23:36:03 -0700
Message-Id: <20130813063503.106386760@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Vinson Lee <vlee@freedesktop.org>
Link: http://lkml.kernel.org/r/1357363797-3550-1-git-send-email-zhu.wen-jie@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/map.c |    3 ++-
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


