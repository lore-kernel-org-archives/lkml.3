Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaFJFUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:20:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35059 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaFJFUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:20:42 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [for-next][PATCH 4/6] tracing: Return error if ftrace_trace_arrays list is empty
References: <20140606163034.516780857@goodmis.org>
	<20140606172104.693665166@goodmis.org>
Date: Tue, 10 Jun 2014 14:20:39 +0900
In-Reply-To: <20140606172104.693665166@goodmis.org> (Steven Rostedt's message
	of "Fri, 06 Jun 2014 12:30:38 -0400")
Message-ID: <87oay1bas8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2014 12:30:38 -0400, Steven Rostedt wrote:
> From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>
> ftrace_trace_arrays links global_trace.list. However, global_trace
> is not added to ftrace_trace_arrays if trace_alloc_buffers() failed.
> As the result, ftrace_trace_arrays becomes an empty list. If
> ftrace_trace_arrays is an empty list, current top_trace_array() returns
> an invalid pointer. As the result, the kernel can induce memory corruption
> or panic.
>
> Current implementation does not check whether ftrace_trace_arrays is empty
> list or not. So, in this patch, if ftrace_trace_arrays is empty list,
> top_trace_array() returns NULL. Moreover, this patch makes all functions
> calling top_trace_array() handle it appropriately.

[SNIP]
> @@ -252,6 +252,9 @@ static inline struct trace_array *top_trace_array(void)
>  {
>  	struct trace_array *tr;
>  
> +	if (list_empty(ftrace_trace_arrays.prev))
> +		return NULL;

It looks weird to me.. why not checking "list_empty(&ftrace_trace_arrays)"?

Thanks,
Namhyung

> +
>  	tr = list_entry(ftrace_trace_arrays.prev,
>  			typeof(*tr), list);
>  	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
