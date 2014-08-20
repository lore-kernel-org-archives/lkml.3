Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaHTCbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaHTCb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:31:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: eranian@google.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Joe Mario <jmario@redhat.com>
Subject: [PATCH] perf, map:  Don't try to find DSOs in SYSV maps
Date: Tue, 19 Aug 2014 22:31:14 -0400
Message-Id: <1408501874-244377-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are seeing a lot of the following with regards to SYSV memory

Failed to open /SYSV0000279c, continuing without symbols

We don't believe this memory will have DSO info, so treat it like the heap and
stack for now and skip it to prevent the warning.

Signed-off-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
--
I am open to suggetions for a different fix - dcz
---
 tools/perf/util/map.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 25c571f..0294f40 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -29,6 +29,7 @@ static inline int is_anon_memory(const char *filename)
 static inline int is_no_dso_memory(const char *filename)
 {
 	return !strncmp(filename, "[stack", 6) ||
+	       !strncmp(filename, "/SYSV",5)   ||
 	       !strcmp(filename, "[heap]");
 }
 
-- 
1.7.1

