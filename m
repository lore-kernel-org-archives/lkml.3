Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaBFOHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:07:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaBFOHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:07:17 -0500
Date: Thu, 6 Feb 2014 12:07:05 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
Message-ID: <20140206140705.GB26955@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
 <20140206135627.GA26955@infradead.org>
 <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 06, 2014 at 02:58:01PM +0100, Stephane Eranian escreveu:
> On Thu, Feb 6, 2014 at 2:56 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
> >> If you run perf top on 3.14 but you force --stdio mode, perf top
> >> goes crazy and constantly refreshes the output.

> >> It does that with many older versions of the perf as well on 3.14.
> >> It runs fine with newt mode.

> >> Works fine with my 3.11 kernel. So something must be broken
> >> with 3.14.

> >> Can you reproduce the problem as well?

> > Not so far, using my perf/urgent branch:

> I am using tip.git. Or try 3.11, 3.10.

Tried torvalds/master, no problem, looking at what the top's screen
refresh thread does we can see:

[root@ssdandy ~]# trace -t 3562 -e \!write
     0.000 ( 0.000 ms):  ... [continued]: poll()) = 0 Timeout
  2031.522 (2002.480 ms): poll(ufds: 0x7fbb91596bb0, nfds: 1, timeout_msecs: 2000               ) = 0 Timeout
  4064.346 (2002.456 ms): poll(ufds: 0x7fbb91596bb0, nfds: 1, timeout_msecs: 2000               ) = 0 Timeout
^C[root@ssdandy ~]# 

I.e. waiting the default of:

                .delay_secs          = 2,

2 seconds between refreshes.

Checking out tip.tip, or are you suggesting to try an old perf binary, from
3.11 or 3.10 on top of a newer kernel?

- Arnaldo
