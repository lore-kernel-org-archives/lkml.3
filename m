Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaEAKEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:04:48 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35788 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756314AbaEAKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 06:04:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUOALgaYlNXQ4cE/2dsb2JhbABZgwaraQMBAQEBAQQBmgqBDxd0gmY/GIECJBOIRQHKRoVWiHyEQAEDjxaKGAGSboM1Ow
Date: Thu, 1 May 2014 12:04:30 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/1] init/main.c: code clean-up
Message-Id: <20140501120430.d0be9c5777c817167374c90f@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some checkpatch warnings(remove global initialization, move __initdata,
coalesce formats ...)

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 init/main.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9c7fd4c..b0f9640 100644
--- a/init/main.c
+++ b/init/main.c
@@ -6,7 +6,7 @@
  *  GK 2/5/95  -  Changed to support mounting root fs via NFS
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
  *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
- *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
+ *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
  */
 
 #define DEBUG		/* Enable initcall_debug */
@@ -135,7 +135,7 @@ static char *ramdisk_execute_command;
  * Used to generate warnings if static_key manipulation functions are used
  * before jump_label_init is called.
  */
-bool static_key_initialized __read_mostly = false;
+bool static_key_initialized __read_mostly;
 EXPORT_SYMBOL_GPL(static_key_initialized);
 
 /*
@@ -158,8 +158,8 @@ static int __init set_reset_devices(char *str)
 
 __setup("reset_devices", set_reset_devices);
 
-static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
+const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
@@ -198,7 +198,6 @@ static int __init obsolete_checksetup(char *line)
  * still work even if initially too large, it will just take slightly longer
  */
 unsigned long loops_per_jiffy = (1<<12);
-
 EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
@@ -354,8 +353,8 @@ static void __init setup_command_line(char *command_line)
 	initcall_command_line =
 		memblock_virt_alloc(strlen(boot_command_line) + 1, 0);
 	static_command_line = memblock_virt_alloc(strlen(command_line) + 1, 0);
-	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, command_line);
+	strcpy(saved_command_line, boot_command_line);
+	strcpy(static_command_line, command_line);
 }
 
 /*
@@ -423,8 +422,8 @@ void __init parse_early_options(char *cmdline)
 /* Arch code calls this early on, or if not, just before other parsing. */
 void __init parse_early_param(void)
 {
-	static __initdata int done = 0;
-	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
+	static int done __initdata;
+	static char tmp_cmdline[COMMAND_LINE_SIZE] __initdata;
 
 	if (done)
 		return;
@@ -478,7 +477,7 @@ static void __init mm_init(void)
 
 asmlinkage void __init start_kernel(void)
 {
-	char * command_line;
+	char *command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
@@ -547,7 +546,8 @@ asmlinkage void __init start_kernel(void)
 	 * fragile until we cpu_idle() for the first time.
 	 */
 	preempt_disable();
-	if (WARN(!irqs_disabled(), "Interrupts were enabled *very* early, fixing it\n"))
+	if (WARN(!irqs_disabled(),
+		 "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
 	idr_init_cache();
 	rcu_init();
@@ -874,8 +874,7 @@ static int __ref kernel_init(void *unused)
 	    !try_to_run_init_process("/bin/sh"))
 		return 0;
 
-	panic("No working init found.  Try passing init= option to kernel. "
-	      "See Linux Documentation/init.txt for guidance.");
+	panic("No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.");
 }
 
 static noinline void __init kernel_init_freeable(void)
-- 
1.9.1
