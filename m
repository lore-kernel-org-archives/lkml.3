Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3HLNIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:08:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3HLNIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:08:00 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=o1DMDrm1X-kA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GXsRlKxiux4A:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=J1zekULjJXrC-hiuJvYA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 12 Aug 2013 09:07:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] ftrace: Add initialization check in trace_printk for
 *puts paths
Message-ID: <20130812090758.2c0018a6@gandalf.local.home>
In-Reply-To: <1376300045-3956-1-git-send-email-jolsa@redhat.com>
References: <1376300045-3956-1-git-send-email-jolsa@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 11:34:05 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> Adding initialization check in trace_printk for *puts
> paths, plus unifying the check for all related cases.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/trace.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 882ec1d..cb7cf96 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -126,6 +126,9 @@ static char *default_bootup_tracer;
>  
>  static bool allocate_snapshot;
>  
> +#define TRACE_PRINTK_DENIED \


s/TRACE_PRINTK_DENIED/TRACE_PRINTK_DISABLED/

-- Steve

> +	unlikely(tracing_selftest_running || tracing_disabled)
> +
>  static int __init set_cmdline_ftrace(char *str)
>  {
>  	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
> 
