Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3F0IvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:51:07 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:57118 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3F0IvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:51:00 -0400
Date: Thu, 27 Jun 2013 10:50:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Namhyung Kim <namhyung@kernel.org>, Robert Richter <rric@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130627085056.GB3730@gmail.com>
References: <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
 <20130626082408.GA20274@pd.tnic>
 <20130626101132.GC21788@rric.localhost>
 <20130626114538.GA4117@gmail.com>
 <20130626124424.GD21788@rric.localhost>
 <8761x014xv.fsf@sejong.aot.lge.com>
 <20130627083522.GA21224@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627083522.GA21224@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> > > A problem here is that mmap'ed buffer size (number of pages) must be 
> > > be equal to the pre-existing buffer size and thus to be known 
> > > somehow.
> > 
> > What about also exporting the buffer size via sysfs pmu directory?
> 
> Yes, we've been discussing buffer size. The simplest thing is to 
> hardcode the buffer size so that it is implicitly known to all agents. 
> However, I don't know whether there is a use case where different buffer 
> sizes actually make sense. I'd tend to do the simplest thing initially.

Btw., in terms of testing and design focus I'd suggest concentrating not 
on rare and relatively singular events like RAS MCE events, but on a more 
'everyday tracing' flow of events:

 - large, per cpu trace buffers

 - all events output into a single trace buffer to get a coherent trace

 - [ possibly revive the tracepoint-multiplexing patch from peterz/tglx,
     to be able to get a rich selection of tracepoints. ]

That is I think the workflow most people will be interested in:

 - they have a workload to analyze and they want to do some 'tracing' to 
   understand it better or to pinpoint a problem.

 - based on the problem they want to trace a selection of tracepoints, as 
   easily and quickly as possible.

 - we could possibly provide a few 'groups' of tracepoints for typical
   uses - for example scheduler tracing, or MM tracing, or IO tracing,
   etc.), so people wouldn't have to specify a dozen tracepoints but could
   symbolically refer to any of these pre-cooked groups. [this is probably
   a tooling detail.]

 - they want to persistently trace into a generously sized trace buffer,
   without any tool running while the collection period lasts.

 - to refine the result they'd like to stop/start tracing, reset/clear the
   tracebuffer for failed attempts, and generally see how large the
   tracebuffer is.

 - and extract/analyze traces - both in a detailed form and in summary
   fashion.

 - they possibly want to save it to a perf.data and have equivalent
   facilities of analysis.

If that workflow works well then the RAS angle will work well too.

Thanks,

	Ingo
