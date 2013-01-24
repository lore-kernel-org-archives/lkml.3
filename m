Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3AXUIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:08:38 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53903
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587Ab3AXUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/74] perf tests: Fix PYTHONPATH for python-use test tracepoints
Date: Thu, 24 Jan 2013 17:07:30 -0300
Message-Id: <1359058103-31645-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

If there's not OUTPUT variable defined the PYTHONPATH ends up with
/python. We need to remove the extra '/'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-h1hzfyfcdxjnuq9fin2cjwlr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3158f45..1539eb4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -958,7 +958,7 @@ $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 
 $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		-DPYTHONPATH='"$(OUTPUT)/python"' \
+		-DPYTHONPATH='"$(OUTPUT)python"' \
 		-DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
-- 
1.8.1.1.361.gec3ae6e

