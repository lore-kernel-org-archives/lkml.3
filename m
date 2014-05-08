Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaEHIX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:23:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:42346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaEHIXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:23:55 -0400
Date: Thu, 8 May 2014 10:23:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v5 1/2] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140508082350.GG2844@laptop.programming.kicks-ass.net>
References: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:59:53PM +0900, Namhyung Kim wrote:
> Currently perf record doesn't propagate the exit status of a workload
> given by the command line.  But sometimes it'd useful if it's
> propagated so that a monitoring script can handle errors
> appropriately.
> 
> To do that, it got rid of exit handlers and run/call them directly in
> the __cmd_record().  I don't see any reason why those are in a form of
> exit handlers in the first place.  Also it cleaned up the resource
> management code in record__exit().
> 
> With this change, perf record returns the child exit status in case of
> normal termination and send signal to itself when terminated by signal.
> 
> Example run of Stephane's case:
> 
>   $ perf record true && echo yes || echo no
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
>   yes
> 
>   $ perf record false && echo yes || echo no
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
>   no
> 
> Jiri's case (error in parent):
> 
>   $ perf record -m 10G true && echo yes || echo no
>   rounding mmap pages size to 17179869184 bytes (4194304 pages)
>   failed to mmap with 12 (Cannot allocate memory)
>   no
> 
> And Peter's case (interrupted by signal):
> 
>   $ while :; do perf record sleep 1; done
>   ^C[ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.014 MB perf.data (~593 samples) ]

Thanks!

Acked-by: Peter Zijlstra <peterz@infradead.org>
