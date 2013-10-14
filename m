Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3JNUOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 142/161] perf tests: Fix memory leak in dso-data.c
Date: Mon, 14 Oct 2013 17:02:11 -0300
Message-Id: <1381780950-25642-143-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Pena <felipensp@gmail.com>

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
index dffe0551acaa..9cc81a3eb9b4 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -35,6 +35,7 @@ static char *test_file(int size)
 	if (size != write(fd, buf, size))
 		templ = NULL;
 
+	free(buf);
 	close(fd);
 	return templ;
 }
-- 
1.8.1.4

