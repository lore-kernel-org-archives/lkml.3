Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3KLLei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:34:38 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:57029 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3KLLee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:34:34 -0500
Date: Tue, 12 Nov 2013 08:34:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf machine: Introduce synthesize_threads method
 out of open coded equivalent
Message-ID: <20131112113427.GA4053@ghostprotocols.net>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
 <1384201353-23863-5-git-send-email-acme@infradead.org>
 <528140DB.90301@gmail.com>
 <20131111205045.GE18886@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111205045.GE18886@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 11, 2013 at 09:50:45PM +0100, Ingo Molnar escreveu:
> * David Ahern <dsahern@gmail.com> wrote:

> > On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:
> > >+	if (perf_target__has_task(target))
> > >+		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
> > >+	else if (perf_target__has_cpu(target))
> > >+		return perf_event__synthesize_threads(tool, process, machine, data_mmap);

> > Getting kind of long on the line lengths...

> Maybe we could start losing most of the perf_ prefixes - it's all about 
> perf here, so it does not really add much information, does it?

In some cases that is ok, that is why I didn't call it 'perf_machine',
just 'machine', in others, like 'perf_event', I thought 'event' would be
too general when somebody tries to use this code together with other
libraries.

In some cases, like 'perf_target', probably its ok to move to
'target', perhaps this is ok for this problem domain, i.e.
monitoring/profiling/etc.
 
> that would turn it into:
> 
> 	if (target__has_task(target))
> 		return event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
> 	else if (target__has_cpu(target))
> 		return event__synthesize_threads(tool, process, machine, data_mmap);
> 
> Another trick would be to combine (tool, machine) into a single helper 
> struct (struct context *ctx?), if that is mostly a constant combination 
> describing tool environment, which gets passed deep inside the guts of 
> functions.


Reducing the function signature is something that may help as well, and
was done in this series with machine__synthesize_threads, that avoids
passing the tool and process arguments, since they were constanty
anyway.

What you propose is used in some cases, like with symbol_conf, will try
to work in that direction as time goes by, i.e. doing some refactoring
work of this kind every once in a while, not to disrupt too much the
patch flow.
 
- Arnaldo
