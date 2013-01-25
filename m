Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3AYLjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:39:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3AYLjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:39:10 -0500
Date: Fri, 25 Jan 2013 03:38:50 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-433555221b6c8bff4fee2d5ab84e7aea6b1f068e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356599507-14226-3-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Get rid of unnecessary __maybe_unused
Git-Commit-ID: 433555221b6c8bff4fee2d5ab84e7aea6b1f068e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:38:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  433555221b6c8bff4fee2d5ab84e7aea6b1f068e
Gitweb:     http://git.kernel.org/tip/433555221b6c8bff4fee2d5ab84e7aea6b1f068e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:39 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:20 -0300

perf sort: Get rid of unnecessary __maybe_unused

Some functions have set __maybe_unused on its arguments that are used
actually.  Remove them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index ce5d404..3c2836e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -197,7 +197,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 				     u64 ip, char level, char *bf, size_t size,
-				     unsigned int width __maybe_unused)
+				     unsigned int width)
 {
 	size_t ret = 0;
 
@@ -224,8 +224,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 }
 
 static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size,
-				    unsigned int width __maybe_unused)
+				    size_t size, unsigned int width)
 {
 	return _hist_entry__sym_snprintf(self->ms.map, self->ms.sym, self->ip,
 					 self->level, bf, size, width);
@@ -398,8 +397,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
-					size_t size,
-					unsigned int width __maybe_unused)
+					 size_t size, unsigned int width)
 {
 	struct addr_map_symbol *from = &self->branch_info->from;
 	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
@@ -408,8 +406,7 @@ static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
 }
 
 static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
-				       size_t size,
-				       unsigned int width __maybe_unused)
+				       size_t size, unsigned int width)
 {
 	struct addr_map_symbol *to = &self->branch_info->to;
 	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
