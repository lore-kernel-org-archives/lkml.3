Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3KFFdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:33:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:39594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3KFFc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:32:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,644,1378882800"; 
   d="scan'208";a="422945778"
Message-ID: <1383715977.18822.83.camel@empanada>
Subject: Re: [PATCH 1/3] tracing: Update event filters for multibuffer
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Nov 2013 23:32:57 -0600
In-Reply-To: <20131105172745.2ebbd6ba@gandalf.local.home>
References: <cover.1382620672.git.tom.zanussi@linux.intel.com>
	 <f16e9ce4270c62f46b2e966119225e1c3cca7e60.1382620672.git.tom.zanussi@linux.intel.com>
	 <20131105172745.2ebbd6ba@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 17:27 -0500, Steven Rostedt wrote:
> On Thu, 24 Oct 2013 08:34:17 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> 
> > @@ -1577,6 +1577,7 @@ static void event_remove(struct ftrace_event_call *call)
> >  		if (file->event_call != call)
> >  			continue;
> >  		ftrace_event_enable_disable(file, 0);
> > +		destroy_preds(file);
> >  		/*
> >  		 * The do_for_each_event_file() is
> >  		 * a double loop. After finding the call for this
> > @@ -1700,7 +1701,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
> >  {
> >  	event_remove(call);
> >  	trace_destroy_fields(call);
> > -	destroy_preds(call);
> > +	destroy_call_preds(call);
> 
> A small nit, but I don't believe we need this anymore.
> 
> First, what event that requires a call filter can be removed?
> 
> Second, if one could be removed, the previous call to "event_remove"
> would remove the filter for us, as destroy_preds(file) calls
> destroy_call_preds() if the USE_CALL_FILTER flag is set.
> 
> I'll keep it in for now, but may remove it later.
> 

Good catch.  Yeah, that destroy_call_preds() call is redundant - feel
free to remove it, or I can..

Thanks,

Tom

> -- Steve
> 
> 
> >  }
> >  
> 


