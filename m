Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3EIPLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:11:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3EIPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:11:48 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=OF0BmyLs-1YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Kfn0_i_Y4z8A:10 a=3YkXT2T8WZjI8ahjQ6oA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368112306.7373.106.camel@gandalf.local.home>
Subject: Re: [PATCH 01/11] [BUGFIX] tracing: Return 0 if event_enable_func
 succeeded
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 11:11:46 -0400
In-Reply-To: <1368109905.7373.99.camel@gandalf.local.home>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054413.30398.55650.stgit@mhiramat-M0-7522>
	 <1368109905.7373.99.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 10:31 -0400, Steven Rostedt wrote:

> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 53582e9..44ac836 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -2061,8 +2061,11 @@ event_enable_func(struct ftrace_hash *hash,
> >  	if (ret < 0)
> >  		goto out_put;
> >  	ret = register_ftrace_function_probe(glob, ops, data);
> > -	if (!ret)
> > +	if (!ret) {
> > +		ret = -ENOENT;
> >  		goto out_disable;
> > +	} else
> > +		ret = 0;
> 
> I think you meant:
> 
> 	if (ret < 0)
> 		goto out_disable;
> 	ret = 0;
> 
> Otherwise, I don't see how you fixed anything, as you still return error
> if ret is something other than zero.
> 
> Or am I missing something?

Yeah, this needs a comment.  register_ftrace_function_probe() returns
the number of functions enabled, but if that is zero (or less), then it
should fail. We still need to check for less than ret.

I'll fix this one up.

Thanks!

-- Steve


