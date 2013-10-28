Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3J1N7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:59:53 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45630 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3J1N7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:59:52 -0400
Date: Mon, 28 Oct 2013 10:07:48 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Will Deacon <will.deacon@arm.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
In-Reply-To: <20131028085700.GB20218@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu> <20131028085700.GB20218@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013, Will Deacon wrote:

> This was in response to complaints from both internal users and people on
> public lists:
> 
>   http://www.mail-archive.com/perfmon2-devel@lists.sourceforge.net/msg02657.html
> 
> I believe the scenario was something like:
> 
>  (1) An instruction counter is set up to overflow after 200 instructions,
>      with a SIGIO handler to print some information. It is initially
>      disabled.
> 
>  (2) At some point, the counter is enabled for 1 overflow (IOC_REFRESH)
> 
>  (3) The counter eventually overflows and the SIGIO handler is triggered.
>      At this pointer the counter is disabled.
> 
>  (4) The signal handler changes the period to 200k instructions using
>      IOC_PERIOD and enables the counter for a further overflow.
> 
>  (5) SIGIO is taken after 200 instructions, rather than 200k.

It would be nice if changelogs for patches had this level of detail.

It's also a shame this change apprently didn't hit the linux-kernel list 
as far as I can tell.  I do my best to try to note all of the perf 
ABI-related changes there, but if things like this are going to start 
getting merged in architecture trees then things get that much harder 
to keep track of.

> I don't want to be the `oddball' architecture (at least, not more than I am
> already :), but I do find it tricky to follow the required semantics of perf
> as opposed to `it happens to work this way', especially when so much of it
> is buried in the various arch backends. So if somebody using the thing on
> ARM has (what looks to me like) a valid issue, then I usually try and fix
> it.

But it was global behavior that was common on all architectures.

Now any cross-platform tool like PAPI is going to have to have a mess of 
#ifdefs around every use of this ioctl, and it will only get worse if 
other architectures decide to "fix" the problem too.

Vince
