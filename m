Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaGQNJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:09:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:42187 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbaGQNJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:09:49 -0400
Date: Thu, 17 Jul 2014 10:09:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] perf stat: Pass PERF_STAT_RUN environment variable for
 each run
Message-ID: <20140717130943.GA4312@kernel.org>
References: <1405585266-28268-1-git-send-email-namhyung@kernel.org>
 <20140717082613.GF19379@twins.programming.kicks-ass.net>
 <CAM9d7ciELhfJwdNBSJPCJcrVr43+hs+80m-FK7bE1mkuBcv0yQ@mail.gmail.com>
 <20140717084011.GG19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717084011.GG19379@twins.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 17, 2014 at 10:40:11AM +0200, Peter Zijlstra escreveu:
> On Thu, Jul 17, 2014 at 05:31:14PM +0900, Namhyung Kim wrote:
> > On Thu, Jul 17, 2014 at 5:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Thu, Jul 17, 2014 at 05:21:06PM +0900, Namhyung Kim wrote:
> > >> When perf stat runs multiple times via -r option, it's sometimes
> > >> useful for a workload to know which run it executing.  So pass new
> > >> PERF_STAT_RUN environment variable to the workload for each run
> > >> (starting from 1).

> > > This seems counter intuitive, runs should be _identical_ otherwise
> > > there's no point. That means the workload should very much _not_ know
> > > these things.

> > But I think it can be useful if a workload wants to save logfiles
> > based on the iteration number for example.  If it doesn't want, it can
> > just ignore. :)

> That's the wrong way around. Also, there's --pre and --post hooks to
> preserve logfiles if you really have to do that kind of thing.

Agreed, one can script this using --pre or --post if needed.

- Arnaldo
