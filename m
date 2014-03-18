Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaCRNP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:15:26 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:54418 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaCRNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:15:25 -0400
Date: Tue, 18 Mar 2014 10:15:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/9] perf tools: Count periods of filtered entries
 separately
Message-ID: <20140318131518.GM31482@ghostprotocols.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-3-git-send-email-namhyung@kernel.org>
 <20140317200832.GE31482@ghostprotocols.net>
 <CAM9d7ch0xHO4S6drn_G2CELTD6G51ADE+XvvSJw5Jid2Dy7Khw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7ch0xHO4S6drn_G2CELTD6G51ADE+XvvSJw5Jid2Dy7Khw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 18, 2014 at 01:19:07PM +0900, Namhyung Kim escreveu:
> On Tue, Mar 18, 2014 at 5:08 AM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Mon, Mar 10, 2014 at 04:43:53PM +0900, Namhyung Kim escreveu:
> >> @@ -749,9 +750,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
> >>       if (thread == NULL)
> >>               return -1;
> >>
> >> -     if (thread__is_filtered(thread))
> >> -             goto out_filtered;
> >> -
> >
> > What was the intent of moving this test from here...
> >
> >>       dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
> >>       /*
> >>        * Have we already created the kernel maps for this machine?
> >> @@ -766,6 +764,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
> >>
> >>       thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
> >>                             sample->ip, al);
> >> +
> >> +     if (thread__is_filtered(thread))
> >> +             al->filtered |= (1 << HIST_FILTER__THREAD);
> >> +
> >
> > ... to here? At first I thought it was because thread__is_filtered()
> > would check something that thread__find_addr_map() was doing, but no,
> > its invariant, we can do it here or at the original site, so I'm keeping
> > it there, ok?
> 
> It's because thread__find_addr_map() clears al->filtered, so filtering
> with -d option won't work.  Maybe we can move initialization of the
> al->filtered upto this function.

So this is a separate patch with this explanation, I'll add it to the
series, thanks for the explanation!

- Arnaldo
