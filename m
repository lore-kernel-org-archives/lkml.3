Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3H0TNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:13:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3H0TM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:12:59 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7p2ErawryrAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=65ulK5L86BMA:10 a=QyXUC8HyAAAA:8 a=4rSY6Nn_G-8_SeuGBAQA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 15:12:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/10] tracing: add basic event trigger framework
Message-ID: <20130827151257.49e23316@gandalf.local.home>
In-Reply-To: <923484a1826a9c5b872450dc60fe41a6815a1709.1377573424.git.tom.zanussi@linux.intel.com>
References: <cover.1377573424.git.tom.zanussi@linux.intel.com>
	<923484a1826a9c5b872450dc60fe41a6815a1709.1377573424.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 22:55:59 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:


> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b1227b9..1733ac9 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1016,9 +1016,184 @@ extern void trace_event_enable_cmd_record(bool enable);
>  extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
>  extern int event_trace_del_tracer(struct trace_array *tr);
>  
> +extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
> +						 const char *system,
> +						 const char *event);

This patch breaks bisection as you need to remove the static from
find_event_file() too.

Also, it adds a lot of warnings like "register_event_command" defined
but not used.

My scripts will fail this patch if it adds a warning. No static
function should be added without being used.

-- Steve

> +
> +static inline void *event_file_data(struct file *filp)
> +{
> +	return ACCESS_ONCE(file_inode(filp)->i_private);
> +}
> +
>  extern struct mutex event_mutex;
>  extern struct list_head ftrace_events;
>  
