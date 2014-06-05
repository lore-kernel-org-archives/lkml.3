Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaFEPYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:24:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49574 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaFEPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:24:50 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Subject: [PATCH 2/2] powerpc/powernv : Disable subcore for UP configs
Date: Thu,  5 Jun 2014 20:54:28 +0530
Message-Id: <1401981868-4108-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401981695-3682-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1401981695-3682-1-git-send-email-shreyas@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060515-0260-0000-0000-00000514F84D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build throws following errors when CONFIG_SMP=n
arch/powerpc/platforms/powernv/subcore.c: In function ‘cpu_update_split_mode’:
arch/powerpc/platforms/powernv/subcore.c:274:15: error: ‘setup_max_cpus’ undeclared (first use in this function)
arch/powerpc/platforms/powernv/subcore.c:285:5: error: lvalue required as left operand of assignment

'setup_max_cpus' variable is relevant only on SMP, so there is no point
working around it for UP. Furthermore, subcore.c itself is relevant only
on SMP and hence the better solution is to exclude subcore.c for UP builds.

Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
This patch applies on top of ben/powerpc.git/next branch

 arch/powerpc/platforms/powernv/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
index 4ad0d34..636d206 100644
--- a/arch/powerpc/platforms/powernv/Makefile
+++ b/arch/powerpc/platforms/powernv/Makefile
@@ -1,9 +1,9 @@
 obj-y			+= setup.o opal-takeover.o opal-wrappers.o opal.o opal-async.o
 obj-y			+= opal-rtc.o opal-nvram.o opal-lpc.o opal-flash.o
 obj-y			+= rng.o opal-elog.o opal-dump.o opal-sysparam.o opal-sensor.o
-obj-y			+= opal-msglog.o subcore.o subcore-asm.o
+obj-y			+= opal-msglog.o subcore-asm.o
 
-obj-$(CONFIG_SMP)	+= smp.o
+obj-$(CONFIG_SMP)	+= smp.o subcore.o
 obj-$(CONFIG_PCI)	+= pci.o pci-p5ioc2.o pci-ioda.o
 obj-$(CONFIG_EEH)	+= eeh-ioda.o eeh-powernv.o
 obj-$(CONFIG_PPC_SCOM)	+= opal-xscom.o
-- 
1.9.0

