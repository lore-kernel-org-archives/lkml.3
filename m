Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3H0X3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:29:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:8394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3H0X3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,971,1367996400"; 
   d="scan'208";a="394405294"
Message-ID: <1377646146.15688.52.camel@empanada>
Subject: Re: [PATCH v7 01/10] tracing: Add support for SOFT_DISABLE to
 syscall events
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 27 Aug 2013 18:29:06 -0500
In-Reply-To: <20130827160150.36f10869@gandalf.local.home>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	 <a21a85892674dedf8ded3b2f0e83bd8106f5c22f.1377631572.git.tom.zanussi@linux.intel.com>
	 <20130827160150.36f10869@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 16:01 -0400, Steven Rostedt wrote:
> On Tue, 27 Aug 2013 14:40:13 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
>   		return;
> > -	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
> > +
> > +	/* Here we're inside the tp handler's rcu_read_lock (__DO_TRACE()) */
> > +	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);
> 
> What's the reason for using rcu_dereference_raw() and not normal
> rcu_dereference?
> 

This is because we know the tracepoint handler has rcu_read_lock_held()
and so we don't need to do the rcu_dereference_check().

Tom

> -- Steve
> 
> > +	if (!ftrace_file)
> > +		return;
> > +
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> >  		return;
> >  


