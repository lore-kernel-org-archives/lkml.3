Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab3JOF0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:26:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3JOF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:12 -0400
Date: Mon, 14 Oct 2013 22:25:57 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-89da393c171926d3372f573d752be5ced98038eb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-3-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Reuse path from the result of addr2line
Git-Commit-ID: 89da393c171926d3372f573d752be5ced98038eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:26:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89da393c171926d3372f573d752be5ced98038eb
Gitweb:     http://git.kernel.org/tip/89da393c171926d3372f573d752be5ced98038eb
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 15:58:20 -0300

perf annotate: Reuse path from the result of addr2line

In the symbol__get_source_line(), path and src_line->path will have same
value, but they were allocated separately, and leaks one.  Just share
path to src_line->path.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7eae548..c6fd187 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1143,11 +1143,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		if (getline(&path, &line_len, fp) < 0 || !line_len)
 			goto next_close;
 
-		src_line->path = malloc(sizeof(char) * line_len + 1);
-		if (!src_line->path)
-			goto next_close;
-
-		strcpy(src_line->path, path);
+		src_line->path = path;
 		insert_source_line(&tmp_root, src_line);
 
 	next_close:
