Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbaGIOQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:16:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:53310 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756110AbaGIOQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:16:17 -0400
Date: Wed, 9 Jul 2014 10:16:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 22/27] microblaze: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140709101615.1300f991@gandalf.local.home>
In-Reply-To: <20140626165852.891982463@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.891982463@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

Can you please ack this patch.

Thanks!

-- Steve


On Thu, 26 Jun 2014 12:52:43 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> [ Please test this on your arch ]
> 
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/microblaze/Kconfig         | 1 -
>  arch/microblaze/kernel/mcount.S | 5 -----
>  2 files changed, 6 deletions(-)
> 
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 9ae08541e30d..40e1c1dd0e24 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -22,7 +22,6 @@ config MICROBLAZE
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_GRAPH_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_MEMBLOCK
>  	select HAVE_MEMBLOCK_NODE_MAP
> diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
> index fc1e1322ce4c..fed9da5de8c4 100644
> --- a/arch/microblaze/kernel/mcount.S
> +++ b/arch/microblaze/kernel/mcount.S
> @@ -91,11 +91,6 @@ ENTRY(ftrace_caller)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  	SAVE_REGS
>  	swi	r15, r1, 0;
> -	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST begin of checking */
> -	lwi	r5, r0, function_trace_stop;
> -	bneid	r5, end;
> -	nop;
> -	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  #ifndef CONFIG_DYNAMIC_FTRACE
>  	lwi	r5, r0, ftrace_graph_return;

