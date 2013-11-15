Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3KOL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:56:40 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55136 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3KOL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:56:33 -0500
Date: Fri, 15 Nov 2013 12:56:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
Message-ID: <20131115115629.GB19004@gmail.com>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
 <1384460715-23198-11-git-send-email-acme@infradead.org>
 <20131115060643.GA9237@gmail.com>
 <5285FECE.7020802@intel.com>
 <20131115111032.GA18647@gmail.com>
 <52860529.50200@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52860529.50200@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> On 15/11/13 13:10, Ingo Molnar wrote:
> > 
> > * Adrian Hunter <adrian.hunter@intel.com> wrote:
> > 
> >>> And I also raised why this shouldn't be the default event tracing 
> >>> method instead of a weird config option. Per-cpu tracing is cache 
> >>> compact, it is easier to size properly and in general it is pretty 
> >>> easy to think about. (It also has less of the TSC timestamp 
> >>> ordering problems as per thread tracing, at least in theory.)
> >>>
> >>> Is there something that makes per cpu tracing undesirable as the 
> >>> default?
> >>
> >> One reason is to avoid changing the meaning of existing options.
> > 
> > Well, the way the tracing buffers are set up is a mostly tool internal 
> > matter so in that sense it should be just fine to change the default 
> > behavior - as long as output remains unchanged (which it should).
> > 
> > Or is there any material change in behavior somewhere?
> 
> Inheritance is enabled automatically with per-cpu mmaps,
> although that is one of the reasons people want
> per-cpu mmaps.

So, here's the current status quo, there's 4 basic types of profiling 
that 99% of the people are using, in order of popularity:

	perf record <cmd>
	perf record -a sleep N
	perf record -p <PID>
	perf record -t <TID>

The first two (which I'd guess comprise about 95% of real-world usage) 
have inheritance enabled.

The last two (-p/-t) have inheritance disabled by default.

Correct?

Thanks,

	Ingo
