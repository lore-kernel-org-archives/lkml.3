Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3J3OFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:05:19 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53840 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3J3OFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:05:18 -0400
Date: Wed, 30 Oct 2013 10:13:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@google.com
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
In-Reply-To: <20131030095615.GG16117@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1310301006190.8668@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu> <20131028085700.GB20218@mudshark.cambridge.arm.com> <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu> <20131029042810.GD22291@mudshark.cambridge.arm.com>
 <20131029134536.GD16117@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu> <20131030095615.GG16117@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-945360069-1383142404=:8668"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-945360069-1383142404=:8668
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Wed, 30 Oct 2013, Peter Zijlstra wrote:

> Right, it was one of those interfaces that people claimed were
> absolutely required so I implemented them but then nobody actually tried
> using them for a long while :-(

Well, the initial perf_event code drop was a big huge new interface 
without much documentation and it took a while for people to come up to 
speed on it.

People have tried to use PERF_EVENT_IOC_PERIOD but stopped because it was 
buggy.  It is still used, as someone complaining to me about the manpage 
description not matching reality is what started this whole thread.

There was a push for getting this issue fixed back in 2010 but it never 
went anywhere.

The userspace users will report bugs, but they are usually intimidated by 
the linux-kernel list and won't push along changes themselves.  Usually 
it's up to someone like me or Stephane to do that, and we miss things 
sometimes.

The users will just find a workaround and drop the issue, especially if 
it's going to take years before the fix shows up in RHEL or whatever 
ancient vendor kernel they are using.

> The below code should deal with both cases I think -- completely
> untested.

Uncompiled too I guess?

kernel/events/core.c: In function ¡perf_event_period¢:
kernel/events/core.c:3531: error: invalid type argument of ¡->¢ (have ¡local64_t¢)
make[3]: *** [kernel/events/core.o] Error 1

I also won't be able to test the ARM change, as my pandaboard won't boot 
with recent kernels (can't find the MMC root filesystem) and I haven't had 
time to track down why.  Also even on a simple period changing test it 
often fails due to lost interrupts (the Cortex-A9 lost interrupt errata?).

Vince
--8323329-945360069-1383142404=:8668--
