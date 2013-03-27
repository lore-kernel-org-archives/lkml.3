Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3C0JuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:50:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:46196 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3C0JuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:50:11 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 13/14] libtraceevent: add libtraceevent prefix in warning message
Date: Wed, 27 Mar 2013 17:48:55 +0800
Message-ID: <1364377737-10540-15-git-send-email-jovi.zhangwei@huawei.com>
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

Now using perf tracepoint, perf output some warning message
which hard to understand what's wrong in perf.

[root@jovi perf]# ./perf stat -e timer:* ls
  Warning: unknown op '{'
  Warning: unknown op '{'
...

Actually these warning message is caused by libtraceevent format
parsing code.

So add libtraceevent prefix to identify this more clearly.

(we should remove all those warning message when running perf stat in future,
it's not necessary to parse event format when running perf stat)

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 tools/lib/traceevent/event-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 82b0606..a3971d2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -47,7 +47,7 @@ static int show_warning = 1;
 #define do_warning(fmt, ...)				\
 	do {						\
 		if (show_warning)			\
-			warning(fmt, ##__VA_ARGS__);	\
+			warning("libtraceevent: "fmt, ##__VA_ARGS__);	\
 	} while (0)
 
 static void init_input_buf(const char *buf, unsigned long long size)
-- 
1.7.9.7


