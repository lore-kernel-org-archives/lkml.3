Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3JWHy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:54:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3JWHyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:54 -0400
Date: Wed, 23 Oct 2013 00:54:30 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-243be3dd7c14454899e51334a6d66d29a41ae6ab@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382099356-4918-18-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-18-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Print addr by default for BTS
Git-Commit-ID: 243be3dd7c14454899e51334a6d66d29a41ae6ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:54:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  243be3dd7c14454899e51334a6d66d29a41ae6ab
Gitweb:     http://git.kernel.org/tip/243be3dd7c14454899e51334a6d66d29a41ae6ab
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 18 Oct 2013 15:29:14 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 17:33:22 -0300

perf script: Print addr by default for BTS

The addr field is not displayed by default for hardware events, however
for branch events it is the target of the branch so for BTS display it
by default if it was recorded.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382099356-4918-18-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9c333ff..ebb2b5f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -409,7 +409,9 @@ static void print_sample_bts(union perf_event *event,
 	printf(" => ");
 
 	/* print branch_to information */
-	if (PRINT_FIELD(ADDR))
+	if (PRINT_FIELD(ADDR) ||
+	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
+	     !output[attr->type].user_set))
 		print_sample_addr(event, sample, machine, thread, attr);
 
 	printf("\n");
