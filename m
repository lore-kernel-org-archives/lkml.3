Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3JOF01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:26:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3JOF0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:21 -0400
Date: Mon, 14 Oct 2013 22:26:05 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-909b143162de7af310d2a9351220030260ebe728@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-4-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Free srcline when freeing hist_entry
Git-Commit-ID: 909b143162de7af310d2a9351220030260ebe728
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:26:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  909b143162de7af310d2a9351220030260ebe728
Gitweb:     http://git.kernel.org/tip/909b143162de7af310d2a9351220030260ebe728
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 15:58:28 -0300

perf hists: Free srcline when freeing hist_entry

We've been leaked srcline of hist_entry, it should be freed also.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f3278a3..e6fc38a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -535,6 +535,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	free(he->branch_info);
 	free(he->mem_info);
+	free(he->srcline);
 	free(he);
 }
 
