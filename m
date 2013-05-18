Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3ERCZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:25:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3ERCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:51 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UFwVdGYv0nQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=y3PFtgut8BsA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021646.867800979@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [ 032/136 ] tracing: Fix off-by-one on allocating stat->pages
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0032-tracing-Fix-off-by-one-on-allocating-stat-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

[ Upstream commit 39e30cd1537937d3c00ef87e865324e981434e5b ]

The first page was allocated separately, so no need to start from 0.

Link: http://lkml.kernel.org/r/1364820385-32027-2-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d5525eb..f8cef7f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -624,7 +624,7 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
-	for (i = 0; i < pages; i++) {
+	for (i = 1; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;
-- 
1.7.10.4


