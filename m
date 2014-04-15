Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaDOXrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:47:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56230 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaDOXr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:47:29 -0400
Message-ID: <534DC507.3010507@infradead.org>
Date: Tue, 15 Apr 2014 16:47:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] cpufreq: Introduce macros for cpufreq_frequency_table
 iteration
References: <534DB1DF.80506@semaphore.gr>
In-Reply-To: <534DB1DF.80506@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 03:25 PM, Stratos Karafotis wrote:
> Many cpufreq drivers need to iterate over the cpufreq_frequency_table
> for various tasks.
> 
> This patch introduces two macros which can be used for iteration over
> cpufreq_frequency_table keeping a common coding style across drivers:
> 
> - cpufreq_for_each_entry: iterate over each entry of the table
> - cpufreq_for_each_valid_entry: iterate over each entry that contains
> a valid frequency.
> 
> It should have no functional changes.
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  Documentation/cpu-freq/cpu-drivers.txt | 16 ++++++++++++++++
>  drivers/cpufreq/cpufreq.c              | 11 +++++++++++
>  include/linux/cpufreq.h                | 21 +++++++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
> index 48da5fd..2c9156a 100644
> --- a/Documentation/cpu-freq/cpu-drivers.txt
> +++ b/Documentation/cpu-freq/cpu-drivers.txt
> @@ -228,3 +228,19 @@ is the corresponding frequency table helper for the ->target
>  stage. Just pass the values to this function, and the unsigned int
>  index returns the number of the frequency table entry which contains
>  the frequency the CPU shall be set to.
> +
> +The following macros can be used as iterators over cpufreq_frequency_table:

<insert blank line>

> +cpufreq_for_each_entry(pos, table) - iterates over all entries of frequency
> +table.

<insert blank line>

> +cpufreq-for_each_valid_entry(pos, table) - iterates over all entries,
> +excluding CPUFREQ_ENTRY_INVALID frequencies.
> +Use arguments "pos" - a cpufreq_frequency_table * as a loop cursor and
> +"table" - the cpufreq_frequency_table * you want to iterate over.

<insert blank line>

> +For example:
> +
> +	struct cpufreq_frequency_table *pos, *driver_freq_table;
> +
> +	cpufreq_for_each_entry(pos, driver_freq_table) {
> +		/* Do something with pos */
> +		pos->frequency = ...
> +	}

> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 5ae5100..4f913b5 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -468,6 +468,27 @@ struct cpufreq_frequency_table {
>  				    * order */
>  };
>  
> +bool cpufreq_next_valid(struct cpufreq_frequency_table **pos);
> +
> +/*
> + * cpufreq_for_each_entry -	iterate over a cpufreq_frequency_table
> + * @pos:	the cpufreq_frequency_table * to use as a loop cursor.
> + * @table:	the cpufreq_frequency_table * to iterate over.
> + */
> +
> +#define cpufreq_for_each_entry(pos, table)	\
> +	for (pos = table; pos->frequency != CPUFREQ_TABLE_END; pos++)
> +
> +/*
> + * cpufreq_for_each_valid_entry -     iterate over a cpufreq_frequency_table
> + *	exluding CPUFREQ_ENTRY_INVALID frequencies.

        excluding

> + * @pos:        the cpufreq_frequency_table * to use as a loop cursor.
> + * @table:      the cpufreq_frequency_table * to iterate over.
> + */
> +
> +#define cpufreq_for_each_valid_entry(pos, table)	\
> +	for (pos = table; cpufreq_next_valid(&pos); pos++)
> +
>  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>  				    struct cpufreq_frequency_table *table);
>  
> 


-- 
~Randy
