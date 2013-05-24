Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3EXQYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:24:21 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59967 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3EXQWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:22 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Arnd Bergmann" <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 1/9] metag: of_platform_populate from arch generic code
Date: Fri, 24 May 2013 17:21:08 +0100
Message-ID: <1369412476-14245-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no init_machine callback is provided, call of_platform_populate()
instead. This allows a board/SoC that only needs to call
of_platform_populate to omit the callback altogether.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org
---
 arch/metag/kernel/setup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 4f5726f..e18cebb 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/of_fdt.h>
+#include <linux/of_platform.h>
 #include <linux/pfn.h>
 #include <linux/root_dev.h>
 #include <linux/sched.h>
@@ -424,6 +425,9 @@ static int __init customize_machine(void)
 	/* customizes platform devices, or adds new ones */
 	if (machine_desc->init_machine)
 		machine_desc->init_machine();
+	else
+		of_platform_populate(NULL, of_default_bus_match_table, NULL,
+				     NULL);
 	return 0;
 }
 arch_initcall(customize_machine);
-- 
1.8.1.2


