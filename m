Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaBKLbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:31:38 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:51707 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaBKLbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:31:35 -0500
Date: Tue, 11 Feb 2014 08:31:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 01/21] perf c2c: Shared data analyser
Message-ID: <20140211113127.GA28757@ghostprotocols.net>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392059886-30812-1-git-send-email-dzickus@redhat.com>
 <1392070204.25316.1.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392070204.25316.1.camel@buesod1.americas.hpqcorp.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 10, 2014 at 02:10:04PM -0800, Davidlohr Bueso escreveu:
> On Mon, 2014-02-10 at 14:18 -0500, Don Zickus wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > This is the start of a new perf tool that will collect information about
> > memory accesses and analyse it to find things like hot cachelines, etc.
> > 
> > This is basically trying to get a prototype written by Richard Fowles
> > written using the tools/perf coding style and libraries.
> > 
> > Start it from 'perf sched', this patch starts the process by adding the
> > 'record' subcommand to collect the needed mem loads and stores samples.
> > 
> > It also have the basic 'report' skeleton, resolving the sample address
> > and hooking the events found in a perf.data file with methods to handle
> > them, right now just printing the resolved perf_sample data structure
> > after each event name.
> 
> What tree/branch is this developed against? I'm getting the following
> with Linus' latest and tip tree:

I'll try refreshing it on top of my perf/core branch today
 
> builtin-c2c.c: In function ‘perf_c2c__process_sample’:
> builtin-c2c.c:68:20: error: request for member ‘func’ in something not a structure or union
> builtin-c2c.c:69:36: error: request for member ‘func’ in something not a structure or union
> builtin-c2c.c: In function ‘perf_c2c__read_events’:
> builtin-c2c.c:81:2: error: passing argument 1 of ‘perf_session__new’ from incompatible pointer type [-Werror]
> In file included from builtin-c2c.c:6:0:
> util/session.h:52:22: note: expected ‘struct perf_data_file *’ but argument is of type ‘const char *’
> builtin-c2c.c:81:2: error: too many arguments to function ‘perf_session__new’
> In file included from builtin-c2c.c:6:0:
> util/session.h:52:22: note: declared here
> 
