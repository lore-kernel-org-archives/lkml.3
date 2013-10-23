Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3JWVBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:01:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3JWU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/16] perf tools: Do not accept parse_tag_value() overflow
Date: Wed, 23 Oct 2013 17:58:10 -0300
Message-Id: <1382561895-8237-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

parse_tag_value() accepts an "unsigned long" and multiplies it according
to a tag character.  Do not accept the value if the multiplication
overflows.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-14-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index c25e57b3acb2..28a0a89c1f73 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -386,6 +386,8 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags)
 			if (s != endptr)
 				break;
 
+			if (value > ULONG_MAX / i->mult)
+				break;
 			value *= i->mult;
 			return value;
 		}
-- 
1.8.1.4

