Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaEZWJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:09:23 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:43079 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaEZWJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:09:22 -0400
Date: Mon, 26 May 2014 23:09:17 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, richard@nod.at
Subject: [PATCH 06/12] [arch/mips/alchemy] Remove obsolete strict_strto calls
Message-ID: <20140526220917.GH25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH 06/12] [arch/mips/alchemy] replace obsolete strict_strto

Replace obsolete strict_strto call with kstrto

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/mips/alchemy/board-xxs1500.c | 2 +-
 arch/mips/alchemy/devboards/pm.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/alchemy/board-xxs1500.c b/arch/mips/alchemy/board-xxs1500.c
index bd55136..3fb814b 100644
--- a/arch/mips/alchemy/board-xxs1500.c
+++ b/arch/mips/alchemy/board-xxs1500.c
@@ -49,7 +49,7 @@ void __init prom_init(void)
 	prom_init_cmdline();
 
 	memsize_str = prom_getenv("memsize");
-	if (!memsize_str || strict_strtoul(memsize_str, 0, &memsize))
+	if (!memsize_str || kstrtoul(memsize_str, 0, &memsize))
 		memsize = 0x04000000;
 
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index b86bff3..61e90fe 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -158,7 +158,7 @@ static ssize_t db1x_pmattr_store(struct kobject *kobj,
 	int tmp;
 
 	if (ATTRCMP(timer_timeout)) {
-		tmp = strict_strtoul(instr, 0, &l);
+		tmp = kstrtoul(instr, 0, &l);
 		if (tmp)
 			return tmp;
 
@@ -181,7 +181,7 @@ static ssize_t db1x_pmattr_store(struct kobject *kobj,
 		}
 
 	} else if (ATTRCMP(wakemsk)) {
-		tmp = strict_strtoul(instr, 0, &l);
+		tmp = kstrtoul(instr, 0, &l);
 		if (tmp)
 			return tmp;
 
-- 
1.9.3

