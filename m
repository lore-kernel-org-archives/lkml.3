Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaFYFt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:49:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaFYFtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:49:55 -0400
Date: Tue, 24 Jun 2014 22:49:44 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-24eda087ccbb32f556cb3f9f78be152312bf6cc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140612194420.24073744@gandalf.local.home>
References: <20140612194420.24073744@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Clean up format of args in cfg80211 plugin
Git-Commit-ID: 24eda087ccbb32f556cb3f9f78be152312bf6cc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24eda087ccbb32f556cb3f9f78be152312bf6cc4
Gitweb:     http://git.kernel.org/tip/24eda087ccbb32f556cb3f9f78be152312bf6cc4
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Thu, 12 Jun 2014 19:44:20 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:18:36 +0200

tools lib traceevent: Clean up format of args in cfg80211 plugin

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
