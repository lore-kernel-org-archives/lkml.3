Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3APNPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:15:25 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58363 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753526Ab3APNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:15:24 -0500
Date: Wed, 16 Jan 2013 13:13:18 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zij@mx0.arm.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130116131318.GF16543@mudshark.cambridge.arm.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 01:39:50PM +0000, Jiri Olsa wrote:
> hi,

Hi Jiri,

> adding support to predefine event ratios formulas so they could
> be used easily in perf.
> 
> The formulas are handed in the config file with following format:
> 
>   set {
>         events = {cycles,instructions,branch-instructions}:u
> 
>         cpi {
>                 formula = cycles / instructions
>                 desc = cycles per instruction
>         }
> 
> 	branch-rate {
>                 formula = branch-instructions / instructions
>                 desc = branch rate
>         }
>   }
> 
>   The 'set' defines set of counter that share same events.
>   Each 'set' defines:
>     events   - event string that would go into stat/record -e option
>     counters - any number of counters based on above events
> 
>   Each counter (cpi/branch-rate) defines
>     formula - formula with that produce the counter number
>               event names and numbers could be used
>     desc    - text description of the counter
> 
> The formula can currently contain any event from the set::events
> plus any number (int). There'll be support in future for outside
> values runtime and other if needed.

Just to say that I *really* like this idea! If we extended it to include
other operators then it would help us on ARM, where we often have events
like 'cache accesses' and 'cache misses' but not 'cache hits'.

> My current thinking is to have generic formulas file(s) for architectural
> events and add arch-specific ones once when we have the support for
> non-architectural events (already sent RFC, v2 is on its way..).

Would the architectural formula files also be in userspace, or is there any
merit to including useful PMU-specific formulae in sysfs, along with the
other PMU files?

Cheers,

Will
