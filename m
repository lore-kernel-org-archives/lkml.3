Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaB0Ty2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:54:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:58287 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752125AbaB0Ty0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:54:26 -0500
Date: Thu, 27 Feb 2014 14:54:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: Re: [PATCH 27/46] kernel: Mark function as static in
 kernel/trace/trace_selftest.c
Message-ID: <20140227145412.32a79f45@gandalf.local.home>
In-Reply-To: <6f07c0ca098678587c811d11ded0045293b090cc.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<6f07c0ca098678587c811d11ded0045293b090cc.1393493277.git.rashika.kheria@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:36:41 +0530
Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Mark function as static in kernel/trace/trace_selftest.c because it is
> not used outside this file.
> 
> This eliminates the following warning in kernel/trace/trace_selftest.c:
> kernel/trace/trace_selftest.c:318:5: warning: no previous prototype for ‘trace_selftest_startup_dynamic_tracing’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/trace/trace_selftest.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index e98fca6..bfecd63 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -315,9 +315,9 @@ static int trace_selftest_ops(int cnt)
>  }
>  
>  /* Test dynamic code modification and ftrace filters */
> -int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
> -					   struct trace_array *tr,
> -					   int (*func)(void))
> +static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
> +						  struct trace_array *tr,
> +						  int (*func)(void))
>  {
>  	int save_ftrace_enabled = ftrace_enabled;
>  	unsigned long count;

