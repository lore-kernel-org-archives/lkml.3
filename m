Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3BFWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:06:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab3BFWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:06:14 -0500
Date: Wed, 6 Feb 2013 14:05:53 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-5936f54d6ca2857d81188dcdff8c61b8fc482f53@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1360130237-9963-3-git-send-email-namhyung@kernel.org>
References: <1360130237-9963-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Check return value of strdup()
Git-Commit-ID: 5936f54d6ca2857d81188dcdff8c61b8fc482f53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:06:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5936f54d6ca2857d81188dcdff8c61b8fc482f53
Gitweb:     http://git.kernel.org/tip/5936f54d6ca2857d81188dcdff8c61b8fc482f53
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 6 Feb 2013 14:57:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:26 -0300

perf sort: Check return value of strdup()

When setup_sorting() is called, 'str' is passed to strtok_r() but it's
not checked to have a valid pointer.  As strtok_r() accepts NULL pointer
on a first argument and use the third argument in that case, it can
cause a trouble since our third argument, tmp, is not initialized.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1360130237-9963-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d8b4882..d41926c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -570,6 +570,11 @@ int setup_sorting(void)
 	char *tmp, *tok, *str = strdup(sort_order);
 	int ret = 0;
 
+	if (str == NULL) {
+		error("Not enough memory to setup sort keys");
+		return -ENOMEM;
+	}
+
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		ret = sort_dimension__add(tok);
