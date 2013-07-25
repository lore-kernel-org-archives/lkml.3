Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3GYDuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:50:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3402 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3GYDuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:50:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,740,1367942400"; 
   d="scan'208";a="8015285"
Message-ID: <51F0A152.4010907@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 11:53:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: remove the found node directly before break the
 search-loop
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:48:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:48:01,
	Serialize complete at 2013/07/25 11:48:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a clean-up, but it gives us better readability.

Sign-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7d85429..a44f501 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1827,13 +1827,13 @@ static void trace_module_remove_events(struct module *mod)
 
 	/* Now free the file_operations */
 	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
-		if (file_ops->mod == mod)
+		if (file_ops->mod == mod) {
+			list_del(&file_ops->list);
+			kfree(file_ops);
 			break;
+		}
 	}
-	if (&file_ops->list != &ftrace_module_file_list) {
-		list_del(&file_ops->list);
-		kfree(file_ops);
-	}
+
 	up_write(&trace_event_sem);
 
 	/*
