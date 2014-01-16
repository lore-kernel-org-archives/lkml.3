Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaAPXyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:54:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45549 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAPXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:54:22 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 8/8] powerpc/perf: add kconfig option for hypervisor provided counters
Date: Thu, 16 Jan 2014 15:53:54 -0800
Message-Id: <1389916434-2288-9-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011623-9332-0000-0000-000002C9C580
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/Makefile             | 2 ++
 arch/powerpc/platforms/Kconfig.cputype | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 60d71ee..5e5fcd2 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -11,5 +11,7 @@ obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 obj-$(CONFIG_FSL_EMB_PERF_EVENT) += core-fsl-emb.o
 obj-$(CONFIG_FSL_EMB_PERF_EVENT_E500) += e500-pmu.o e6500-pmu.o
 
+obj-$(CONFIG_HV_PERF_CTRS) += hv-24x7.o hv-gpci.o
+
 obj-$(CONFIG_PPC64)		+= $(obj64-y)
 obj-$(CONFIG_PPC32)		+= $(obj32-y)
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bca2465..f98ec61 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -363,6 +363,12 @@ config PPC_PERF_CTRS
        help
          This enables the powerpc-specific perf_event back-end.
 
+config HV_PERF_CTRS
+       def_bool y
+       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT
+       help
+         Enable access to perf counters provided by the hypervisor
+
 config SMP
 	depends on PPC_BOOK3S || PPC_BOOK3E || FSL_BOOKE || PPC_47x
 	bool "Symmetric multi-processing support"
-- 
1.8.5.2

