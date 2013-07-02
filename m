Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3GBAZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:25:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3GBAZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:25:05 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5aBJmaktoMwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=h9pOgsNgohEA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=vrmj5f9Dx7mH3hxr5ucA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372724704.22688.30.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] tracing: Make trace_marker use the correct
 per-instance buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Date: Mon, 01 Jul 2013 20:25:04 -0400
In-Reply-To: <1372717885-4543-2-git-send-email-azl@google.com>
References: <1372717885-4543-1-git-send-email-azl@google.com>
	 <1372717885-4543-2-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 15:31 -0700, Alexander Z Lam wrote:
> The trace_marker file was present for each new instance created, but it
> added the trace mark to the global trace buffer instead of to
> the instance's buffer.

Thanks, I'll get this into this merge window. And maybe even mark it for
stable.

-- Steve

> 
> Cc: David Sharp <dhsharp@google.com>
> Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Cc: Alexander Z Lam <lambchop468@gmail.com>
> Signed-off-by: Alexander Z Lam <azl@google.com>
> ---
>  kernel/trace/trace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e0b0d2a..2f7307e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4351,6 +4351,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  					size_t cnt, loff_t *fpos)
>  {
>  	unsigned long addr = (unsigned long)ubuf;
> +	struct trace_array *tr = filp->private_data;
>  	struct ring_buffer_event *event;
>  	struct ring_buffer *buffer;
>  	struct print_entry *entry;
> @@ -4410,7 +4411,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  
>  	local_save_flags(irq_flags);
>  	size = sizeof(*entry) + cnt + 2; /* possible \n added */
> -	buffer = global_trace.trace_buffer.buffer;
> +	buffer = tr->trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
>  					  irq_flags, preempt_count());
>  	if (!event) {


