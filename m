Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBXO3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:29:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:57603 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752240AbaBXO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:29:37 -0500
Date: Mon, 24 Feb 2014 09:29:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH Resend] trace: Replace hardcoding of 19 with MAX_NICE.
Message-ID: <20140224092934.1ec35898@gandalf.local.home>
In-Reply-To: <1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
	<1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 22:12:01 +0800
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: Frederic Weisbecker <fweisbec@gmail.com>
> cc: Ingo Molnar <mingo@redhat.com>
> cc: Peter Zijlstra <peterz@infradead.org>

Peter,

If you want to take this, you can add my Acked-by.

-- Steve

> ---
>  kernel/trace/ring_buffer_benchmark.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
> index a5457d5..0434ff1 100644
> --- a/kernel/trace/ring_buffer_benchmark.c
> +++ b/kernel/trace/ring_buffer_benchmark.c
> @@ -40,8 +40,8 @@ static int write_iteration = 50;
>  module_param(write_iteration, uint, 0644);
>  MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
>  
> -static int producer_nice = 19;
> -static int consumer_nice = 19;
> +static int producer_nice = MAX_NICE;
> +static int consumer_nice = MAX_NICE;
>  
>  static int producer_fifo = -1;
>  static int consumer_fifo = -1;
> @@ -308,7 +308,7 @@ static void ring_buffer_producer(void)
>  
>  	/* Let the user know that the test is running at low priority */
>  	if (producer_fifo < 0 && consumer_fifo < 0 &&
> -	    producer_nice == 19 && consumer_nice == 19)
> +	    producer_nice == MAX_NICE && consumer_nice == MAX_NICE)
>  		trace_printk("WARNING!!! This test is running at lowest priority.\n");
>  
>  	trace_printk("Time:     %lld (usecs)\n", time);

