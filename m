Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3LUWos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 17:44:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:47826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab3LUWoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 17:44:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,529,1384329600"; 
   d="scan'208";a="453969767"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 3/3] tracing: Add rcu annotation for event_trigger_data.filter
Date: Sat, 21 Dec 2013 16:44:02 -0600
Message-Id: <676c1cf2faa6715acefcbc5de5d75acd71586496.1387662969.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains about rcu_assign_pointer() and RCU_INIT_POINTER()
assignments to event_trigger_data filter; annotate it with __rcu to
get rid of the warning.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 433bfc5..24b16fb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1055,7 +1055,7 @@ struct event_trigger_data {
 	int				ref;
 	struct event_trigger_ops	*ops;
 	struct event_command		*cmd_ops;
-	struct event_filter		*filter;
+	struct event_filter __rcu	*filter;
 	char				*filter_str;
 	void				*private_data;
 	struct list_head		list;
-- 
1.8.3.1

