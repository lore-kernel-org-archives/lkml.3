Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3GDM4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:56:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34598 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3GDM4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:56:48 -0400
Message-ID: <51D57106.4070207@hitachi.com>
Date: Thu, 04 Jul 2013 21:56:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v6] tracing/uprobes: Support soft-mode disabling
References: <51D556BB.50400@huawei.com>
In-Reply-To: <51D556BB.50400@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 20:04), zhangwei(Jovi) wrote:
> Support soft-mode disabling on uprobe-based dynamic events.
> Soft-disabling is just ignoring recording if the soft disabled
> flag is set.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwe@huawei.com>

looks good for me too.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_uprobe.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 2fc9931..94f180d 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -530,6 +530,9 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
> 
>  	WARN_ON(call != ftrace_file->event_call);
> 
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		return;
> +
>  	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
>  	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
>  						call->event.type,
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


