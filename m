Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3FTDii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:38:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935739Ab3FTDgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:41 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hDZCwwpyj6kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UTMqbq6pfKIA:10 a=i0EeH86SAAAA:8 a=TL1yx27FxsNdgLPnaiwA:9 a=jeBq3FmKZ4MA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033639.881357328@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 09/12] tracing: Update documentation on tracepoint glob matching
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Update-documentation-on-tracepoint-glob-matc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

b0f1a59a "tracing/filters: Use a different op for glob match" added
glob matching to tracepoint filter strings. It uses the ftrace function
tracing glob matching facility that allows for the wild card character (*)
to be used at the start and/or end of the matching string.

But the documentation still states that the filtering only allows for
exact string matches.

Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/events.txt |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 4191124..37732a2 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -187,9 +187,18 @@ The operators available for numeric fields are:
 
 And for string fields they are:
 
-==, !=
+==, !=, ~
 
-Currently, only exact string matches are supported.
+The glob (~) only accepts a wild card character (*) at the start and or
+end of the string. For example:
+
+  prev_comm ~ "*sh"
+  prev_comm ~ "sh*"
+  prev_comm ~ "*sh*"
+
+But does not allow for it to be within the string:
+
+  prev_comm ~ "ba*sh"   <-- is invalid
 
 5.2 Setting filters
 -------------------
-- 
1.7.10.4


