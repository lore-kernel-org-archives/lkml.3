Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab3FTLIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:08:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28191 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184Ab3FTLIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:08:50 -0400
Message-ID: <51C2E204.1080501@huawei.com>
Date: Thu, 20 Jun 2013 19:05:40 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace_event: using strlcpy instead of strncpy
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for NUL terminated string, need alway set '\0' in the end.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 samples/trace_events/trace-events-sample.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 6af3732..900f512 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -86,7 +86,7 @@ TRACE_EVENT(foo_bar,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->foo, foo, 10);
+		strlcpy(__entry->foo, foo, 10);
 		__entry->bar	= bar;
 	),
 
-- 
1.7.1

