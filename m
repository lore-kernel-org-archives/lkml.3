Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3AYLlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:41:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3AYLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:41:29 -0500
Date: Fri, 25 Jan 2013 03:41:11 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-dccf180542c4e27621ea526769014dc97b9e5676@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356599507-14226-5-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Align cpu column to right
Git-Commit-ID: dccf180542c4e27621ea526769014dc97b9e5676
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:41:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dccf180542c4e27621ea526769014dc97b9e5676
Gitweb:     http://git.kernel.org/tip/dccf180542c4e27621ea526769014dc97b9e5676
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:22 -0300

perf sort: Align cpu column to right

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
