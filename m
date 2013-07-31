Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab3GaDAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:00:32 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43354 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3GaDAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:00:01 -0400
Subject: [PATCH V2 2/6] cpuidle/pseries: Remove dependency of pseries.h file
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, dongsheng.wang@freescale.com, linux-pm@vger.kernel.org
Date: Wed, 31 Jul 2013 08:29:05 +0530
Message-ID: <20130731025903.19448.92271.stgit@deepthi>
In-Reply-To: <20130731025840.19448.24468.stgit@deepthi>
References: <20130731025840.19448.24468.stgit@deepthi>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073102-5816-0000-0000-0000092D3394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a part of pseries_idle cleanup to make the backend driver
code common to both pseries and powernv, this patch
is essential to remove the dependency of pseries.h
header file.

Move the declaration of smt_snooze_delay from pseries.h
to processor_idle.c. smt_snooze_delay variable is
needed for both pseries and powernv.

/* Snooze Delay, pseries_idle */
DECLARE_PER_CPU(long, smt_snooze_delay);

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/processor_idle.c |    4 +++-
 arch/powerpc/platforms/pseries/pseries.h        |    3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index d6a1caa..64da5cc 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -20,7 +20,9 @@
 #include <asm/runlatch.h>
 
 #include "plpar_wrappers.h"
-#include "pseries.h"
+
+/* Snooze Delay, pseries_idle */
+DECLARE_PER_CPU(long, smt_snooze_delay);
 
 struct cpuidle_driver pseries_idle_driver = {
 	.name             = "pseries_idle",
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index c2a3a25..d1b07e6 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -60,9 +60,6 @@ extern struct device_node *dlpar_configure_connector(u32);
 extern int dlpar_attach_node(struct device_node *);
 extern int dlpar_detach_node(struct device_node *);
 
-/* Snooze Delay, pseries_idle */
-DECLARE_PER_CPU(long, smt_snooze_delay);
-
 /* PCI root bridge prepare function override for pseries */
 struct pci_host_bridge;
 int pseries_root_bridge_prepare(struct pci_host_bridge *bridge);

