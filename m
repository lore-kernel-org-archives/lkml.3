Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbbAZJDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:03:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbAZJDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:03:04 -0500
Date: Mon, 26 Jan 2015 10:02:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] tools lib api fs: Add tracefs mount helper functions
Message-ID: <20150126090255.GC13287@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
 <20150124181448.680347393@goodmis.org>
 <20150125165619.GF31987@krava.brq.redhat.com>
 <20150125142645.3c5156e7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125142645.3c5156e7@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 02:26:45PM -0500, Steven Rostedt wrote:
> On Sun, 25 Jan 2015 17:56:19 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Sat, Jan 24, 2015 at 01:13:32PM -0500, Steven Rostedt wrote:
> > 
> > SNIP
> > 
> > > @@ -0,0 +1,29 @@
> > > +#ifndef __API_TRACEFS_H__
> > > +#define __API_TRACEFS_H__
> > > +
> > > +#define _STR(x) #x
> > > +#define STR(x) _STR(x)
> > > +
> > > +/*
> > > + * On most systems <limits.h> would have given us this, but  not on some systems
> > > + * (e.g. GNU/Hurd).
> > > + */
> > > +#ifndef PATH_MAX
> > > +#define PATH_MAX 4096
> > > +#endif
> > > +
> > > +#ifndef TRACEFS_MAGIC
> > > +#define TRACEFS_MAGIC          0x74726163
> > > +#endif
> > 
> > I missed the point when tracefs became actual standalone
> > filesystem.. I'll check ;-)
> > 
> > Is it mutualy exclusive to 'debugfs/tracing' or those 2 can live together?
> > 
> 
> I'm working on the patches right now. But when it happens perf should
> be aware of it. I already updated trace-cmd to be aware.
> 
> When tracefs is added, debugfs/tracing will automatically mount tracefs
> when debugfs is mounted. As debugfs currently has some issues with
> automounting, this part is being discussed currently as well.
> 
> Note, WTF is perf checking the magic number for debugfs?? If events
> move, even if its at the same path, this will break perf!

good question.. it's there since 2009:
  f6bdafef2ab9 perf_counter: Add tracepoint support to perf list, perf stat

I guess we didn't want anyone to trick us with fake tracepoints ;-)

jirka
