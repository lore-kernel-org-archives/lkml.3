Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3JGQfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:35:44 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:34109 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3JGQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:35:36 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH v2 17/29] openrisc: use early_init_dt_scan
Date: Mon,  7 Oct 2013 11:29:25 -0500
Message-Id: <1381163377-21044-18-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert openrisc to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
---
 arch/openrisc/kernel/prom.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 3b94972..fbed459 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -55,20 +55,7 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 
 void __init early_init_devtree(void *params)
 {
-	/* Setup flat device-tree pointer */
-	initial_boot_params = params;
-
-
-	/* Retrieve various informations from the /chosen node of the
-	 * device-tree, including the platform type, initrd location and
-	 * size, TCE reserve, and more ...
-	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-
-	/* Scan memory nodes and rebuild MEMBLOCKs */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
-
+	early_init_dt_scan(params);
 	memblock_allow_resize();
 }
 
-- 
1.8.1.2

