Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbaKSVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:24:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869AbaKSVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Hou Pengyang <houpengyang@huawei.com>
Subject: [PATCH 3.10 54/70] perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge
Date: Wed, 19 Nov 2014 12:52:45 -0800
Message-Id: <20141119205212.708219964@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vince Weaver <vincent.weaver@maine.edu>

commit 1996388e9f4e3444db8273bc08d25164d2967c21 upstream.

This was discussed back in February:

	https://lkml.org/lkml/2014/2/18/956

But I never saw a patch come out of it.

On IvyBridge we share the SandyBridge cache event tables, but the
dTLB-load-miss event is not compatible.  Patch it up after
the fact to the proper DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Hou Pengyang <houpengyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2172,6 +2172,9 @@ __init int intel_pmu_init(void)
 	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		/* dTLB-load-misses on IVB is different than SNB */
+		hw_cache_event_ids[C(DTLB)][C(OP_READ)][C(RESULT_MISS)] = 0x8108; /* DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK */
+
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
 		       sizeof(hw_cache_extra_regs));
 


