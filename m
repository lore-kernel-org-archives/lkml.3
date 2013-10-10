Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3JJCAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:00:37 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36602 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JJCAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:00:36 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] tools/perf/tests: Fix memory leak in dso-data.c
Date: Wed,  9 Oct 2013 23:00:38 -0300
Message-Id: <1381370438-4209-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a memory leak on test_file() function in dso-data.c

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 tools/perf/tests/dso-data.c |    1 +
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
--
1.7.10.4

