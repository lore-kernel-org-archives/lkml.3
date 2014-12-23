Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaLWN2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:28:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:35043 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaLWN2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:28:51 -0500
Date: Tue, 23 Dec 2014 10:28:47 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 7/7] perf tools: Set attr.task bit for a tracking event
Message-ID: <20141223132847.GN7644@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-8-git-send-email-namhyung@kernel.org>
 <20141222144919.GA7644@kernel.org>
 <20141223040633.GB14960@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223040633.GB14960@sejong>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 23, 2014 at 01:06:33PM +0900, Namhyung Kim escreveu:
> On Mon, Dec 22, 2014 at 11:49:19AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Dec 22, 2014 at 01:44:15PM +0900, Namhyung Kim escreveu:
> > > The perf_event_attr.task bit is to track task (fork and exit) events
> > > but it missed to be set by perf_evsel__config().  While it was not a
> > > problem in practice since setting other bits (comm/mmap) ended up
> > > being in same result, it'd be good to set it explicitly anyway.
> > 
> > I didn't understand, so this isn't strictly needed? I.e. what is the
> > point of the attr->task bit then?
> 
> Yes, it's not strictly needed for this case.  The attr->task is to
> track task related events (fork/exit) only but other meta events like
> comm and mmap[2] also needs the task events.  So setting attr->comm
> and/or attr->mmap causes the kernel emits the task events anyway.  So
> the attr->task is only meaningful when other bits are off but I'd like
> to set it for completeness.

Ok, I will update the changelog comment with this information.

- Arnaldo
