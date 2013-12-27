Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3L0KGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:06:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8856 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab3L0KGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:06:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336938"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/8] perf tools: Add support of name_only for print_events_type() function.
Date: Fri, 27 Dec 2013 18:03:31 -0500
Message-Id: <68e7b4047fa9970f4d0285a193a5031eba30caae.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:54,
	Serialize complete at 2013/12/27 18:04:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The all print_xxx_event() functions are supporting name_only argument except
print_event_type().

This patch add an argument of name_only for print_events_type() function.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c | 14 ++++++++------
 tools/perf/util/parse-events.h |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index eb0d0eef..9d7580b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1122,7 +1122,7 @@ static bool is_event_supported(u8 type, unsigned config)
 }
 
 static unsigned int __print_events_type(u8 type, struct event_symbol *syms,
-					unsigned max)
+					unsigned max, bool name_only)
 {
 	char name[64];
 	unsigned i;
@@ -1137,20 +1137,22 @@ static unsigned int __print_events_type(u8 type, struct event_symbol *syms,
 				 syms->symbol, syms->alias);
 		else
 			snprintf(name, sizeof(name), "%s", syms->symbol);
-
-		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
+		if (name_only)
+			printf("  %-50s\n", name);
+		else
+			printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
 		count++;
 	}
 
 	return count;
 }
 
-unsigned int print_events_type(u8 type)
+unsigned int print_events_type(u8 type, bool name_only)
 {
 	if (type == PERF_TYPE_SOFTWARE)
-		return __print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
+		return __print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX, name_only);
 	else
-		return __print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
+		return __print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX, name_only);
 }
 
 unsigned int print_hwcache_events(const char *event_glob, bool name_only)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index bb7d674..148a767 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -102,7 +102,7 @@ void parse_events_update_lists(struct list_head *list_event,
 void parse_events_error(void *data, void *scanner, char const *msg);
 
 unsigned int print_events(const char *event_glob, bool name_only);
-unsigned int print_events_type(u8 type);
+unsigned int print_events_type(u8 type, bool name_only);
 unsigned int print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 			     bool name_only);
 unsigned int print_hwcache_events(const char *event_glob, bool name_only);
-- 
1.8.2.1

