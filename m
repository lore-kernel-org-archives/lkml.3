Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab3JOFd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:33:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3JOFd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:33:26 -0400
Date: Mon, 14 Oct 2013 22:33:11 -0700
From: tip-bot for Felipe Pena <tipbot@zytor.com>
Message-ID: <tip-1df9297c8535a5bb2b776381e63d8334f87d4abe@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, felipensp@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, felipensp@gmail.com, tglx@linutronix.de
In-Reply-To: <1381370438-4209-1-git-send-email-felipensp@gmail.com>
References: <1381370438-4209-1-git-send-email-felipensp@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix memory leak in dso-data.c
Git-Commit-ID: 1df9297c8535a5bb2b776381e63d8334f87d4abe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:33:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1df9297c8535a5bb2b776381e63d8334f87d4abe
Gitweb:     http://git.kernel.org/tip/1df9297c8535a5bb2b776381e63d8334f87d4abe
Author:     Felipe Pena <felipensp@gmail.com>
AuthorDate: Wed, 9 Oct 2013 23:00:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:28:54 -0300

perf tests: Fix memory leak in dso-data.c

Fix for a memory leak on test_file() function in dso-data.c.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381370438-4209-1-git-send-email-felipensp@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dso-data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index dffe055..9cc81a3 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -35,6 +35,7 @@ static char *test_file(int size)
 	if (size != write(fd, buf, size))
 		templ = NULL;
 
+	free(buf);
 	close(fd);
 	return templ;
 }
