Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbaGNTZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:25:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128AbaGNTZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:25:31 -0400
Date: Mon, 14 Jul 2014 21:23:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] tracing: change filter_free_subsystem_*() to check
	->subsystem rather then ->name
Message-ID: <20140714192353.GA20882@redhat.com>
References: <20140711190622.GA19499@redhat.com> <20140711190655.GA19549@redhat.com> <20140714152029.21bd22f6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714152029.21bd22f6@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Steven Rostedt wrote:
>
> On Fri, 11 Jul 2014 21:06:55 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > @@ -846,13 +846,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
> >  					struct trace_array *tr)
> >  {
> >  	struct ftrace_event_file *file;
> > -	struct ftrace_event_call *call;
> >  
> >  	list_for_each_entry(file, &tr->events, list) {
> > -		call = file->event_call;
> > -		if (strcmp(call->class->system, system->name) != 0)
> > +		if (file->system->subsystem != system)
> 
> This is only used on one place. What about just passing in dir instead
> of system and then do:

I swear, I too thought about this ;) OK, in v2.

Oleg.

