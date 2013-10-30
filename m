Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3J3T3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab3J3T3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:29:17 -0400
Date: Wed, 30 Oct 2013 21:31:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: print microcode revision on PEBs errors
Message-ID: <20131030193150.GA7765@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sandy bridge CPUs with old microcode, PEBs
fails and suggests a microcode update.
Print out the required and the actual revision to
make it easier to figure out what's wrong.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f31a165..81f2789 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2105,6 +2105,8 @@ static int intel_snb_pebs_broken(int cpu)
 		}
 	}
 
+	pr_info("PEBS checking: microcode 0x%x min legal 0x%x\n",
+		cpu_data(cpu).microcode, rev);
 	return (cpu_data(cpu).microcode < rev);
 }
 
-- 
MST
