Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaBTPsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:48:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:33655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbaBTPsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:48:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208";a="486644107"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
References: <20140211132956.GY9987@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
	<20140217152859.GF15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
	<20140219101949.GG15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
	<20140220100830.GN6835@laptop.programming.kicks-ass.net>
Date: Thu, 20 Feb 2014 07:47:23 -0800
In-Reply-To: <20140220100830.GN6835@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 20 Feb 2014 11:08:30 +0100")
Message-ID: <87r46xdbw4.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Feb 19, 2014 at 05:34:49PM -0500, Vince Weaver wrote:
>> So where would the NMI counter event get disabled?  Would it never get 
>> disabled, just because it's always running and always gets the same fixed 
>> slot?  Why isn't this a problem all the time, not just with corner cases?
>
> Well it could get another counter assignment I suppose; there's no
> guarantee it always ends up in the fixed counter although that's rather
> likely.
>
>> Is somehow n_added getting confused?
>
> I'd expect worse than a warning if that happened, but who knows.
>
> You could try with the below; make sure you've got CONFIG_FUNCTION_TRACER=y.
>
> Then (assuming debugfs is mounted in /debug ; most modern distros have
> it at /sys/kernel/debug but they're wrong!):
>
> # echo 0 > /debug/tracing/tracing_on
> # echo function > /debug/tracing/current_tracer
> # echo nop > /debug/tracing/current_tracer
> # echo 0 > /debug/tracing/trace
> # echo 1 > /debug/tracing/tracing_on
>
> And make it go *BOOM*, then:
>
> # cat /debug/tracing/trace | bzip2 -9 > ~/trace.bz2

This won't work unless you apply this patch

http://lkml.org/lkml/2013/10/20/94

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
