Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab3JaIPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:15:14 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45286 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JaIPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:15:11 -0400
Date: Thu, 31 Oct 2013 09:15:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: print microcode revision on PEBs errors
Message-ID: <20131031081507.GA8922@gmail.com>
References: <20131030193150.GA7765@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030193150.GA7765@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> On Sandy bridge CPUs with old microcode, PEBs
> fails and suggests a microcode update.
> Print out the required and the actual revision to
> make it easier to figure out what's wrong.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index f31a165..81f2789 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2105,6 +2105,8 @@ static int intel_snb_pebs_broken(int cpu)
>  		}
>  	}
>  
> +	pr_info("PEBS checking: microcode 0x%x min legal 0x%x\n",
> +		cpu_data(cpu).microcode, rev);

That's not a very informative message though.

Something like:

   "x86/perf/intel: PEBS turned off due to too old microcode version 0x%x\n"
   "x86/perf/intel: Minimum required microcode version for PEBS: 0x%x\n"

would work better I think.

Also, only output this once, and only output it if the check 
_fails_.

>  	return (cpu_data(cpu).microcode < rev);

Btw., please also fix the return statement, it doesn't need 
parentheses.

Thanks,

	Ingo
