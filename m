Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3EGCTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:19:09 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36982 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675Ab3EGCTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:07 -0400
X-AuditID: 85900ec0-d38c8b900000151e-ab-518864982009
Message-ID: <51886484.7060203@hitachi.com>
Date: Tue, 07 May 2013 11:18:44 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH -tip] ftrace: Fix outputting formats of x86-tsc and
 counter when use trace_clock
References: <20130423013239.22334.7394.stgit@yunodevel>
In-Reply-To: <20130423013239.22334.7394.stgit@yunodevel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would you apply this patch for the tip tree?

Thanks,
Yoshihiro YUNOMAE

(2013/04/23 10:32), Yoshihiro YUNOMAE wrote:
> Outputting formats of x86-tsc and counter should be a raw format, but after
> applying the patch(2b6080f28c7cc3efc8625ab71495aae89aeb63a0), the format was
> changed to nanosec. This is because the global variable trace_clock_id was used.
> When we use multiple buffers, clock_id of each sub-buffer should be used. Then,
> this patch uses tr->clock_id instead of the global variable trace_clock_id.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>   kernel/trace/trace.c |    8 +++-----
>   kernel/trace/trace.h |    2 --
>   2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7297079..2ab9ccb 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -652,8 +652,6 @@ static struct {
>   	ARCH_TRACE_CLOCKS
>   };
>
> -int trace_clock_id;
> -
>   /*
>    * trace_parser_get_init - gets the buffer for trace parser
>    */
> @@ -2815,7 +2813,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>   		iter->iter_flags |= TRACE_FILE_ANNOTATE;
>
>   	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
> -	if (trace_clocks[trace_clock_id].in_ns)
> +	if (trace_clocks[tr->clock_id].in_ns)
>   		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
>
>   	/* stop the trace while dumping if we are not opening "snapshot" */
> @@ -3814,7 +3812,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>   		iter->iter_flags |= TRACE_FILE_LAT_FMT;
>
>   	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
> -	if (trace_clocks[trace_clock_id].in_ns)
> +	if (trace_clocks[tr->clock_id].in_ns)
>   		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
>
>   	iter->cpu_file = tc->cpu;
> @@ -5084,7 +5082,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>   	cnt = ring_buffer_bytes_cpu(trace_buf->buffer, cpu);
>   	trace_seq_printf(s, "bytes: %ld\n", cnt);
>
> -	if (trace_clocks[trace_clock_id].in_ns) {
> +	if (trace_clocks[tr->clock_id].in_ns) {
>   		/* local or global for trace_clock */
>   		t = ns2usecs(ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
>   		usec_rem = do_div(t, USEC_PER_SEC);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 9e01458..0ae9e8a 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -705,8 +705,6 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
>
>   extern unsigned long trace_flags;
>
> -extern int trace_clock_id;
> -
>   /* Standard output formatting function used for function return traces */
>   #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


