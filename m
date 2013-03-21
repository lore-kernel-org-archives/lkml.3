Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3CUL2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:28:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3CUL2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:28:12 -0400
Date: Thu, 21 Mar 2013 04:26:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-0d7f5b57a4373993121df4b4216e9628233b075b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1363064360-7641-1-git-send-email-namhyung@kernel.org>
References: <1363064360-7641-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Get rid of a duplicate code
Git-Commit-ID: 0d7f5b57a4373993121df4b4216e9628233b075b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:26:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d7f5b57a4373993121df4b4216e9628233b075b
Gitweb:     http://git.kernel.org/tip/0d7f5b57a4373993121df4b4216e9628233b075b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 12 Mar 2013 13:59:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:07 -0300

perf trace: Get rid of a duplicate code

Checking of sample.raw_data is duplicated and seems an artifact of some
git auto merging stuff.  Kill it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363064360-7641-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f0c20ef..49fedb5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -527,13 +527,6 @@ again:
 				continue;
 			}
 
-			if (sample.raw_data == NULL) {
-				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
-				       perf_evsel__name(evsel), sample.tid,
-				       sample.cpu, sample.raw_size);
-				continue;
-			}
-
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
