Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaLCBfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:35:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57673 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaLCBfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:35:54 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] Documentation: describe trace_buf_size parameter more accurately
Date: Wed,  3 Dec 2014 10:39:20 +0900
Message-Id: <1417570760-10620-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm stuck into panic that too litte free memory is left when I boot with
trace_buf_size parameter. After digging into the problem, I found that
trace_buf_size is the size of trace buffer on each cpu rather than total
size of trace buffer. To prevent victim like me, change description of
trace_buf_size parameter more accurately.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 70cfce5..fc77457 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3546,7 +3546,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			are saved.
 
 	trace_buf_size=nn[KMG]
-			[FTRACE] will set tracing buffer size.
+			[FTRACE] will set tracing buffer size on each cpu.
 
 	trace_event=[event-list]
 			[FTRACE] Set and start specified trace events in order
-- 
1.7.9.5

