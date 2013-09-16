Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3IPXN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:13:27 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60083 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3IPXJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:45 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 14/28] microblaze: use early_init_dt_scan
Date: Mon, 16 Sep 2013 18:09:10 -0500
Message-Id: <1379372965-22359-15-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert microblaze to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/kernel/prom.c  | 17 +++--------------
 arch/microblaze/kernel/setup.c |  2 +-
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 0c4453f..e13686e 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -106,21 +106,10 @@ void __init early_init_devtree(void *params)
 {
 	pr_debug(" -> early_init_devtree(%p)\n", params);
 
-	/* Setup flat device-tree pointer */
-	initial_boot_params = params;
+	early_init_dt_scan(params);
+	if (!strlen(boot_command_line))
+		strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 
-	/* Retrieve various informations from the /chosen node of the
-	 * device-tree, including the platform type, initrd location and
-	 * size, TCE reserve, and more ...
-	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
-
-	/* Scan memory nodes and rebuild MEMBLOCKs */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
-
-	/* Save command line for /proc/cmdline and then parse parameters */
-	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	parse_early_param();
 
 	memblock_allow_resize();
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 0775e03..6c4efba 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -50,7 +50,7 @@ char cmd_line[COMMAND_LINE_SIZE] __attribute__ ((section(".data")));
 
 void __init setup_arch(char **cmdline_p)
 {
-	*cmdline_p = cmd_line;
+	*cmdline_p = boot_command_line;
 
 	console_verbose();
 
-- 
1.8.1.2

