Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaLWEFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:05:55 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46167 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLWEFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:05:54 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 23 Dec 2014 13:06:33 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 7/7] perf tools: Set attr.task bit for a tracking event
Message-ID: <20141223040633.GB14960@sejong>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-8-git-send-email-namhyung@kernel.org>
 <20141222144919.GA7644@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141222144919.GA7644@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:49:19AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 22, 2014 at 01:44:15PM +0900, Namhyung Kim escreveu:
> > The perf_event_attr.task bit is to track task (fork and exit) events
> > but it missed to be set by perf_evsel__config().  While it was not a
> > problem in practice since setting other bits (comm/mmap) ended up
> > being in same result, it'd be good to set it explicitly anyway.
> 
> I didn't understand, so this isn't strictly needed? I.e. what is the
> point of the attr->task bit then?

Yes, it's not strictly needed for this case.  The attr->task is to
track task related events (fork/exit) only but other meta events like
comm and mmap[2] also needs the task events.  So setting attr->comm
and/or attr->mmap causes the kernel emits the task events anyway.  So
the attr->task is only meaningful when other bits are off but I'd like
to set it for completeness.

Thanks,
Namhyung
