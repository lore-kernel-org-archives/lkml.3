Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3KLMou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:44:50 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:65228 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3KLMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:44:46 -0500
Date: Tue, 12 Nov 2013 13:44:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf machine: Introduce synthesize_threads method
 out of open coded equivalent
Message-ID: <20131112124442.GB13057@gmail.com>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
 <1384201353-23863-5-git-send-email-acme@infradead.org>
 <528140DB.90301@gmail.com>
 <20131111205045.GE18886@gmail.com>
 <20131112113427.GA4053@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112113427.GA4053@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Nov 11, 2013 at 09:50:45PM +0100, Ingo Molnar escreveu:
> > * David Ahern <dsahern@gmail.com> wrote:
> 
> > > On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:
> > > >+	if (perf_target__has_task(target))
> > > >+		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
> > > >+	else if (perf_target__has_cpu(target))
> > > >+		return perf_event__synthesize_threads(tool, process, machine, data_mmap);
> 
> > > Getting kind of long on the line lengths...
> 
> > Maybe we could start losing most of the perf_ prefixes - it's all about 
> > perf here, so it does not really add much information, does it?
> 
> In some cases that is ok, that is why I didn't call it 'perf_machine', 
> just 'machine', in others, like 'perf_event', I thought 'event' would be 
> too general when somebody tries to use this code together with other 
> libraries.

I think 'event' as a variable name is generally unused by libraries, 
exactly because so much random code uses it.

The only unfortunate C library land grabs I've run into are 'time' [by 
glibc] and 'y0' [by libm].

What I was suggesting here was more like an event__*() namespace - there 
shouldn't be any collision with public functions from libraries, public 
functions are generally either well established, or prefixed with a 
library name.

These are perf-internal function names, so using event__*() should be fine 
- assuming there are no counter arguments.

Thanks,

	Ingo
