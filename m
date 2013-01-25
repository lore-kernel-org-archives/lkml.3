Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3AYLSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:18:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab3AYLSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:18:21 -0500
Date: Fri, 25 Jan 2013 03:17:52 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-53985a7bfa7b947c91f35c6adcdc9cacc6fef07f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, sasha.levin@oracle.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        mingo@redhat.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1356030701-16284-12-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-12-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  remove redundant checks from _sort__sym_cmp
Git-Commit-ID: 53985a7bfa7b947c91f35c6adcdc9cacc6fef07f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:17:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53985a7bfa7b947c91f35c6adcdc9cacc6fef07f
Gitweb:     http://git.kernel.org/tip/53985a7bfa7b947c91f35c6adcdc9cacc6fef07f
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:20 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:14 -0300

perf tools: remove redundant checks from _sort__sym_cmp

We already check that sym_l and sum_r are non-NULLs, no need to do it
twice.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356030701-16284-12-git-send-email-sasha.levin@oracle.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cfd1c0f..dbaded9 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -143,10 +143,8 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 	if (sym_l == sym_r)
 		return 0;
 
-	if (sym_l)
-		ip_l = sym_l->start;
-	if (sym_r)
-		ip_r = sym_r->start;
+	ip_l = sym_l->start;
+	ip_r = sym_r->start;
 
 	return (int64_t)(ip_r - ip_l);
 }
