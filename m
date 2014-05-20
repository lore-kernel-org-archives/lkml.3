Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaETKBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:01:16 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45910 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:01:15 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Subject: [PATCH] powerpc/powernv: Fix build error when CONFIG_SMP=n
Date: Tue, 20 May 2014 15:25:26 +0530
Message-Id: <1400579726-26206-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052010-1618-0000-0000-0000004507B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build error when compiled with CONFIG_SMP=n
arch/powerpc/platforms/powernv/setup.c: In function ‘pnv_kexec_wait_secondaries_down’:
arch/powerpc/platforms/powernv/setup.c:179:4: error: implicit declaration of function ‘get_hard_smp_processor_id’ [-Werror=implicit-function-declaration]
    rc = opal_query_cpu_status(get_hard_smp_processor_id(i),

The usage of get_hard_smp_processor_id() needs the declaration from <asm/smp.h>.
The file setup.c includes <linux/sched.h>, which in-turn includes <linux/smp.h>.
However, <linux/smp.h> includes <asm/smp.h> only on SMP configs and hence UP
builds fail. Fix this by directly including <asm/smp.h> in setup.c
unconditionally.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 8723d32..e6bde98 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -34,6 +34,7 @@
 #include <asm/rtas.h>
 #include <asm/opal.h>
 #include <asm/kexec.h>
+#include <asm/smp.h>
 
 #include "powernv.h"
 
-- 
1.9.0

