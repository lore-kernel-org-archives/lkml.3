Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3BYWED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:04:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab3BYWD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:03:59 -0500
Date: Mon, 25 Feb 2013 20:38:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/5] perf tools: Fix -C option for record command
Message-ID: <20130225193851.GD17149@krava.brq.redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
 <1361785972-7431-2-git-send-email-jolsa@redhat.com>
 <20130225183932.GA7352@redhat.com>
 <512BB3E6.6000904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512BB3E6.6000904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:56:38AM -0700, David Ahern wrote:
> On 2/25/13 11:39 AM, Oleg Nesterov wrote:
> >To clarify, I am not trying to review this patch, I'd like to ask
> >the question...
> >
> >On 02/25, Jiri Olsa wrote:
> >>
> >>Currently the -C option does not work for record command,
> >>because of the targets mismatch when synthesizing threads.
> >>
> >>Fixing this by using proper target interface for the
> >>synthesize decision.
> >
> >OK, but my fix had the different goal. I thought that
> >
> >	$ perf ... record -C0 sleep 1
> >
> >should attach the counter to the child process (workload) and set
> >event->cpu = 0 (instead of -1). With this patch we create the cpu
> 
> If a target is given (-a, -C, -p or -t) that is what the data is
> collected for -- all cpus, a cpu, or one or more task ids. The
> workload in that case becomes a means for bounding the data
> collection (start and end points).
> 
> If you want to collect events for a workload you just run
> perf-record -- workload.
> 
> Last time I dug into it (which was 8-12 months ago) -C required -a
> to work properly. -a (system_wide) meaning collect events for all
> cpus and then -C meaning but only for this cpu. Perhaps Namyhung's
> target changes may have simplified fixing that as Jiri's patch
> suggests.

yes, that's what actually this patch fixies.. now you can run:

  perf record -C 0 ls

and that will attach to cpu 0 only (same as '-a -C 0' before)


maybe we could consider having:

  perf record -C 0 ls
    - attaching to CPU 0 and ls workload pid

  perf record -a -C 0 ls
    - attaching to CPU 0 globaly

jirka
