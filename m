Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3EGED5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:03:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760360Ab3EGD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:55 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=L2ijxXTr58wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MoNTIbdOQBQA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=vnREMb7VAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035848.296583047@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [044/126] tracing: Fix double free when function profile init failed
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0044-tracing-Fix-double-free-when-function-profile-init-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

[ Upstream commit 83e03b3fe4daffdebbb42151d5410d730ae50bd1 ]

On the failure path, stat->start and stat->pages will refer same page.
So it'll attempt to free the same page again and get kernel panic.

Link: http://lkml.kernel.org/r/1364820385-32027-1-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bef5ebc..a1dd715 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -642,7 +642,6 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 
-- 
1.7.10.4


