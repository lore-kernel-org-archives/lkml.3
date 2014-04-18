Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaDRKZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:25:30 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51793 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaDRKZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:25:22 -0400
Date: Fri, 18 Apr 2014 12:25:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Don't mark DataLA addresses as store
Message-ID: <20140418102517.GA25473@gmail.com>
References: <1397777956-11466-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397777956-11466-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Haswell supports reporting the data address for a range
> of events, including UOPS_RETIRED.ALL and some load
> events. Currently these addresses were always marked
> as stores, which is wrong, as they could be loads too.
> Change it to NA instead.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index ae96cfa..7e9546a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -113,7 +113,7 @@ static u64 precise_store_data_hsw(u64 status)
>  	union perf_mem_data_src dse;
>  
>  	dse.val = 0;
> -	dse.mem_op = PERF_MEM_OP_STORE;
> +	dse.mem_op = PERF_MEM_OP_NA;
>  	dse.mem_lvl = PERF_MEM_LVL_NA;
>  	if (status & 1)
>  		dse.mem_lvl = PERF_MEM_LVL_L1;

NAK, this changelog is still deficient for the same reason it was 
deficient a month ago.

Thanks,

	Ingo
