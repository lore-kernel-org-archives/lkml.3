Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3EJOjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:39:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823Ab3EJOU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        paulus@samba.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.647822379@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [077/118] perf: Fix error return code
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit c481420248c6730246d2a1b1773d5d7007ae0835 upstream.

Fix to return -ENOMEM in the allocation error case instead of 0
(if pmu_bus_running == 1), as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/CAPgLHd8j_fWcgqe%3DKLWjpBj%2B%3Do0Pw6Z-SEq%3DNTPU08c2w1tngQ@mail.gmail.com
[ Tweaked the error code setting placement and the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5756,6 +5756,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;

