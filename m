Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaDPENu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:13:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46931 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaDPENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:13:48 -0400
Date: Wed, 16 Apr 2014 13:13:46 +0900
From: Simon Horman <horms@verge.net.au>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-sh@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] sh: clk: Use cpufreq_for_each_valid_entry macro
 for iteration
Message-ID: <20140416041345.GC27534@verge.net.au>
References: <534DB238.5030201@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DB238.5030201@semaphore.gr>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 01:27:04AM +0300, Stratos Karafotis wrote:
> The cpufreq core now supports the cpufreq_for_each_valid_entry macro
> helper for iteration over the cpufreq_frequency_table, so use it.
> 
> It should have no functional changes.
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Rafael, please feel free to take this one.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/sh/clk/core.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
> index 7472785..be56b22 100644
> --- a/drivers/sh/clk/core.c
> +++ b/drivers/sh/clk/core.c
> @@ -196,17 +196,11 @@ int clk_rate_table_find(struct clk *clk,
>  			struct cpufreq_frequency_table *freq_table,
>  			unsigned long rate)
>  {
> -	int i;
> -
> -	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
> -		unsigned long freq = freq_table[i].frequency;
> +	struct cpufreq_frequency_table *pos;
>  
> -		if (freq == CPUFREQ_ENTRY_INVALID)
> -			continue;
> -
> -		if (freq == rate)
> -			return i;
> -	}
> +	cpufreq_for_each_valid_entry(pos, freq_table)
> +		if (pos->frequency == rate)
> +			return pos - freq_table;
>  
>  	return -ENOENT;
>  }
> @@ -575,11 +569,7 @@ long clk_round_parent(struct clk *clk, unsigned long target,
>  		return abs(target - *best_freq);
>  	}
>  
> -	for (freq = parent->freq_table; freq->frequency != CPUFREQ_TABLE_END;
> -	     freq++) {
> -		if (freq->frequency == CPUFREQ_ENTRY_INVALID)
> -			continue;
> -
> +	cpufreq_for_each_valid_entry(freq, parent->freq_table) {
>  		if (unlikely(freq->frequency / target <= div_min - 1)) {
>  			unsigned long freq_max;
>  
> -- 
> 1.9.0
> 
