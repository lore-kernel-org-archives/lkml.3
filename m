Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3FZQK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:10:57 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46421 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3FZQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:10:56 -0400
Date: Wed, 26 Jun 2013 18:10:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>,
        Dave Chiluk <chiluk@canonical.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Scheduler accounting inflated for io bound processes.
Message-ID: <20130626161051.GA8207@gmail.com>
References: <51C35C05.1070005@canonical.com>
 <1372176104.7497.86.camel@marge.simpson.net>
 <1372182534.7497.129.camel@marge.simpson.net>
 <20130626093713.GA27385@gmail.com>
 <20130626104243.GE28407@twins.programming.kicks-ass.net>
 <20130626155048.GA7399@gmail.com>
 <51CB110E.6010707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB110E.6010707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 6/26/13 9:50 AM, Ingo Molnar wrote:
> >
> >* Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >>On Wed, Jun 26, 2013 at 11:37:13AM +0200, Ingo Molnar wrote:
> >>>Would be very nice to randomize the sampling rate, by randomizing the
> >>>intervals within a 1% range or so - perf tooling will probably recognize
> >>>the different weights.
> >>
> >>You're suggesting adding noise to the regular kernel tick?
> >
> >No, to the perf interval (which I assumed Mike was using to profile this?)
> >- although slightly randomizing the kernel tick might make sense as well,
> >especially if it's hrtimer driven and reprogrammed anyway.
> >
> >I might have gotten it all wrong though ...
> 
> Sampled S/W events like cpu-clock have a fixed rate 
> (perf_swevent_init_hrtimer converts freq to sample_period).
> 
> Sampled H/W events have an adaptive period that converges to the desired 
> sampling rate. The first few samples come in 10 usecs are so apart and 
> the time period expands to the desired rate. As I recall that adaptive 
> algorithm starts over every time the event is scheduled in.

Yes, but last I checked it (2 years ago? :-) the auto-freq code was 
converging pretty well to the time clock, with little jitter - in essence 
turning it into a fixed-period, fixed-frequency sampling method. That 
would explain Mike's results.

Thanks,

	Ingo
