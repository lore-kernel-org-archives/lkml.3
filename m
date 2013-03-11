Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3CKHOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61040 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab3CKHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:00 -0400
Message-ID: <513D8421.4070404@huawei.com>
Date: Mon, 11 Mar 2013 15:13:37 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 02/13] tracing: use TRACE_MAX_PRINT
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_MAX_PRINT macro is defined at there, but not used.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 11cd56b..090eddb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5080,8 +5080,8 @@ void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
-	if (s->len >= 1000)
-		s->len = 1000;
+	if (s->len >= TRACE_MAX_PRINT)
+		s->len = TRACE_MAX_PRINT;

 	/* should be zero ended, but we are paranoid. */
 	s->buffer[s->len] = 0;
-- 
1.7.9.7


