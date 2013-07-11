Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3GKQsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:48:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3GKQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:48:00 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=TyVgHLz5XD0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oLtpoGhtZv4A:10 a=40MIqcmNAAAA:8 a=x2D7G2zzgz5T7ujOc_cA:9 a=QEXdDO2ut3YA:10 a=-tENaG0q7zQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373561279.17876.45.camel@gandalf.local.home>
Subject: Re: [PATCH] kernel: trace: remove __init from
 race_selftest_startup_function() and trace_selftest_startup_function_graph()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Jul 2013 12:47:59 -0400
In-Reply-To: <51DDFCF8.2090808@asianux.com>
References: <51DDFCF8.2090808@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 08:31 +0800, Chen Gang wrote:
> Like other trace_selftest_startup_*, trace_selftest_startup_function()
> and trace_selftest_startup_function_graph() need in normal section, or
> may cause section mismatch.
> 
> The related warnings:
> 
>     LD      kernel/trace/built-in.o
>   WARNING: kernel/trace/built-in.o(.data+0x154c): Section mismatch in reference from the variable function_trace to the function .init.text:trace_selftest_startup_function()
>   The variable function_trace references
>   the function __init trace_selftest_startup_function()
>   If the reference is valid then annotate the
>   variable with __init* or __refdata (see linux/init.h) or name the variable:
>   *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 

No the fix is to add ref_data to the user. The selftest are only called
at boot up. No need to waste memory keeping them around.

-- Steve

> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/trace/trace_selftest.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index a7329b7..e341b9d 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -640,7 +640,7 @@ out:
>   * Enable ftrace, sleep 1/10 second, and then read the trace
>   * buffer to see if all is in order.
>   */
> -__init int
> +int
>  trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
>  {
>  	int save_ftrace_enabled = ftrace_enabled;
> @@ -734,7 +734,7 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
>   * Pretty much the same than for the function tracer from which the selftest
>   * has been borrowed.
>   */
> -__init int
> +int
>  trace_selftest_startup_function_graph(struct tracer *trace,
>  					struct trace_array *tr)
>  {


