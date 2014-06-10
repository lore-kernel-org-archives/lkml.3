Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaFJNm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:42:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:31830 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740AbaFJNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:42:56 -0400
Date: Tue, 10 Jun 2014 09:42:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [for-next][PATCH 4/6] tracing: Return error if
 ftrace_trace_arrays list is empty
Message-ID: <20140610094247.5fcde204@gandalf.local.home>
In-Reply-To: <87oay1bas8.fsf@sejong.aot.lge.com>
References: <20140606163034.516780857@goodmis.org>
	<20140606172104.693665166@goodmis.org>
	<87oay1bas8.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 14:20:39 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> On Fri, 06 Jun 2014 12:30:38 -0400, Steven Rostedt wrote:
> > From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> >
> > ftrace_trace_arrays links global_trace.list. However, global_trace
> > is not added to ftrace_trace_arrays if trace_alloc_buffers() failed.
> > As the result, ftrace_trace_arrays becomes an empty list. If
> > ftrace_trace_arrays is an empty list, current top_trace_array() returns
> > an invalid pointer. As the result, the kernel can induce memory corruption
> > or panic.
> >
> > Current implementation does not check whether ftrace_trace_arrays is empty
> > list or not. So, in this patch, if ftrace_trace_arrays is empty list,
> > top_trace_array() returns NULL. Moreover, this patch makes all functions
> > calling top_trace_array() handle it appropriately.
> 
> [SNIP]
> > @@ -252,6 +252,9 @@ static inline struct trace_array *top_trace_array(void)
> >  {
> >  	struct trace_array *tr;
> >  
> > +	if (list_empty(ftrace_trace_arrays.prev))
> > +		return NULL;
> 
> It looks weird to me.. why not checking "list_empty(&ftrace_trace_arrays)"?
> 

Bah, I don't know how I missed that. Thanks.

-- Steve

> Thanks,
> Namhyung
> 
> > +
> >  	tr = list_entry(ftrace_trace_arrays.prev,
> >  			typeof(*tr), list);
> >  	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));

