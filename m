Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaBJWKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:10:10 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:22154 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBJWKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:10:07 -0500
Message-ID: <1392070204.25316.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 01/21] perf c2c: Shared data analyser
From: Davidlohr Bueso <davidlohr@hp.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Date: Mon, 10 Feb 2014 14:10:04 -0800
In-Reply-To: <1392059886-30812-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
	 <1392059886-30812-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 14:18 -0500, Don Zickus wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> This is the start of a new perf tool that will collect information about
> memory accesses and analyse it to find things like hot cachelines, etc.
> 
> This is basically trying to get a prototype written by Richard Fowles
> written using the tools/perf coding style and libraries.
> 
> Start it from 'perf sched', this patch starts the process by adding the
> 'record' subcommand to collect the needed mem loads and stores samples.
> 
> It also have the basic 'report' skeleton, resolving the sample address
> and hooking the events found in a perf.data file with methods to handle
> them, right now just printing the resolved perf_sample data structure
> after each event name.

What tree/branch is this developed against? I'm getting the following
with Linus' latest and tip tree:

builtin-c2c.c: In function ‘perf_c2c__process_sample’:
builtin-c2c.c:68:20: error: request for member ‘func’ in something not a structure or union
builtin-c2c.c:69:36: error: request for member ‘func’ in something not a structure or union
builtin-c2c.c: In function ‘perf_c2c__read_events’:
builtin-c2c.c:81:2: error: passing argument 1 of ‘perf_session__new’ from incompatible pointer type [-Werror]
In file included from builtin-c2c.c:6:0:
util/session.h:52:22: note: expected ‘struct perf_data_file *’ but argument is of type ‘const char *’
builtin-c2c.c:81:2: error: too many arguments to function ‘perf_session__new’
In file included from builtin-c2c.c:6:0:
util/session.h:52:22: note: declared here


