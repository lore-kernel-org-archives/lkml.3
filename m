Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaHXO6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:58:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaHXO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:57:57 -0400
Date: Sun, 24 Aug 2014 07:57:25 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2bfa152839e5adea66aa6309c94bf3a50a5d5d47@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1408522080-26556-2-git-send-email-namhyung@kernel.org>
References: <1408522080-26556-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Fix children overhead dump
Git-Commit-ID: 2bfa152839e5adea66aa6309c94bf3a50a5d5d47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bfa152839e5adea66aa6309c94bf3a50a5d5d47
Gitweb:     http://git.kernel.org/tip/2bfa152839e5adea66aa6309c94bf3a50a5d5d47
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 20 Aug 2014 17:07:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 20 Aug 2014 12:14:14 -0300

perf hists browser: Fix children overhead dump

When perf report runs on TUI, 'P' key dumps current screen to a file but
it incorrectly displayed children overhead (as same of self overhead).
This was because it fetched the value from self stats.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408522080-26556-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b5fa701..75eb6ac 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -304,7 +304,7 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt,				\
 static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return hpp__fmt_acc(fmt, hpp, he, he_get_##_field, " %*.2f%%",		\
+	return hpp__fmt_acc(fmt, hpp, he, he_get_acc_##_field, " %*.2f%%",	\
 			    hpp_entry_scnprintf, true);				\
 }
 
