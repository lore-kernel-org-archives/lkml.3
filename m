Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3C0JvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:51:12 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45862 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3C0JuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:50:02 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 04/14] tracing: add private data field into struct ftrace_event_file
Date: Wed, 27 Mar 2013 17:48:46 +0800
Message-ID: <1364377737-10540-6-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Since modules can register own event_trace_ops tracing callback
functions now, so it's reasonable to allow modules have own
private data in struct ftrace_event_file.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/linux/ftrace_event.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 27d7a4f..38c272a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -319,6 +319,8 @@ struct ftrace_event_file {
 	 * caching and such. Which is mostly OK ;-)
 	 */
 	unsigned long		flags;
+
+	void *data; /* private data */
 };
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
-- 
1.7.9.7


