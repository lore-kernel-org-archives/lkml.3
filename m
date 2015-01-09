Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbbAIPot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:44:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbbAIPo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:44:29 -0500
Date: Fri, 9 Jan 2015 16:44:21 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf probe can't insert return kprobe
Message-ID: <20150109154421.GA7849@krava.brq.redhat.com>
References: <20150109145539.GC14750@krava.brq.redhat.com>
 <20150109152113.GA29697@danjae>
 <20150109153056.GB4136@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109153056.GB4136@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 04:30:56PM +0100, Jiri Olsa wrote:
> On Sat, Jan 10, 2015 at 12:21:13AM +0900, Namhyung Kim wrote:
> > On Fri, Jan 09, 2015 at 03:55:39PM +0100, Jiri Olsa wrote:
> > > hi,
> > > I couldn't use following perf command to insert return probe:
> > > 
> > >   # perf probe -a fork_exit=do_fork%return
> > >   Added new event:
> > >   Failed to write event: Invalid argument
> > >     Error: Failed to add events.
> > > 
> > > 
> > > I'm pretty sure I used this command before, so seems like
> > > it's broken. I can still use debugfs tracing interface to
> > > do that:
> > >   # echo 'r:do_fork_entry do_fork' > kprobe_events
> > > 
> > > I used Arnaldo's latest perf/core and FC20 kernel:
> > > 
> > >   # uname -a
> > >   Linux krava 3.17.7-200.fc20.x86_64 #1 SMP Wed Dec 17 03:35:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> > >   # ./perf version
> > >   perf version 3.18.g6a7d78
> > > 
> > 
> > Is it just return probe?  Did it work for normal kprobes?
> 
> yep, works for normal probes
> 
> > Maybe it's related to the below:
> > 
> > https://lkml.org/lkml/2014/12/31/15
> > 
> > Have you check the acme/perf/urgent too?
> 
> hum.. can't access lkml, I'll check, also with perf/urgent

neither helped..

jirka
