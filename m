Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3JGQia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:38:30 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:49640 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3JGQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:38:26 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v2 15/29] microblaze: use early_init_dt_scan
Date: Mon,  7 Oct 2013 11:29:23 -0500
Message-Id: <1381163377-21044-16-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert microblaze to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Tested-by: Michal Simek <monstr@monstr.eu>
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

