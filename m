Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaGBOcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:32:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:38456 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751073AbaGBOcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:32:22 -0400
Date: Wed, 2 Jul 2014 10:32:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 21/27] MIPS: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140702103221.52fe1869@gandalf.local.home>
In-Reply-To: <20140626165852.665644919@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.665644919@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding linux-mips@linux-mips.org.

-- Steve

On Thu, 26 Jun 2014 12:52:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> [ Please test this on your arch ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/mips/Kconfig         | 1 -
>  arch/mips/kernel/mcount.S | 7 -------
>  2 files changed, 8 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 7a469acee33c..9ca52987fcd5 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -15,7 +15,6 @@ config MIPS
>  	select HAVE_BPF_JIT if !CPU_MICROMIPS
>  	select ARCH_HAVE_CUSTOM_GPIO_H
>  	select HAVE_FUNCTION_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_C_RECORDMCOUNT
> diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> index 539b6294b613..00940d1d5c4f 100644
> --- a/arch/mips/kernel/mcount.S
> +++ b/arch/mips/kernel/mcount.S
> @@ -74,10 +74,6 @@ _mcount:
>  #endif
>  
>  	/* When tracing is activated, it calls ftrace_caller+8 (aka here) */
> -	lw	t1, function_trace_stop
> -	bnez	t1, ftrace_stub
> -	 nop
> -
>  	MCOUNT_SAVE_REGS
>  #ifdef KBUILD_MCOUNT_RA_ADDRESS
>  	PTR_S	MCOUNT_RA_ADDRESS_REG, PT_R12(sp)
> @@ -105,9 +101,6 @@ ftrace_stub:
>  #else	/* ! CONFIG_DYNAMIC_FTRACE */
>  
>  NESTED(_mcount, PT_SIZE, ra)
> -	lw	t1, function_trace_stop
> -	bnez	t1, ftrace_stub
> -	 nop
>  	PTR_LA	t1, ftrace_stub
>  	PTR_L	t2, ftrace_trace_function /* Prepare t2 for (1) */
>  	bne	t1, t2, static_trace

