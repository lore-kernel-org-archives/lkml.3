Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaDOFa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:30:56 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36346 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDOFay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <534C4E29.2020605@semaphore.gr>
References: <534C4E29.2020605@semaphore.gr>
Date: Tue, 15 Apr 2014 11:00:53 +0530
Message-ID: <CAKohpomsXSGARKmc5hamXb7joPp+8M8CyEKAbkZ0z7bJboHCdA@mail.gmail.com>
Subject: Re: [PATCH 01/20] cpufreq: Introduce macros for cpufreq_frequency_table
 iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 02:37, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
> @@ -193,9 +191,9 @@ int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
>                 return -ENOENT;
>         }
>
> -       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
> -               if (table[i].frequency == freq)
> -                       return i;
> +       cpufreq_for_each_entry(pos, table) {
> +               if (pos->frequency == freq)
> +                       return pos - table;
>         }

I asked you to do this in V1:

use cpufreq_for_each_valid_entry() here as well.
