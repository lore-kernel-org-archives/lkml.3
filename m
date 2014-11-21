Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbaKUMn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:43:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:32579 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755075AbaKUMnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:43:55 -0500
Date: Fri, 21 Nov 2014 07:43:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: build failure after merge of the ftrace tree
Message-ID: <20141121074343.00f72a6a@gandalf.local.home>
In-Reply-To: <20141121183215.01ba539c@canb.auug.org.au>
References: <20141121183215.01ba539c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 18:32:15 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

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
> 
> Caused by commit afdc34a3d3b8 ("printk: Add per_cpu printk func to
> allow printk to be diverted").  See Rule 1 in
> Documentation/SubmitChecklist.
> 

I had to fight header include hell with that change. That's why rule 1
wasn't followed so well.

Thanks Jiri for fixing it. I'll start running your patch through my
tests.

-- Steve
