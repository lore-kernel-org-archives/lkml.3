Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaEHImy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:42:54 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62381 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaEHImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:42:52 -0400
Date: Thu, 8 May 2014 10:42:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v5 1/2] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140508084246.GA1659@gmail.com>
References: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
 <20140508082350.GG2844@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508082350.GG2844@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, May 08, 2014 at 04:59:53PM +0900, Namhyung Kim wrote:
> > Currently perf record doesn't propagate the exit status of a workload
> > given by the command line.  But sometimes it'd useful if it's
> > propagated so that a monitoring script can handle errors
> > appropriately.
> > 
> > To do that, it got rid of exit handlers and run/call them directly in
> > the __cmd_record().  I don't see any reason why those are in a form of
> > exit handlers in the first place.  Also it cleaned up the resource
> > management code in record__exit().
> > 
> > With this change, perf record returns the child exit status in case of
> > normal termination and send signal to itself when terminated by signal.
> > 
> > Example run of Stephane's case:
> > 
> >   $ perf record true && echo yes || echo no
> >   [ perf record: Woken up 1 times to write data ]
> >   [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
> >   yes
> > 
> >   $ perf record false && echo yes || echo no
> >   [ perf record: Woken up 1 times to write data ]
> >   [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
> >   no
> > 
> > Jiri's case (error in parent):
> > 
> >   $ perf record -m 10G true && echo yes || echo no
> >   rounding mmap pages size to 17179869184 bytes (4194304 pages)
> >   failed to mmap with 12 (Cannot allocate memory)
> >   no
> > 
> > And Peter's case (interrupted by signal):
> > 
> >   $ while :; do perf record sleep 1; done
> >   ^C[ perf record: Woken up 1 times to write data ]
> >   [ perf record: Captured and wrote 0.014 MB perf.data (~593 samples) ]
> 
> Thanks!
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Very nice!

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
