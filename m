Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3DWOeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:34:31 -0400
Received: from multi.imgtec.com ([194.200.65.239]:40821 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab3DWOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:34:30 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/8] metag: of_platform_populate from arch generic code
Date: Tue, 23 Apr 2013 15:33:20 +0100
Message-ID: <1366727607-27444-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_04_23_15_34_27
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


