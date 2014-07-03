Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbaGCQlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:41:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:37587 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910AbaGCQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:41:48 -0400
Date: Thu, 3 Jul 2014 12:41:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [RFA][PATCH 18/27] sparc64,ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140703124146.3a93668f@gandalf.local.home>
In-Reply-To: <20140626165852.160038235@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.160038235@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David,

Do you have any problem with this patch going through my tree? It
compiles, but I do not have any hardware to test it. If you can verify
that this patch works and ack it, it would be much appreciated.

This code is at:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

branch: rfc/remove-function-trace-stop

Thanks!

-- Steve

On Thu, 26 Jun 2014 12:52:39 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> [ Please test this on your arch ]
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/sparc/Kconfig      |  1 -
>  arch/sparc/lib/mcount.S | 10 ++--------
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 29f2e988c56a..abd7d5575a7d 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -55,7 +55,6 @@ config SPARC64
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_GRAPH_FP_TEST
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_KRETPROBES
>  	select HAVE_KPROBES
>  	select HAVE_RCU_TABLE_FREE if SMP
> diff --git a/arch/sparc/lib/mcount.S b/arch/sparc/lib/mcount.S
> index 3ad6cbdc2163..0b0ed4d34219 100644
> --- a/arch/sparc/lib/mcount.S
> +++ b/arch/sparc/lib/mcount.S
> @@ -24,10 +24,7 @@ mcount:
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  	/* Do nothing, the retl/nop below is all we need.  */
>  #else
> -	sethi		%hi(function_trace_stop), %g1
> -	lduw		[%g1 + %lo(function_trace_stop)], %g2
> -	brnz,pn		%g2, 2f
> -	 sethi		%hi(ftrace_trace_function), %g1
> +	sethi		%hi(ftrace_trace_function), %g1
>  	sethi		%hi(ftrace_stub), %g2
>  	ldx		[%g1 + %lo(ftrace_trace_function)], %g1
>  	or		%g2, %lo(ftrace_stub), %g2
> @@ -80,11 +77,8 @@ ftrace_stub:
>  	.globl		ftrace_caller
>  	.type		ftrace_caller,#function
>  ftrace_caller:
> -	sethi		%hi(function_trace_stop), %g1
>  	mov		%i7, %g2
> -	lduw		[%g1 + %lo(function_trace_stop)], %g1
> -	brnz,pn		%g1, ftrace_stub
> -	 mov		%fp, %g3
> +	mov		%fp, %g3
>  	save		%sp, -176, %sp
>  	mov		%g2, %o1
>  	mov		%g2, %l0

