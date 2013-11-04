Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3KDSCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:02:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3KDSC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:02:28 -0500
Date: Mon, 4 Nov 2013 15:56:13 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tools: Check maximum frequency rate for
 record/top
Message-ID: <20131104175613.GA20505@infradead.org>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
 <1383563173-17466-4-git-send-email-jolsa@redhat.com>
 <5277BA84.1090208@gmail.com>
 <20131104153216.GC2805@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104153216.GC2805@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 04, 2013 at 04:32:16PM +0100, Jiri Olsa escreveu:
> On Mon, Nov 04, 2013 at 08:17:24AM -0700, David Ahern wrote:
> > On 11/4/13, 4:06 AM, Jiri Olsa wrote:
> > >Adding the check for maximum allowed frequency rate
> > >defined in following file:
> > >   /proc/sys/kernel/perf_event_max_sample_rate
> > >
> > >When we cross the maximum value we fail and display
> > >detailed error message with advise.
> > 
> > perf commands should automatically adjust the default frequency too.
> > If the user did not specify a frequency then this message is going
> > to be confusing.
> 
> ok, I'll add that check and probably some warning
> if we are force to go below the default rate.

I think we should just make it clear the frequency used and pick the
best according to the hardware.

And we are not doing gthat at all, at least in the TUI, need to change
that.

Only in the stdio, with that long list of commented lines, that should
as well be hidden, too verbose.

And here we also see the frequency used:

[root@zoo linux]# perf evlist -v
cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|PERIOD,
disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, enable_on_exec: 1,
sample_id_all: 1, exclude_guest: 1
[root@zoo linux]#
 
 > 
> > Though the algorithm that keeps lowering the rate should be tweaked as well.
> 
> yea.. I was thinking putting the max rate back up after
> some sane period
> 
> or/plus having 'echo 0 > /proc/sys/kernel/perf_event_max_sample_rate' to
> disable it completely
> 
> jirka
