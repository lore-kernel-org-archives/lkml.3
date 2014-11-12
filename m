Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaKLXmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:42:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:15034 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753775AbaKLXmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:42:32 -0500
Date: Wed, 12 Nov 2014 18:42:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: linux-kernel@vger.kernel.org, Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH] ftrace: fix traceoff_on_warning handling on boot
 command line
Message-ID: <20141112184230.1d59fd28@gandalf.local.home>
In-Reply-To: <20141112231400.GL12281@uudg.org>
References: <20141112231400.GL12281@uudg.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014 21:14:00 -0200
"Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:

> Steven,
> 
> While backporting traceoff_on_warning to 3.10.33-rt we noticed a slightly
> difference between what was stated on Documentation/kernel-parameters.txt
> and the actual code.
> 
> Please consider the following patch for inclusion.
> 
> Best regards,
> Luis
> 

Thanks Luis, I'll add it to my queue.

-- Steve

> ------
> 
> ftrace: fix traceoff_on_warning handling on boot command line
> 
> According to the documentation, adding "traceoff_on_warning" to the boot
> command line should be enough to enable the feature. But right now it is
> necessary to specify "traceoff_on_warning=". Along with fixing that, also
> verify if the value passed, if any, is either "0" or "off".
> 
> Signed-off-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f68981f..a956a60 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -155,10 +155,11 @@ __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
>  
>  static int __init stop_trace_on_warning(char *str)
>  {
> -	__disable_trace_on_warning = 1;
> +	if ((strcmp(str, "=0") != 0 && strcmp(str, "=off") != 0))
> +		__disable_trace_on_warning = 1;
>  	return 1;
>  }
> -__setup("traceoff_on_warning=", stop_trace_on_warning);
> +__setup("traceoff_on_warning", stop_trace_on_warning);
>  
>  static int __init boot_alloc_snapshot(char *str)
>  {
> 

