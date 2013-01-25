Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3AYLUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:20:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3AYLUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:20:38 -0500
Date: Fri, 25 Jan 2013 03:20:12 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-50ca19aed8ad2e264ef6bce6d6d5cb7f8bfae8c9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1356030701-16284-11-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-11-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  use ARRAY_SIZE instead of reinventing it
Git-Commit-ID: 50ca19aed8ad2e264ef6bce6d6d5cb7f8bfae8c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:20:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50ca19aed8ad2e264ef6bce6d6d5cb7f8bfae8c9
Gitweb:     http://git.kernel.org/tip/50ca19aed8ad2e264ef6bce6d6d5cb7f8bfae8c9
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:19 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:15 -0300

perf script: use ARRAY_SIZE instead of reinventing it

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1356030701-16284-11-git-send-email-sasha.levin@oracle.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b363e7b..3314ef2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -692,7 +692,7 @@ static int parse_output_fields(const struct option *opt __maybe_unused,
 			    const char *arg, int unset __maybe_unused)
 {
 	char *tok;
-	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int i, imax = ARRAY_SIZE(all_output_options);
 	int j;
 	int rc = 0;
 	char *str = strdup(arg);
