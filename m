Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaFWH7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaFWH7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:59:33 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6/7] tools lib traceevent: Clean up format of args in cfg80211 plugin
Date: Mon, 23 Jun 2014 09:59:17 +0200
Message-Id: <1403510358-4573-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
References: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

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
Link: http://lkml.kernel.org/r/20140612194420.24073744@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_cfg80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
-- 
1.8.3.1

