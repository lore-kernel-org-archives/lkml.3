Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaFFKWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:22:34 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35356 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaFFKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:22:33 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Subject: [PATCHv2 1/2] powerpc/powernv: include asm/smp.h to fix UP build failure
Date: Fri,  6 Jun 2014 15:51:05 +0530
Message-Id: <1402050065-18007-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060610-2674-0000-0000-000000447C48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build throws following errors when CONFIG_SMP=n
arch/powerpc/platforms/powernv/setup.c: In function ‘pnv_kexec_wait_secondaries_down’:
arch/powerpc/platforms/powernv/setup.c:179:4: error: implicit declaration of function ‘get_hard_smp_processor_id’
    rc = opal_query_cpu_status(get_hard_smp_processor_id(i),

The usage of get_hard_smp_processor_id() needs the declaration from
<asm/smp.h>. The file setup.c includes <linux/sched.h>, which in-turn
includes <linux/smp.h>. However, <linux/smp.h> includes <asm/smp.h>
only on SMP configs and hence UP builds fail.

Fix this by directly including <asm/smp.h> in setup.c unconditionally.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
Changes is v2:
Commit message improved based on suggestion.

 arch/powerpc/platforms/powernv/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 8c16a5f..678573c 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -35,6 +35,7 @@
 #include <asm/rtas.h>
 #include <asm/opal.h>
 #include <asm/kexec.h>
+#include <asm/smp.h>
 
 #include "powernv.h"
 
-- 
1.9.0

