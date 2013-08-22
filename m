Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3HVJy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:54:26 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53359 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3HVJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:54:24 -0400
Subject: [PATCH V5 1/5] pseries/cpuidle: Remove dependency of pseries.h file
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, scottwood@freescale.com,
        linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: michael@ellerman.id.au, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, dongsheng.wang@freescale.com
Date: Thu, 22 Aug 2013 15:23:42 +0530
Message-ID: <20130822095339.27416.10361.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com>
References: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082209-5564-0000-0000-0000096020E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a part of pseries_idle cleanup to make the backend driver
code common to both pseries and powernv.
Remove non-essential smt_snooze_delay declaration in pseries.h
header file and pseries.h file inclusion in
pseries/processor_idle.c

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/processor_idle.c |    1 -
 arch/powerpc/platforms/pseries/pseries.h        |    3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 4644efa0..ca70279 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -20,7 +20,6 @@
 #include <asm/runlatch.h>
 
 #include "plpar_wrappers.h"
-#include "pseries.h"
 
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

