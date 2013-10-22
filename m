Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3JVHf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:35:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:58293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3JVHf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958576"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 13/14] perf tools: Do not accept parse_tag_value() overflow
Date: Tue, 22 Oct 2013 10:34:17 +0300
Message-Id: <1382427258-17495-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_tag_value() accepts an "unsigned long" and
multiplies it according to a tag character.  Do
not accept the value if the multiplication
overflows.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index c25e57b..28a0a89 100644
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
1.7.11.7

