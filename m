Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbaLMK7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 05:59:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966436AbaLMK7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 05:59:40 -0500
Date: Sat, 13 Dec 2014 11:59:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 2/2] tracing: Add tracepoint_printk cmdline
Message-ID: <20141213105925.GB29934@pd.tnic>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
 <20141212181420.47100d5c@gandalf.local.home>
 <20141213004830.792da019@gandalf.local.home>
 <20141213005037.78eca245@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141213005037.78eca245@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 12:50:37AM -0500, Steven Rostedt wrote:
> 
> Add the kernel command line tracepoint_printk option that will
> have tracepoints that are active sent to printk().
> 
> Passing "tracepoint_printk" will activate this. To turn it off
> the sysctl /proc/sys/kernel/tracepoint_printk can have '0' echoed
> into it. Note, this only works if the cmdline option is used.
> Echoing 1 into the sysctl file without the cmdline option will
> have no affect.
> 
> Note, this is a dangerous option. Having high frequency
> tracepoints send their data to printk() can possibly cause
> a live lock.
> 
> Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  Documentation/kernel-parameters.txt | 18 ++++++++++++++++++
>  include/linux/ftrace.h              |  1 +
>  kernel/sysctl.c                     |  7 +++++++
>  kernel/trace/trace.c                | 17 +++++++++++++++++
>  kernel/trace/trace.h                |  1 +
>  kernel/trace/trace_events.c         | 32 ++++++++++++++++++++++++++++++++
>  6 files changed, 76 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1d09eb37c562..d81f464a7358 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3500,6 +3500,24 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			See also Documentation/trace/ftrace.txt "trace options"
>  			section.
>  
> +	tracepoint_printk[FTRACE]

Damn, this is long and most likely nasty to type on some dingy box when
you're trying to debug stuff. Can we shorten it?

trace_printk
tp_printk
tp_print
tp_pr
...

Last one is my favourite - we should call it ToiletPaper_Print :-)

> +			Have the tracepoints sent to printk as well as the
> +			tracing ring buffer. This is useful for early boot up
> +			where the system hangs or reboots and does not give the
> +			option for reading the tracing buffer or performing a
> +			ftrace_dump_on_oops.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
