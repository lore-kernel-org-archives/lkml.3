Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaDOFjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:39:19 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41046 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOFjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <534C4E76.6000905@semaphore.gr>
References: <534C4E76.6000905@semaphore.gr>
Date: Tue, 15 Apr 2014 11:09:16 +0530
Message-ID: <CAKohpompoScQJVmYRpRmfx4rF1j0nFtBiPnfQyHtDM8mUEUkMQ@mail.gmail.com>
Subject: Re: [PATCH 07/20] cpufreq: exynos: Use cpufreq_for_each_entry macro
 for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 02:39, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> The cpufreq core supports the cpufreq_for_each_entry macro helper
> for iteration over the cpufreq_frequency_table, so use it.
>
> It should have no functional changes.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/exynos-cpufreq.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index f99cfe2..0e19bce 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -28,18 +28,18 @@ static unsigned int locking_frequency;
>
>  static int exynos_cpufreq_get_index(unsigned int freq)
>  {
> -       struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
> -       int index;
> +       struct cpufreq_frequency_table *pos, *freq_table;
>
> -       for (index = 0;
> -               freq_table[index].frequency != CPUFREQ_TABLE_END; index++)
> -               if (freq_table[index].frequency == freq)
> +       freq_table = exynos_info->freq_table;

Keep it as it was, i.e. fill freq_table during its definition. If with
addition of
pos it is crossing 80 columns, then define pos in a separate line.

> +       cpufreq_for_each_entry(pos, freq_table) {
> +               if (pos->frequency == freq)
>                         break;
> +       }
>
> -       if (freq_table[index].frequency == CPUFREQ_TABLE_END)
> +       if (pos->frequency == CPUFREQ_TABLE_END)
>                 return -EINVAL;
>
> -       return index;
> +       return pos - freq_table;
>  }
>
>  static int exynos_cpufreq_scale(unsigned int target_freq)
> --
> 1.9.0
