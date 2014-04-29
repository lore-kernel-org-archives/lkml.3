Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaD2Nsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636AbaD2NsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:48:10 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/6] perf tools: Move u64_swap union
Date: Tue, 29 Apr 2014 15:47:49 +0200
Message-Id: <1398779270-10271-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
References: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to its single user's header, evsel.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/tip-9os1chjyz12upubfsjc71d99@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.h | 5 +++++
 tools/perf/util/types.h | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0c9926c..0c581d0 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -91,6 +91,11 @@ struct perf_evsel {
 	char			*group_name;
 };
 
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 #define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
 
 struct cpu_map;
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index c51fa6b..5f3689a 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -16,9 +16,4 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
-union u64_swap {
-	u64 val64;
-	u32 val32[2];
-};
-
 #endif /* __PERF_TYPES_H */
-- 
1.8.3.1

