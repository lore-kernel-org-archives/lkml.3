Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab3DYPqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557Ab3DYPqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:46:54 -0400
Date: Thu, 25 Apr 2013 16:49:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
Message-ID: <20130425144955.GC1033@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-6-git-send-email-namhyung@kernel.org>
 <20130424140918.GF971@krava.brq.redhat.com>
 <87fvyf9maa.fsf@sejong.aot.lge.com>
 <20130425090956.GA1033@krava.brq.redhat.com>
 <87r4hz7xal.fsf@sejong.aot.lge.com>
 <1366895121.10248.12.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366895121.10248.12.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:05:21AM -0400, Steven Rostedt wrote:
> On Thu, 2013-04-25 at 18:51 +0900, Namhyung Kim wrote:
> > >
> > >> 
> > >> Do you mean it should be changed to
> > >> 
> > >> 	if (write_tracing_file("set_ftrace_pid", "-1") < 0)
> > >> 
> > >> ?  It seems it's the right thing to do for compatibility.
> > >
> > >
> > > looks like it's enough only to open it with O_TRUNC,
> > > so I guess whatever minimal goes write_tracing_file
> 
> Correct.
> 
> > 
> > Yeah, but I can see below from trace-cmd code.
> > 
> > trace-cmd/trace-record.c:
> > 
> > 	/*
> > 	 * Older kernels required "-1" to disable pid
> > 	 */
> > 	if (ret < 0 && !strlen(pid))
> > 		ret = write(fd, "-1", 2);
> > 
> > 
> > Could you clarify this, Steve?
> 
> As the comment states, older kernels (before 2.6.33) required a -1. As
> trace-cmd is set up to work with at least 2.6.32, it requires the "-1"
> write. It doesn't hurt to have it.
> 
> But for perf ftrace (or whatever), I don't think we need the requirement
> to work with 2.6.32 kernels. Perf was added in 2.6.31, but do all
> functionalities still work that far back?

perf maintains backward compatibility, but not sure how far
back it goes.. but as long as it's just writing -1 in here
let's do that

jirka
