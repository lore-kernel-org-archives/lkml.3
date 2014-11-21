Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbaKUKuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:50:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaKUKuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:50:17 -0500
Date: Fri, 21 Nov 2014 11:50:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the ftrace tree
In-Reply-To: <20141121183215.01ba539c@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1411211149490.23174@pobox.suse.cz>
References: <20141121183215.01ba539c@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Stephen Rothwell wrote:

> Hi Steven,
> 
> After merging the ftrace tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> In file included from include/asm-generic/percpu.h:6:0,
>                  from arch/powerpc/include/asm/percpu.h:19,
>                  from include/linux/percpu.h:11,
>                  from include/linux/sched.h:41,
>                  from arch/powerpc/kernel/asm-offsets.c:17:
> include/linux/percpu.h:138:17: error: 'printk_func_t' undeclared here (not in a function)
>  DECLARE_PER_CPU(printk_func_t, printk_func);
>                  ^
> include/linux/percpu-defs.h:101:38: note: in definition of macro 'DECLARE_PER_CPU_SECTION'
>   extern __PCPU_ATTRS(sec) __typeof__(type) name
>                                       ^
> include/linux/percpu.h:138:1: note: in expansion of macro 'DECLARE_PER_CPU'
>  DECLARE_PER_CPU(printk_func_t, printk_func);
>  ^




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] printk: make sure printk_func_t is known in percpu.h

Commit afdc34a3d3b8 ("printk: Add per_cpu printk func to allow printk to 
be diverted") caused percpu variable printk_func to be declared in 
percpu.h. Make sure that the corresponding type is known at the time of 
declaration.

Fixes build failure on certain arch/config combinations.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/percpu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a3aa63e..c94c766 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/pfn.h>
 #include <linux/init.h>
+#include <linux/printk.h>
 
 #include <asm/percpu.h>
 

-- 
Jiri Kosina
SUSE Labs
