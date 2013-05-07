Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab3EGEZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:25:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3EGEZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:34 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=a1M3W7WZGDYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Tu77D8MGrwwA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=92Q717GQZsEA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035854.667844599@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, <davej@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Subject: [082/126] perf: Treat attr.config as u64 in perf_swevent_init()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0082-perf-Treat-attr.config-as-u64-in-perf_swevent_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tommi Rantala <tt.rantala@gmail.com>

[ Upstream commit 8176cced706b5e5d15887584150764894e94e02f ]

Trinity discovered that we fail to check all 64 bits of
attr.config passed by user space, resulting to out-of-bounds
access of the perf_swevent_enabled array in
sw_perf_event_destroy().

Introduced in commit b0a873ebb ("perf: Register PMU
implementations").

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1365882554-30259-1-git-send-email-tt.rantala@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7fee567..44b3539 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5131,7 +5131,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
-- 
1.7.10.4


