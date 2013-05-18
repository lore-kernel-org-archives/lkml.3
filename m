Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab3ERDIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:08:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab3ERDAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:23 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=V1Zr_SbCw5IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Hyu-6kR0k7YA:10 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=ihf5QxIjnUwPrX2z:21 a=dWXqqCPx4wSIuGm-:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021656.055580038@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>, <stable@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 089/136 ] perf/x86/intel: Add support for IvyBridge model 58 Uncore
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0089-perf-x86-intel-Add-support-for-IvyBridge-model-58-Un.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vince Weaver <vincent.weaver@maine.edu>

[ Upstream commit 9a6bc14350b130427725f33e371e86212fa56c85 ]

According to Intel Vol3b 18.9, the IvyBridge model 58 uncore is
the same as that of SandyBridge.

I've done some simple tests and with this patch things seem to
work on my mac-mini.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@gmail.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1304291549320.15827@vincent-weaver-1.um.maine.edu
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 38e4894..906b553 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2820,6 +2820,7 @@ static int __init uncore_cpu_init(void)
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
+	case 58: /* Ivy Bridge */
 		if (snb_uncore_cbox.num_boxes > max_cores)
 			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
-- 
1.7.10.4


