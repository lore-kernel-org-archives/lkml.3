Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3AXUJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:09:35 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54080
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755900Ab3AXUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 45/74] perf sort: Align cpu column to right
Date: Thu, 24 Jan 2013 17:07:54 -0300
Message-Id: <1359058103-31645-46-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since cpu number is a natural number, it'd be more appropriate
aligning it to right.

Before:

  # Overhead  CPU      Command:  Pid          Shared Object
  # ........  ...  .................  .....................
  #
       8.91%  8    gnome-shell: 1497  perf-1497.map
       8.90%  7    gnome-shell: 1497  perf-1497.map
       8.86%  9    gnome-shell: 1497  perf-1497.map
       8.83%  6    gnome-shell: 1497  perf-1497.map
       8.81%  10   gnome-shell: 1497  perf-1497.map
       7.44%  5    gnome-shell: 1497  perf-1497.map
       6.20%  3    gnome-shell: 1497  perf-1497.map
       5.10%  0    gnome-shell: 1497  perf-1497.map

After:

  # Overhead  CPU      Command:  Pid          Shared Object
  # ........  ...  .................  .....................
  #
       8.91%    8  gnome-shell: 1497  perf-1497.map
       8.90%    7  gnome-shell: 1497  perf-1497.map
       8.86%    9  gnome-shell: 1497  perf-1497.map
       8.83%    6  gnome-shell: 1497  perf-1497.map
       8.81%   10  gnome-shell: 1497  perf-1497.map
       7.44%    5  gnome-shell: 1497  perf-1497.map
       6.20%    3  gnome-shell: 1497  perf-1497.map
       5.10%    0  gnome-shell: 1497  perf-1497.map

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 8b6d70b..a36051b 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -331,7 +331,7 @@ sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
+	return repsep_snprintf(bf, size, "%*d", width, self->cpu);
 }
 
 struct sort_entry sort_cpu = {
-- 
1.8.1.1.361.gec3ae6e

