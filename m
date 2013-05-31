Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3EaLPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:15:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3EaLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:15:33 -0400
Date: Fri, 31 May 2013 04:15:12 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ceb2acbc2c1387c8785b3c98b482f5a2b89447c3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1364816125-12212-3-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Free unused mem info of a matched hist entry
Git-Commit-ID: ceb2acbc2c1387c8785b3c98b482f5a2b89447c3
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

Commit-ID:  ceb2acbc2c1387c8785b3c98b482f5a2b89447c3
Gitweb:     http://git.kernel.org/tip/ceb2acbc2c1387c8785b3c98b482f5a2b89447c3
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 1 Apr 2013 20:35:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:52 +0300

perf hists: Free unused mem info of a matched hist entry

The mem info is shared between matched entries so one should be freed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364816125-12212-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9438d57..514fc04 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -374,6 +374,12 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
 
+			/*
+			 * This mem info was allocated from machine__resolve_mem
+			 * and will not be used anymore.
+			 */
+			free(entry->mem_info);
+
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
 			 * similar, update it.  Otherwise we will
