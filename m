Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3IKE66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3IKE5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:03 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ksdHbT0ixz8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jaSBfV5lrLgA:10 a=LpQP-O61AAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=YDjxKKMXsvQA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042924.110173852@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: <stable@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [192/251] perf/arm: Fix armpmu_map_hw_event()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0192-perf-arm-Fix-armpmu_map_hw_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

[ Upstream commit b88a2595b6d8aedbd275c07dfa784657b4f757eb ]

Fix constraint check in armpmu_map_hw_event().

Reported-and-tested-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/perf_event.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 5770b9d..22a022a 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -106,7 +106,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
 static int
 armpmu_map_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
 {
-	int mapping = (*event_map)[config];
+	int mapping;
+
+	if (config >= PERF_COUNT_HW_MAX)
+		return -ENOENT;
+
+	mapping = (*event_map)[config];
 	return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
 }
 
-- 
1.7.10.4


