Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaFEEUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaFEEUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Ingo Molnar <mingo@kernel.org>, Rui Xiang <rui.xiang@huawei.com>,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net
Subject: [PATCH 3.4 083/214] perf: Fix error return code
Date: Wed,  4 Jun 2014 21:17:26 -0700
Message-Id: <20140605041650.743735178@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5871,6 +5871,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;


