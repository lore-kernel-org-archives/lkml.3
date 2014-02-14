Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaBNWDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:03:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50759 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaBNWDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:03:42 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lijun Pan <Lijun.Pan@freescale.com>, Li Yang <leoli@freescale.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Bolle <pebolle@tiscali.nl>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Tang Yuantian <yuantian.tang@freescale.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 10/11] powerpc/perf: add kconfig option for hypervisor provided counters
Date: Fri, 14 Feb 2014 14:02:14 -0800
Message-Id: <1392415338-16288-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021422-7182-0000-0000-000009D768B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/Makefile             | 2 ++
 arch/powerpc/platforms/Kconfig.cputype | 6 ++++++
 2 files changed, 8 insertions(+)

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
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 434fda3..dcc67cd 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -364,6 +364,12 @@ config PPC_PERF_CTRS
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
1.8.5.4

