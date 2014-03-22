Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaCVCe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 22:34:56 -0400
Received: from mail.efficios.com ([78.47.125.74]:40129 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaCVCez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 22:34:55 -0400
Date: Sat, 22 Mar 2014 02:34:59 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <1566544544.8458.1395455699322.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140321154000.19939515@gandalf.local.home>
References: <1395379142-2118-1-git-send-email-mathieu.desnoyers@efficios.com> <1395379142-2118-3-git-send-email-mathieu.desnoyers@efficios.com> <20140321154000.19939515@gandalf.local.home>
Subject: Re: [PATCH v7 2/2] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: vhy2RQxnOKsYn9esk7IKGW5v6K954w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>, "Frank Ch. Eigler" <fche@redhat.com>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Friday, March 21, 2014 3:40:00 PM
> Subject: Re: [PATCH v7 2/2] Tracepoint: register/unregister struct tracepoint
> 
> On Fri, 21 Mar 2014 01:19:02 -0400
> 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 4e4cc28..1592c1c 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -230,6 +230,7 @@ struct ftrace_event_call {
> >  	struct list_head	list;
> >  	struct ftrace_event_class *class;
> >  	char			*name;
> > +	struct tracepoint	*tp;
> 
> 
> This change right here just added 17K to the kernel (on a minimum config):
> 
>    text	   data	    bss	    dec	    hex	filename
> 8425515	2018936	1302528	11746979	 b33ea3	vmlinux.orig
> 8424914	2036472	1302528	11763914	 b380ca	vmlinux
> 
> The two are redundant. Might as well remove .name and then
> use .tp->name for referencing the name of the event.

What should we do about:

kernel/trace/trace_export.c:

struct ftrace_event_call __used event_##call = {                        \
        .name                   = #call,                                \
        .event.type             = etype,                                \
        .class                  = &event_class_ftrace_##call,           \
        .print_fmt              = print,                                \
        .flags                  = TRACE_EVENT_FL_IGNORE_ENABLE | TRACE_EVENT_FL_USE_CALL_FILTER, \
}; 

when replacing the .name for a .tp->name, it is unclear what the
tracepoint structure should be (is there even one ?).

Thanks,

Mathieu


> 
> -- Steve
> 
> 
> >  	struct trace_event	event;
> >  	const char		*print_fmt;
> >  	struct event_filter	*filter;
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
