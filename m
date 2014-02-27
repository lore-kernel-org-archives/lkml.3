Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaB0Vc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:32:57 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:54880 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaB0Vcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:32:52 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Lijun Pan <Lijun.Pan@freescale.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Bolle <pebolle@tiscali.nl>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 10/11] powerpc/perf: add kconfig option for hypervisor provided counters
Date: Thu, 27 Feb 2014 13:05:03 -0800
Message-Id: <1393535105-7528-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022721-9332-0000-0000-0000033F4B17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/Makefile             |  2 ++
 arch/powerpc/platforms/pseries/Kconfig | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 60d71ee..f9c083a 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -11,5 +11,7 @@ obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 obj-$(CONFIG_FSL_EMB_PERF_EVENT) += core-fsl-emb.o
 obj-$(CONFIG_FSL_EMB_PERF_EVENT_E500) += e500-pmu.o e6500-pmu.o
 
+obj-$(CONFIG_HV_PERF_CTRS) += hv-24x7.o hv-gpci.o hv-common.o
+
 obj-$(CONFIG_PPC64)		+= $(obj64-y)
 obj-$(CONFIG_PPC32)		+= $(obj32-y)
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 80b1d57..2cb8b77 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -111,6 +111,18 @@ config CMM
 	  will be reused for other LPARs. The interface allows firmware to
 	  balance memory across many LPARs.
 
+config HV_PERF_CTRS
+       bool "Hypervisor supplied PMU events (24x7 & GPCI)"
+       default y
+       depends on PERF_EVENTS && PPC_PSERIES
+       help
+	  Enable access to hypervisor supplied counters in perf. Currently,
+	  this enables code that uses the hcall GetPerfCounterInfo and 24x7
+	  interfaces to retrieve counters. GPCI exists on Power 6 and later
+	  systems. 24x7 is available on Power 8 systems.
+
+          If unsure, select Y.
+
 config DTL
 	bool "Dispatch Trace Log"
 	depends on PPC_SPLPAR && DEBUG_FS
-- 
1.9.0

