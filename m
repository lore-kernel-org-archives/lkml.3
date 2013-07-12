Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3GLIrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:47:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36502 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab3GLIrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:47:32 -0400
Date: Fri, 12 Jul 2013 10:47:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Robert Richter <rric@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: boot tracing
Message-ID: <20130712084712.GD24008@pd.tnic>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
 <20130712082756.GA4328@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130712082756.GA4328@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:27:56AM +0200, Ingo Molnar wrote:
> Robert Richter and Boris Petkov are working on 'persistent events'
> support for perf, which will eventually allow boot time profiling -
> I'm not sure if the patches and the tooling support is ready enough
> yet for your purposes.

Nope, not yet but we're getting there.

> Robert, Boris, the following workflow would be pretty intuitive:
> 
>  - kernel developer sets boot flag: perf=boot,freq=1khz,size=16MB

What does perf=boot mean? I assume boot tracing.

If so, does it mean we want to enable *all* tracepoints and collect
whatever hits us?

What makes more sense to me is to hijack what the function tracer does -
i.e. simply collect all function calls.

>  - we'd get a single (cycles?) event running once the perf subsystem is up
>    and running, with a sampling frequency of 1 KHz, sending profiling
>    trace events to a sufficiently sized profiling buffer of 16 MB per
>    CPU.

Right, what would those trace events be?

>  - once the system reaches SYSTEM_RUNNING, profiling is stopped either
>    automatically - or the user stops it via a new tooling command.

Ok.

>  - the profiling buffer is extracted into a regular perf.data via a
>    special 'perf record' call or some other, new perf tooling 
>    solution/variant.
> 
>    [ Alternatively the kernel could attempt to construct a 'virtual'
>      perf.data from the persistent buffer, available via /sys/debug or
>      elsewhere in /sys - just like the kernel constructs a 'virtual' 
>      /proc/kcore, etc. That file could be copied or used directly. ]

Yeah, that.

>  - from that point on this workflow joins the regular profiling workflow: 
>    perf report, perf script et al can be used to analyze the resulting
>    boot profile.

Agreed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
