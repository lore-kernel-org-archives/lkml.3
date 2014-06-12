Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbaFLXoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:44:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:26191 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbaFLXoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:44:24 -0400
Date: Thu, 12 Jun 2014 19:44:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools lib traceevent: Clean up format of args in cfg80211
 plugin
Message-ID: <20140612194420.24073744@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While synchronizing what's in trace-cmd vs what's in perf, I came
across a change that was made when entering the cfg80211 plugin into
the tools/lib/traceevent directory. The function prototype went from:

static unsigned long long process___le16_to_cpup(struct trace_seq *s,
						 unsigned long long *args)

to:

static unsigned long long
process___le16_to_cpup(struct trace_seq *s,
		       unsigned long long *args)

I can understand the line break after the long long, but there's no
reason to keep args on a separate line.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index c066b25..4592d84 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -5,8 +5,7 @@
 #include "event-parse.h"
 
 static unsigned long long
-process___le16_to_cpup(struct trace_seq *s,
-		       unsigned long long *args)
+process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 {
 	uint16_t *val = (uint16_t *) (unsigned long) args[0];
 	return val ? (long long) le16toh(*val) : 0;
