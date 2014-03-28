Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaC1UNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:13:05 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41789 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaC1ULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:11:48 -0400
From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, Linux PM list <linux-pm@vger.kernel.org>,
        svaidy@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Anton Blanchard <anton@samba.org>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
Subject: [PATCH v5 1/3] powernv, cpufreq: Select CPUFreq related Kconfig options for powernv
Date: Sat, 29 Mar 2014 01:41:22 +0530
Message-Id: <1396037484-23907-2-git-send-email-ego@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
References: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032820-9574-0000-0000-00000CAB4991
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>

Enable CPUFreq for PowerNV. Select "performance", "powersave",
"userspace" and "ondemand" governors. Choose "ondemand" to be the
default governor.

Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
 arch/powerpc/configs/pseries_defconfig    | 1 +
 arch/powerpc/configs/pseries_le_defconfig | 1 +
 arch/powerpc/platforms/powernv/Kconfig    | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 9ea8342b..a905063 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -306,3 +306,4 @@ CONFIG_KVM_BOOK3S_64=m
 CONFIG_KVM_BOOK3S_64_HV=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
+CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
diff --git a/arch/powerpc/configs/pseries_le_defconfig b/arch/powerpc/configs/pseries_le_defconfig
index 3c84f9d..58e3dbf 100644
--- a/arch/powerpc/configs/pseries_le_defconfig
+++ b/arch/powerpc/configs/pseries_le_defconfig
@@ -301,3 +301,4 @@ CONFIG_CRYPTO_LZO=m
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_DEV_NX=y
 CONFIG_CRYPTO_DEV_NX_ENCRYPT=m
+CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 895e8a2..c252ee9 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -11,6 +11,12 @@ config PPC_POWERNV
 	select PPC_UDBG_16550
 	select PPC_SCOM
 	select ARCH_RANDOM
+	select CPU_FREQ
+	select CPU_FREQ_GOV_PERFORMANCE
+	select CPU_FREQ_GOV_POWERSAVE
+	select CPU_FREQ_GOV_USERSPACE
+	select CPU_FREQ_GOV_ONDEMAND
+	select CPU_FREQ_GOV_CONSERVATIVE
 	default y
 
 config PPC_POWERNV_RTAS
-- 
1.8.3.1

