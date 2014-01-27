Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaA0JxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:53:20 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58473 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751431AbaA0JxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:53:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] module: use pr_cont
Date: Mon, 27 Jan 2014 10:28:04 +0100
Message-Id: <1390814884-15519-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390814884-15519-1-git-send-email-jslaby@suse.cz>
References: <1390814884-15519-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dumping loaded modules, we print them one by one in separate
printks. Let's use pr_cont as they are continuation prints.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 4e9878eeb86c..7b4f69fff111 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3809,12 +3809,12 @@ void print_modules(void)
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		printk(" %s%s", mod->name, module_flags(mod, buf));
+		pr_cont(" %s%s", mod->name, module_flags(mod, buf));
 	}
 	preempt_enable();
 	if (last_unloaded_module[0])
-		printk(" [last unloaded: %s]", last_unloaded_module);
-	printk("\n");
+		pr_cont(" [last unloaded: %s]", last_unloaded_module);
+	pr_cont("\n");
 }
 
 #ifdef CONFIG_MODVERSIONS
-- 
1.8.5.2

