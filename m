Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaFFRVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:21:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:54278 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752647AbaFFRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:06 -0400
Message-Id: <20140606172104.347167544@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>
Subject: [for-next][PATCH 2/6] tracing: Convert stddev into u64 in tracepoint benchmark
References: <20140606163034.516780857@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Convert-stddev-into-u64-in-tracepoint-benchm.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

I've been told that do_div() expects an unsigned 64 bit number, and
is undefined if a signed is used. This gave a warning on the MIPS
build. I'm not sure if a signed 64 bit dividend is really an issue
or not, but the calculation this is used for is standard deviation,
and that isn't going to be negative. We can just convert it to
unsigned and be safe.

Reported-by: David Daney <ddaney.cavm@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_benchmark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_benchmark.c b/kernel/trace/trace_benchmark.c
index a10adc7095cd..8bd3365a65b2 100644
--- a/kernel/trace/trace_benchmark.c
+++ b/kernel/trace/trace_benchmark.c
@@ -33,7 +33,7 @@ static void trace_do_benchmark(void)
 	u64 start;
 	u64 stop;
 	u64 delta;
-	s64 stddev;
+	u64 stddev;
 	u64 seed;
 	u64 last_seed;
 	unsigned int avg;
-- 
2.0.0.rc2


