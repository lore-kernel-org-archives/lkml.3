Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaLHKxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:53:42 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55325 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaLHKxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:53:41 -0500
Date: Mon, 8 Dec 2014 11:53:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jacob Shin <jacob.w.shin@gmail.com>
Subject: Re: [GIT PULL][RESEND] hw_breakpoints: Support AMD range breakpoints
Message-ID: <20141208105333.GC22066@gmail.com>
References: <1417652025-2305-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417652025-2305-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core-v3 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	perf/core-v3
> 
> HEAD: 36748b9518a2437beffe861b47dff6d12b736b3f
> 
> It has been acked by Jiri and Oleg.
> ---
> Summary:
> 
> * Extend breakpoint tools and core to support address range through perf
>   event with initial backend support for AMD extended breakpoints.
>   Syntax is:
> 
>         perf record -e mem:addr/len:type
> 
>   For example set write breakpoint from 0x1000 to 0x1200 (0x1000 + 512)
> 
>         perf record -e mem:0x1000/512:w
> 
> * Clean up a bit breakpoint code validation
> ---
> 
> 
> Thanks,
> 	Frederic
> ---
> 
> Jacob Shin (4):
>       perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
>       perf tools: allow user to specify hardware breakpoint bp_len
>       perf tools: add hardware breakpoint bp_len test cases
>       perf/x86: Remove get_hbp_len and replace with bp_len
> 
> 
>  arch/x86/include/asm/cpufeature.h        |  2 ++
>  arch/x86/include/asm/debugreg.h          |  5 +++
>  arch/x86/include/asm/hw_breakpoint.h     |  1 +
>  arch/x86/include/uapi/asm/msr-index.h    |  4 +++
>  arch/x86/kernel/cpu/amd.c                | 19 +++++++++++
>  arch/x86/kernel/hw_breakpoint.c          | 45 ++++++++++---------------
>  tools/perf/Documentation/perf-record.txt |  7 ++--
>  tools/perf/tests/parse-events.c          | 58 ++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c           | 21 ++++++------
>  tools/perf/util/parse-events.h           |  2 +-
>  tools/perf/util/parse-events.l           |  1 +
>  tools/perf/util/parse-events.y           | 26 ++++++++++++--
>  12 files changed, 148 insertions(+), 43 deletions(-)

Pulled into tip:perf/hw_breakpoints, thanks Frederic!

It might not make it into v3.19, we'll see.

Thanks,

	Ingo
