Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3DPJlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:41:06 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35726 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3DPJlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:41:03 -0400
Date: Tue, 16 Apr 2013 04:41:00 -0500
From: Robin Holt <holt@sgi.com>
To: Joe Perches <joe@perches.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v3 3/4] checkpatch.pl the new kernel/reboot.c file.
Message-ID: <20130416094100.GK3658@sgi.com>
References: <20130415171225.GC3658@sgi.com>
 <20130415171603.GH3672@sgi.com>
 <1366047938.31131.6.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366047938.31131.6.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 10:45:38AM -0700, Joe Perches wrote:
> On Mon, 2013-04-15 at 12:16 -0500, Robin Holt wrote:
> > I did allow the remaining 81 character line behind.  It did not seem
> > like it was worth changing.  Otherwise, it now passes checkpatch.pl.
> 
> trivia:
> 
> I'd make these changes on top of your patch:
> 
> o Additional OOM messages aren't necessary as a dump_stack is done

I am not sure what I should be doing with this one.  The only message
that seems close is the pr_warn("%s failed to allocate memory for...
but I don't see how dump_stack is getting invoked so I think either
you did not mean this message or you intended me to replace that with a
dump_stack, in which case, the error message would still be informative
and the dump_stack would be relatively useless.

> o Add pr_fmt to prefix logging messages with "reboot: "

Done.  I did not see anything in the CodingStyle about this so I hope
I did it correctly.  It will change some long-seen messages during
shutdown/reboot.  Is that acceptable?

> o Remove periods from logging messages

Done.  I read the CodingStyle guide's "Kernel messages do not have to
be terminated with a period." to mean they did not need to be removed.
I would not normally have touched them as I effectively moved them from
one file to another and I followed the guiding principal of do not mess
with somebody else's code style (especially Linus') unless necessary.

> o Argument alignment

Again, not sure what you want here.  I kept the formatting fairly
consistent when I resolved the checkpatch.pl bits.  I believe I only
changed the formatting on one if() statement.  I had used tab followed
by space so I fixed that up in -v4.

> o Rename file prefix to "reboot.c"

I did fix up the comment which said sys.c.  Is that what you were
asking for?  If not, could you be more specific?

> o Add #include <linux/suspend.h> so it compiles

Done.

Thanks,
Robin


Subject: [Patch -v4 3/4] checkpatch.pl the new kernel/reboot.c file.

I did allow the remaining 81 character line behind.  It did not seem
like it was worth changing.  Otherwise, it now passes checkpatch.pl.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Holt <holt@sgi.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Joe Perches <joe@perches.com>

---

Changes since -v3:
Integrated feedback from Joe Perches.

 kernel/reboot.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 907ab48..8cfef20 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -1,9 +1,11 @@
 /*
- *  linux/kernel/sys.c
+ *  linux/kernel/reboot.c
  *
  *  Copyright (C) 2013  Linus Torvalds
  */
 
+#define pr_fmt(fmt)	"reboot: " fmt
+
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
@@ -97,9 +99,9 @@ void kernel_restart(char *cmd)
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
-		printk(KERN_EMERG "Restarting system.\n");
+		pr_emerg("Restarting system\n");
 	else
-		printk(KERN_EMERG "Restarting system with command '%s'.\n", cmd);
+		pr_emerg("Restarting system with command '%s'\n", cmd);
 	kmsg_dump(KMSG_DUMP_RESTART);
 	machine_restart(cmd);
 }
@@ -108,7 +110,7 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
+		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -123,11 +125,10 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "System halted.\n");
+	pr_emerg("System halted\n");
 	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
 }
-
 EXPORT_SYMBOL_GPL(kernel_halt);
 
 /**
@@ -142,7 +143,7 @@ void kernel_power_off(void)
 		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "Power down.\n");
+	pr_emerg("Power down\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
@@ -171,10 +172,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 	/* For safety, we require "magic" arguments. */
 	if (magic1 != LINUX_REBOOT_MAGIC1 ||
-	    (magic2 != LINUX_REBOOT_MAGIC2 &&
-	                magic2 != LINUX_REBOOT_MAGIC2A &&
+			(magic2 != LINUX_REBOOT_MAGIC2 &&
+			magic2 != LINUX_REBOOT_MAGIC2A &&
 			magic2 != LINUX_REBOOT_MAGIC2B &&
-	                magic2 != LINUX_REBOOT_MAGIC2C))
+			magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
 	/*
@@ -283,14 +284,13 @@ static int __orderly_poweroff(bool force)
 		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 		argv_free(argv);
 	} else {
-		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
-					 __func__, poweroff_cmd);
+		pr_warn("%s failed to allocate memory for \"%s\"\n",
+						__func__, poweroff_cmd);
 		ret = -ENOMEM;
 	}
 
 	if (ret && force) {
-		printk(KERN_WARNING "Failed to start orderly shutdown: "
-					"forcing the issue\n");
+		pr_warn("Failed to start orderly shutdown: forcing the issue\n");
 		/*
 		 * I guess this should try to kick off some daemon to sync and
 		 * poweroff asap.  Or not even bother syncing if we're doing an
-- 
1.8.1.2

