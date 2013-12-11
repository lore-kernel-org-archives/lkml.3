Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LKMjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:29392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3LKMjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448279996"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 16/71] perf tools: Allow header->data_offset to be predetermined
Date: Wed, 11 Dec 2013 14:36:28 +0200
Message-Id: <1386765443-26966-17-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

It will be necessary to predetermine header->data_offset
to allow space for attributes that are added later.
Consequently, do not change header->data_offset if it
is non-zero.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 49c4896..0114f0a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2368,7 +2368,8 @@ int perf_session__write_header(struct perf_session *session,
 		}
 	}
 
-	header->data_offset = lseek(fd, 0, SEEK_CUR);
+	if (!header->data_offset)
+		header->data_offset = lseek(fd, 0, SEEK_CUR);
 	header->feat_offset = header->data_offset + header->data_size;
 
 	if (at_exit) {
-- 
1.8.5.1

