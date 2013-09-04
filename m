Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab3IDQnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:43:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762829Ab3IDQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:43:40 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=V6A-_V-Y90oA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QgmosUVW3wMA:10 a=8vBMTGFyr98EOBUPOZAA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 4 Sep 2013 12:43:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 16/18] ftrace/rcu: Mark functions that are RCU
 unsafe
Message-ID: <20130904124338.5041c35a@gandalf.local.home>
In-Reply-To: <20130904143702.945736860@goodmis.org>
References: <20130904143552.456506259@goodmis.org>
	<20130904143702.945736860@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Sep 2013 10:36:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index aa34411..911a61c 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c

Wu's bot discovered that rcutiny.c is missing an include to ftrace.h.

Here's the change I made to this, and will rebase linux-next again to
have this. (Hopefully, Stephen hasn't pulled this branch in yet).

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 911a61c..abdfe28 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -28,6 +28,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/ftrace.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/types.h>

-- Steve


> @@ -173,6 +173,7 @@ void rcu_irq_enter(void)
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_irq_enter);
> +FTRACE_UNSAFE_RCU(rcu_irq_enter);
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 068de3a..ca53562 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -53,6 +53,7 @@
>  #include <linux/delay.h>
>  #include <linux/stop_machine.h>
>  #include <linux/random.h>
> +#include <linux/ftrace.h>
>  
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
