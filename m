Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3H0Tg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:36:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:52836 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab3H0Tg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,970,1367996400"; 
   d="scan'208";a="387314327"
Message-ID: <1377632214.15688.38.camel@empanada>
Subject: Re: [PATCH v7 02/10] tracing: add basic event trigger framework
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 27 Aug 2013 14:36:54 -0500
In-Reply-To: <20130827151257.49e23316@gandalf.local.home>
References: <cover.1377573424.git.tom.zanussi@linux.intel.com>
	 <923484a1826a9c5b872450dc60fe41a6815a1709.1377573424.git.tom.zanussi@linux.intel.com>
	 <20130827151257.49e23316@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 15:12 -0400, Steven Rostedt wrote:
> On Mon, 26 Aug 2013 22:55:59 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index b1227b9..1733ac9 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -1016,9 +1016,184 @@ extern void trace_event_enable_cmd_record(bool enable);
> >  extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
> >  extern int event_trace_del_tracer(struct trace_array *tr);
> >  
> > +extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
> > +						 const char *system,
> > +						 const char *event);
> 
> This patch breaks bisection as you need to remove the static from
> find_event_file() too.
> 
> Also, it adds a lot of warnings like "register_event_command" defined
> but not used.
> 
> My scripts will fail this patch if it adds a warning. No static
> function should be added without being used.
> 

Oops, sorry about that - I accidentally posted the v6 branch (though the
URL correctly pointed to v7).

The v7 branch actually fixes those problems, which I'll repost now..

Tom

> -- Steve
> 
> > +
> > +static inline void *event_file_data(struct file *filp)
> > +{
> > +	return ACCESS_ONCE(file_inode(filp)->i_private);
> > +}
> > +
> >  extern struct mutex event_mutex;
> >  extern struct list_head ftrace_events;
> >  


