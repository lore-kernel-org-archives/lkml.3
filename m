Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbbAIXRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:17:18 -0500
Received: from mail.kernel.org ([198.145.29.136]:49979 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758265AbbAIXRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:17:16 -0500
Date: Fri, 9 Jan 2015 20:17:10 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: perf: PERF_FLAG_FD_OUTPUT has been broken since 2.6.35
Message-ID: <20150109231710.GC12406@kernel.org>
References: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu>
 <20150109160051.GK29390@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1501091123040.27178@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501091123040.27178@vincent-weaver-1.umelst.maine.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 09, 2015 at 11:26:54AM -0500, Vince Weaver escreveu:
> 
> On Fri, 9 Jan 2015, Peter Zijlstra wrote:
> > > So is this worth fixing seeing as apparently no one uses this feature?
> > 
> > I think there's a fair argument for removing it, Ingo, Acme?
> 
> could the functionality be replaced with a subsequent call to
> 	ioctl(PERF_EVENT_IOC_SET_OUTPUT)
> ?

That is the only thing tools/perf uses:

[acme@zoo linux]$ find tools/perf -name "*.[chly]" | xargs grep PERF_EVENT_IOC_SET_OUTPUT 
tools/perf/util/evlist.h: * @refcnt - e.g. code using PERF_EVENT_IOC_SET_OUTPUT to share this
tools/perf/util/evlist.c:			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
tools/perf/tests/perf-record.c:	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
[acme@zoo linux]$ find tools/perf -name "*.[chly]" | xargs grep PERF_FLAG_FD_OUTPUT
[acme@zoo linux]$
 
> Although I suppose there's a possibility for losing a small amount of data 
> or some other reason that PERF_FLAG_FD_OUTPUT was introduced in the first 
> place.

Humm, IIRC tools/perf starts with the event disabled and then asks for
enable_on_exec when starting workloads but yes, when you're attaching to
something that is already running you'd take a bit longer to start getting
samples.
 
> In addition, if we remove PERF_FLAG_FD_OUTPUT would there then be any 
> reason to keep PERF_FLAG_FD_NO_GROUP around?
> 
> Vince
