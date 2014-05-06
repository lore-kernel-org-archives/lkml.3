Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbaEFMfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:35:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:17115 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754997AbaEFMfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:35:38 -0400
Date: Tue, 6 May 2014 08:35:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: tracing: Replace __get_cpu_var uses with this_cpu_ptr
Message-ID: <20140506083536.7316e35a@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1404291415560.18364@gentwo.org>
References: <alpine.DEB.2.10.1404291415560.18364@gentwo.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 14:17:40 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> Replace uses of &__get_cpu_var for address calculation with this_cpu_ptr.
> 

I pulled this into my 3.16 queue.

-- Steve

> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/include/linux/kprobes.h
> ===================================================================
> --- linux.orig/include/linux/kprobes.h	2014-04-28 13:09:07.228660946 -0500
> +++ linux/include/linux/kprobes.h	2014-04-28 13:09:07.224661022 -0500
> @@ -356,7 +356,7 @@
> 
>  static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
>  {
> -	return (&__get_cpu_var(kprobe_ctlblk));
> +	return this_cpu_ptr(&kprobe_ctlblk);
>  }
> 
>  int register_kprobe(struct kprobe *p);
> Index: linux/kernel/trace/ftrace.c
> ===================================================================
> --- linux.orig/kernel/trace/ftrace.c	2014-04-28 13:09:07.228660946 -0500
> +++ linux/kernel/trace/ftrace.c	2014-04-28 13:09:07.224661022 -0500
> @@ -817,7 +817,7 @@
> 
>  	local_irq_save(flags);
> 
> -	stat = &__get_cpu_var(ftrace_profile_stats);
> +	stat = this_cpu_ptr(&ftrace_profile_stats);
>  	if (!stat->hash || !ftrace_profile_enabled)
>  		goto out;
> 
> @@ -848,7 +848,7 @@
>  	unsigned long flags;
> 
>  	local_irq_save(flags);
> -	stat = &__get_cpu_var(ftrace_profile_stats);
> +	stat = this_cpu_ptr(&ftrace_profile_stats);
>  	if (!stat->hash || !ftrace_profile_enabled)
>  		goto out;
> 
> Index: linux/kernel/trace/trace.c
> ===================================================================
> --- linux.orig/kernel/trace/trace.c	2014-04-28 13:09:07.228660946 -0500
> +++ linux/kernel/trace/trace.c	2014-04-28 13:09:07.228660946 -0500
> @@ -1728,7 +1728,7 @@
>  	 */
>  	barrier();
>  	if (use_stack == 1) {
> -		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
> +		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
>  		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
> 
>  		if (regs)

