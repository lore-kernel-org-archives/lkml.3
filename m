Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaCUTkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:40:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:64659 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750954AbaCUTkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:40:02 -0400
Date: Fri, 21 Mar 2014 15:40:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v7 2/2] Tracepoint: register/unregister struct
 tracepoint
Message-ID: <20140321154000.19939515@gandalf.local.home>
In-Reply-To: <1395379142-2118-3-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395379142-2118-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1395379142-2118-3-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 01:19:02 -0400

> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 4e4cc28..1592c1c 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -230,6 +230,7 @@ struct ftrace_event_call {
>  	struct list_head	list;
>  	struct ftrace_event_class *class;
>  	char			*name;
> +	struct tracepoint	*tp;


This change right here just added 17K to the kernel (on a minimum config):

   text	   data	    bss	    dec	    hex	filename
8425515	2018936	1302528	11746979	 b33ea3	vmlinux.orig
8424914	2036472	1302528	11763914	 b380ca	vmlinux

The two are redundant. Might as well remove .name and then
use .tp->name for referencing the name of the event.

-- Steve


>  	struct trace_event	event;
>  	const char		*print_fmt;
>  	struct event_filter	*filter;
