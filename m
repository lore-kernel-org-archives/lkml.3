Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbbAYT0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:26:50 -0500
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:33430 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754726AbbAYT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:26:47 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3871:3872:4321:4605:5007:6119:6261:7875:9040:9121:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12555:12663:12740:13069:13180:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stew08_de27063875c
X-Filterd-Recvd-Size: 2383
Date: Sun, 25 Jan 2015 14:26:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] tools lib api fs: Add tracefs mount helper
 functions
Message-ID: <20150125142645.3c5156e7@gandalf.local.home>
In-Reply-To: <20150125165619.GF31987@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
	<20150124181448.680347393@goodmis.org>
	<20150125165619.GF31987@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 17:56:19 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Sat, Jan 24, 2015 at 01:13:32PM -0500, Steven Rostedt wrote:
> 
> SNIP
> 
> > @@ -0,0 +1,29 @@
> > +#ifndef __API_TRACEFS_H__
> > +#define __API_TRACEFS_H__
> > +
> > +#define _STR(x) #x
> > +#define STR(x) _STR(x)
> > +
> > +/*
> > + * On most systems <limits.h> would have given us this, but  not on some systems
> > + * (e.g. GNU/Hurd).
> > + */
> > +#ifndef PATH_MAX
> > +#define PATH_MAX 4096
> > +#endif
> > +
> > +#ifndef TRACEFS_MAGIC
> > +#define TRACEFS_MAGIC          0x74726163
> > +#endif
> 
> I missed the point when tracefs became actual standalone
> filesystem.. I'll check ;-)
> 
> Is it mutualy exclusive to 'debugfs/tracing' or those 2 can live together?
> 

I'm working on the patches right now. But when it happens perf should
be aware of it. I already updated trace-cmd to be aware.

When tracefs is added, debugfs/tracing will automatically mount tracefs
when debugfs is mounted. As debugfs currently has some issues with
automounting, this part is being discussed currently as well.

Note, WTF is perf checking the magic number for debugfs?? If events
move, even if its at the same path, this will break perf!

-- Steve
