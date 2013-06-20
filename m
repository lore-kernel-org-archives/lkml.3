Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965353Ab3FTLJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:09:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28423 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258Ab3FTLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:09:08 -0400
Message-ID: <51C2E265.9010209@huawei.com>
Date: Thu, 20 Jun 2013 19:07:17 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace: using strlcpy instead of strncpy
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
 include/trace/events/sock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 779abb9..333d8b5 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -44,7 +44,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, prot->name, 32);
+		strlcpy(__entry->name, prot->name, 32);
 		__entry->sysctl_mem = prot->sysctl_mem;
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = prot->sysctl_rmem[0];
-- 
1.7.1

