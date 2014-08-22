Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaHVQ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:29:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:33602 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbaHVQ3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:29:44 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Joe Mario <jmario@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/16] perf symbols: Don't try to find DSOs in SYSV maps
Date: Fri, 22 Aug 2014 13:29:13 -0300
Message-Id: <1408724968-3441-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

We are seeing a lot of the following with regards to SYSV memory

Failed to open /SYSV0000279c, continuing without symbols

We don't believe this memory will have DSO info, so treat it like the
heap and stack for now and skip it to prevent the warning.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Joe Mario <jmario@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408501874-244377-1-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 31b8905dd863..b7090596ac50 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -31,6 +31,7 @@ static inline int is_anon_memory(const char *filename)
 static inline int is_no_dso_memory(const char *filename)
 {
 	return !strncmp(filename, "[stack", 6) ||
+	       !strncmp(filename, "/SYSV",5)   ||
 	       !strcmp(filename, "[heap]");
 }
 
-- 
1.9.3

